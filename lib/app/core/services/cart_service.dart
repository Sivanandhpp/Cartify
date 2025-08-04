import 'package:get/get.dart';
import '../models/cart_item_model.dart';
import '../models/product_model.dart';
import 'log_service.dart';
import 'notification_service.dart';
import 'cart_storage_service.dart';
import 'api_services/cart_api_service.dart';

/// Simplified cart management service
///
/// Handles cart operations with API integration and local storage.
/// Focuses on essential functionality without over-engineering.
class CartService extends GetxService {
  static CartService get instance => Get.find<CartService>();

  // ============================================================================
  // STATE MANAGEMENT
  // ============================================================================

  final RxList<CartItem> _cartItems = <CartItem>[].obs;
  final RxBool _isLoading = false.obs;

  // ============================================================================
  // GETTERS
  // ============================================================================

  List<CartItem> get cartItems => _cartItems.toList();
  bool get isEmpty => _cartItems.isEmpty;
  bool get isNotEmpty => _cartItems.isNotEmpty;
  bool get isLoading => _isLoading.value;
  int get itemCount => _cartItems.length;
  int get totalQuantity =>
      _cartItems.fold(0, (sum, item) => sum + item.quantity);
  double get subtotal => _cartItems.fold(0.0, (sum, item) {
    final price = item.discountPrice ?? item.price;
    return sum + (price * item.quantity);
  });

  // ============================================================================
  // INITIALIZATION
  // ============================================================================

  @override
  void onInit() {
    super.onInit();
    LogService.info('CartService initialized');
    _loadFromStorage();
  }

  void _loadFromStorage() {
    try {
      final items = CartStorageService.loadCartItems();
      _cartItems.assignAll(items);
      LogService.info('Cart loaded from storage: ${items.length} items');
    } catch (e) {
      LogService.error('Failed to load cart from storage', e);
    }
  }

  Future<void> _saveToStorage() async {
    try {
      await CartStorageService.saveCartItems(_cartItems);
    } catch (e) {
      LogService.error('Failed to save cart to storage', e);
    }
  }

  // ============================================================================
  // CART OPERATIONS
  // ============================================================================

  /// Add item to cart
  Future<bool> addToCart(Product product, {int quantity = 1}) async {
    try {
      _isLoading.value = true;

      LogService.business('Adding item to cart', {
        'productId': product.id,
        'productName': product.name,
        'quantity': quantity,
      });

      // Try API first
      final result = await CartApiService.addItemToCart(
        productId: product.id,
        quantity: quantity,
      );

      if (result['success']) {
        // Update local state
        await _addToCartLocally(product, quantity: quantity);

        NotificationService.showSuccess(
          title: 'Added to Cart',
          message: '${product.name} has been added to your cart',
          duration: const Duration(seconds: 2),
        );
        return true;
      } else {
        // Fallback to local only
        await _addToCartLocally(product, quantity: quantity);

        NotificationService.showInfo(
          title: 'Added Offline',
          message: 'Item added locally. Will sync when online.',
        );
        return false;
      }
    } catch (e) {
      LogService.error('Error adding item to cart', e);
      // Fallback to local operation
      await _addToCartLocally(product, quantity: quantity);
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  /// Add item locally
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

      if (newQuantity <= 0) {
        return await removeFromCart(cartItemId);
      }

      LogService.business('Updating cart item quantity', {
        'cartItemId': cartItemId,
        'newQuantity': newQuantity,
      });

      // Try API first
      final result = await CartApiService.updateCartItemQuantity(
        cartItemId: cartItemId,
        quantity: newQuantity,
      );

      if (result['success']) {
        _updateQuantityLocally(cartItemId, newQuantity);
        return true;
      } else {
        // Fallback to local
        _updateQuantityLocally(cartItemId, newQuantity);
        return false;
      }
    } catch (e) {
      LogService.error('Error updating cart item quantity', e);
      _updateQuantityLocally(cartItemId, newQuantity);
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  /// Update quantity locally
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

      LogService.business('Removing item from cart', {
        'cartItemId': cartItemId,
      });

      // Try API first
      final result = await CartApiService.removeCartItem(cartItemId);

      if (result['success']) {
        _removeFromCartLocally(cartItemId);

        NotificationService.showInfo(
          title: 'Removed from Cart',
          message: 'Item has been removed from your cart',
          duration: const Duration(seconds: 2),
        );
        return true;
      } else {
        // Fallback to local
        _removeFromCartLocally(cartItemId);
        return false;
      }
    } catch (e) {
      LogService.error('Error removing item from cart', e);
      _removeFromCartLocally(cartItemId);
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  /// Remove item locally
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

      LogService.business('Clearing entire cart');

      // Try API first
      final result = await CartApiService.clearCart();

      if (result['success']) {
        await _clearCartLocally();

        NotificationService.showInfo(
          title: 'Cart Cleared',
          message: 'All items have been removed from your cart',
          duration: const Duration(seconds: 2),
        );
        return true;
      } else {
        // Fallback to local
        await _clearCartLocally();
        return false;
      }
    } catch (e) {
      LogService.error('Error clearing cart', e);
      await _clearCartLocally();
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  /// Clear cart locally
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

  /// Get simplified cart summary
  Map<String, dynamic> getCartSummary() {
    return {
      'items': cartItems.map((item) => item.toJson()).toList(),
      'itemCount': itemCount,
      'totalQuantity': totalQuantity,
      'subtotal': subtotal,
      'isEmpty': isEmpty,
    };
  }
}
