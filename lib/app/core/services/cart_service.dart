import 'package:get/get.dart';
import '../models/cart_item_model.dart';
import '../models/product_model.dart';
import 'log_service.dart';
import 'notification_service.dart';
import 'cart_storage_service.dart';
import 'cart_api_service.dart';

/// Production-level cart management service
///
/// This service handles all cart operations with API integration, local storage sync,
/// offline support, and comprehensive error handling. Follows clean architecture
/// principles with separation of concerns.
class CartService extends GetxService {
  static CartService get instance => Get.find<CartService>();

  // ============================================================================
  // REACTIVE STATE MANAGEMENT
  // ============================================================================

  // Observable cart items
  final RxList<CartItem> _cartItems = <CartItem>[].obs;

  // Observable cart metadata
  final RxString _cartId = ''.obs;
  final RxString _userId = ''.obs;
  final RxBool _isLoading = false.obs;
  final RxBool _isSyncing = false.obs;
  final RxString _lastError = ''.obs;

  // ============================================================================
  // PUBLIC GETTERS
  // ============================================================================

  // Cart data
  List<CartItem> get cartItems => _cartItems.toList();
  String get cartId => _cartId.value;
  String get userId => _userId.value;

  // Cart state
  bool get isEmpty => _cartItems.isEmpty;
  bool get isNotEmpty => _cartItems.isNotEmpty;
  bool get isLoading => _isLoading.value;
  bool get isSyncing => _isSyncing.value;
  String get lastError => _lastError.value;

  // Cart metrics
  int get itemCount => _cartItems.length;
  int get totalQuantity =>
      _cartItems.fold(0, (sum, item) => sum + item.quantity);

  // Cart calculations
  double get subtotal => _cartItems.fold(0.0, (sum, item) {
    final price = item.discountPrice ?? item.price;
    return sum + (price * item.quantity);
  });

  // ============================================================================
  // LIFECYCLE MANAGEMENT
  // ============================================================================

  @override
  void onInit() {
    super.onInit();
    LogService.info('CartService initialized');
    _initializeCart();
  }

  /// Initialize cart service - load from storage and sync with API
  Future<void> _initializeCart() async {
    try {
      _isLoading.value = true;

      // Load from local storage first for immediate UI response
      _loadFromStorage();

      // Then sync with API in background
      await _syncWithApi();
    } catch (e) {
      LogService.error('Failed to initialize cart', e);
      _lastError.value = 'Failed to initialize cart';
    } finally {
      _isLoading.value = false;
    }
  }

  /// Load cart items from local storage
  void _loadFromStorage() {
    try {
      final items = CartStorageService.loadCartItems();
      _cartItems.assignAll(items);
      LogService.info('Cart loaded from storage: ${items.length} items');
    } catch (e) {
      LogService.error('Failed to load cart from storage', e);
    }
  }

  /// Sync cart with API
  Future<void> _syncWithApi() async {
    try {
      _isSyncing.value = true;
      _lastError.value = '';

      final result = await CartApiService.getCart();

      if (result['success']) {
        final cartData = result['data'];
        _updateCartFromApiData(cartData);
        await _saveToStorage();
        LogService.info('Cart synced with API successfully');
      } else {
        _lastError.value = result['message'] ?? 'Failed to sync with API';
        LogService.warning('Cart sync failed: ${_lastError.value}');
      }
    } catch (e) {
      LogService.error('Error syncing cart with API', e);
      _lastError.value = 'Network error during sync';
    } finally {
      _isSyncing.value = false;
    }
  }

  /// Update local cart from API response data
  void _updateCartFromApiData(Map<String, dynamic> cartData) {
    try {
      _cartId.value = cartData['id'] ?? '';
      _userId.value = cartData['user_id'] ?? '';

      final items =
          (cartData['items'] as List?)?.map((itemData) {
            return CartItem.fromApiJson(itemData);
          }).toList() ??
          <CartItem>[];

      _cartItems.assignAll(items);
      LogService.debug('Cart updated from API data: ${items.length} items');
    } catch (e) {
      LogService.error('Failed to update cart from API data', e);
    }
  }

  /// Save cart items to local storage
  Future<void> _saveToStorage() async {
    try {
      await CartStorageService.saveCartItems(_cartItems);
    } catch (e) {
      LogService.error('Failed to save cart to storage', e);
    }
  }

  // ============================================================================
  // CART OPERATIONS - API FIRST WITH LOCAL FALLBACK
  // ============================================================================

  /// Add item to cart
  Future<bool> addToCart(Product product, {int quantity = 1}) async {
    try {
      _isLoading.value = true;
      _lastError.value = '';

      LogService.business('Adding item to cart', {
        'productId': product.id,
        'productName': product.name,
        'quantity': quantity,
      });

      final result = await CartApiService.addItemToCart(
        productId: product.id,
        quantity: quantity,
      );

      if (result['success']) {
        // Update local state from API response
        _updateCartFromApiData(result['data']);
        await _saveToStorage();

        NotificationService.showSuccess(
          title: 'Added to Cart',
          message: '${product.name} has been added to your cart',
          duration: const Duration(seconds: 2),
        );

        return true;
      } else {
        _lastError.value = result['message'] ?? 'Failed to add item';

        // Fallback: Add locally if API fails
        await _addToCartLocally(product, quantity: quantity);

        NotificationService.showError(
          title: 'Added Offline',
          message: 'Item added locally. Will sync when online.',
        );

        return false;
      }
    } catch (e) {
      LogService.error('Error adding item to cart', e);
      _lastError.value = 'Network error occurred';

      // Fallback to local operation
      await _addToCartLocally(product, quantity: quantity);
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  /// Local fallback for adding items to cart
  Future<void> _addToCartLocally(Product product, {int quantity = 1}) async {
    try {
      final existingIndex = _cartItems.indexWhere(
        (item) => item.productId == product.id,
      );

      if (existingIndex != -1) {
        // Update existing item
        _cartItems[existingIndex] = _cartItems[existingIndex].copyWith(
          quantity: _cartItems[existingIndex].quantity + quantity,
        );
      } else {
        // Add new item
        final cartItem = CartItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          productId: product.id,
          productName: product.name,
          productImage: product.imageUrl,
          price: product.priceINR,
          discountPrice: product.offerPrice,
          quantity: quantity,
          addedAt: DateTime.now(),
        );
        _cartItems.add(cartItem);
      }

      await _saveToStorage();
      LogService.info('Item added to cart locally');
    } catch (e) {
      LogService.error('Failed to add item locally', e);
    }
  }

  /// Update cart item quantity
  Future<bool> updateQuantity(String cartItemId, int newQuantity) async {
    try {
      _isLoading.value = true;
      _lastError.value = '';

      if (newQuantity <= 0) {
        return await removeFromCart(cartItemId);
      }

      LogService.business('Updating cart item quantity', {
        'cartItemId': cartItemId,
        'newQuantity': newQuantity,
      });

      final result = await CartApiService.updateCartItemQuantity(
        cartItemId: cartItemId,
        quantity: newQuantity,
      );

      if (result['success']) {
        _updateCartFromApiData(result['data']);
        await _saveToStorage();
        return true;
      } else {
        _lastError.value = result['message'] ?? 'Failed to update quantity';

        // Fallback: Update locally
        _updateQuantityLocally(cartItemId, newQuantity);
        return false;
      }
    } catch (e) {
      LogService.error('Error updating cart item quantity', e);
      _lastError.value = 'Network error occurred';

      // Fallback to local operation
      _updateQuantityLocally(cartItemId, newQuantity);
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  /// Local fallback for updating quantity
  void _updateQuantityLocally(String cartItemId, int newQuantity) {
    try {
      final itemIndex = _cartItems.indexWhere((item) => item.id == cartItemId);
      if (itemIndex != -1) {
        _cartItems[itemIndex] = _cartItems[itemIndex].copyWith(
          quantity: newQuantity,
        );
        _saveToStorage();
        LogService.info('Quantity updated locally');
      }
    } catch (e) {
      LogService.error('Failed to update quantity locally', e);
    }
  }

  /// Remove item from cart
  Future<bool> removeFromCart(String cartItemId) async {
    try {
      _isLoading.value = true;
      _lastError.value = '';

      LogService.business('Removing item from cart', {
        'cartItemId': cartItemId,
      });

      final result = await CartApiService.removeCartItem(cartItemId);

      if (result['success']) {
        _updateCartFromApiData(result['data']);
        await _saveToStorage();

        NotificationService.showInfo(
          title: 'Removed from Cart',
          message: 'Item has been removed from your cart',
          duration: const Duration(seconds: 2),
        );

        return true;
      } else {
        _lastError.value = result['message'] ?? 'Failed to remove item';

        // Fallback: Remove locally
        _removeFromCartLocally(cartItemId);
        return false;
      }
    } catch (e) {
      LogService.error('Error removing item from cart', e);
      _lastError.value = 'Network error occurred';

      // Fallback to local operation
      _removeFromCartLocally(cartItemId);
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  /// Local fallback for removing items
  void _removeFromCartLocally(String cartItemId) {
    try {
      _cartItems.removeWhere((item) => item.id == cartItemId);
      _saveToStorage();
      LogService.info('Item removed locally');
    } catch (e) {
      LogService.error('Failed to remove item locally', e);
    }
  }

  /// Clear entire cart
  Future<bool> clearCart() async {
    try {
      _isLoading.value = true;
      _lastError.value = '';

      LogService.business('Clearing entire cart');

      final result = await CartApiService.clearCart();

      if (result['success']) {
        _updateCartFromApiData(result['data']);
        await _saveToStorage();

        NotificationService.showInfo(
          title: 'Cart Cleared',
          message: 'All items have been removed from your cart',
          duration: const Duration(seconds: 2),
        );

        return true;
      } else {
        _lastError.value = result['message'] ?? 'Failed to clear cart';

        // Fallback: Clear locally
        await _clearCartLocally();
        return false;
      }
    } catch (e) {
      LogService.error('Error clearing cart', e);
      _lastError.value = 'Network error occurred';

      // Fallback to local operation
      await _clearCartLocally();
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  /// Local fallback for clearing cart
  Future<void> _clearCartLocally() async {
    try {
      _cartItems.clear();
      await CartStorageService.clearCartStorage();
      LogService.info('Cart cleared locally');
    } catch (e) {
      LogService.error('Failed to clear cart locally', e);
    }
  }

  // ============================================================================
  // CONVENIENCE METHODS
  // ============================================================================

  /// Increment quantity of a product in cart
  Future<bool> incrementQuantity(String productId) async {
    final item = getCartItem(productId);
    if (item != null) {
      return await updateQuantity(item.id, item.quantity + 1);
    }
    return false;
  }

  /// Decrement quantity of a product in cart
  Future<bool> decrementQuantity(String productId) async {
    final item = getCartItem(productId);
    if (item != null) {
      if (item.quantity > 1) {
        return await updateQuantity(item.id, item.quantity - 1);
      } else {
        return await removeFromCart(item.id);
      }
    }
    return false;
  }

  /// Check if product is in cart
  bool isInCart(String productId) {
    return _cartItems.any((item) => item.productId == productId);
  }

  /// Get cart item for a product
  CartItem? getCartItem(String productId) {
    try {
      return _cartItems.firstWhere((item) => item.productId == productId);
    } catch (e) {
      return null;
    }
  }

  /// Get quantity of a specific product in cart
  int getQuantity(String productId) {
    final item = getCartItem(productId);
    return item?.quantity ?? 0;
  }

  /// Get cart summary for checkout
  Map<String, dynamic> getCartSummary() {
    return {
      'cartId': cartId,
      'userId': userId,
      'items': cartItems.map((item) => item.toJson()).toList(),
      'itemCount': itemCount,
      'totalQuantity': totalQuantity,
      'subtotal': subtotal,
      'isEmpty': isEmpty,
      'lastSyncError': lastError,
    };
  }

  /// Retry sync with API
  Future<bool> retrySync() async {
    await _syncWithApi();
    return _lastError.value.isEmpty;
  }

  /// Force refresh from API
  Future<bool> refreshFromApi() async {
    return await retrySync();
  }
}
