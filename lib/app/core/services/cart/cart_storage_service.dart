/// Cart Storage Service for Cartify
/// Handles local storage and caching of cart data for better performance
/// and offline access to cart contents

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../models/cart_models.dart';
import '../log_service.dart';

/// Service for cart data storage and caching
class CartStorageService extends GetxService {
  static final GetStorage _storage = GetStorage();

  // Storage keys
  static const String _cartKey = 'user_cart';
  static const String _cartLastUpdateKey = 'cart_last_update';

  // Observable cart data
  final Rx<Cart?> _currentCart = Rx<Cart?>(null);
  final RxInt _totalItems = 0.obs;
  final RxDouble _totalValue = 0.0.obs;
  final Rx<DateTime?> _lastUpdate = Rx<DateTime?>(null);

  // Getters for reactive state
  Cart? get currentCart => _currentCart.value;
  int get totalItems => _totalItems.value;
  double get totalValue => _totalValue.value;
  DateTime? get lastUpdate => _lastUpdate.value;

  // Reactive getters
  Rx<Cart?> get currentCartRx => _currentCart;
  RxInt get totalItemsRx => _totalItems;
  RxDouble get totalValueRx => _totalValue;

  @override
  Future<void> onInit() async {
    super.onInit();
    await _loadStoredCartData();
  }

  /// Load stored cart data on app start
  Future<void> _loadStoredCartData() async {
    try {
      LogService.info('Loading stored cart data');

      // Load last update time
      final lastUpdateString = _storage.read<String>(_cartLastUpdateKey);
      if (lastUpdateString != null) {
        _lastUpdate.value = DateTime.parse(lastUpdateString);
      }

      // Load cart data
      final cartData = _storage.read<Map<String, dynamic>>(_cartKey);
      if (cartData != null) {
        _currentCart.value = Cart.fromJson(cartData);
        _updateCartSummary();
        LogService.info('Cart loaded from storage with ${totalItems} items');
      }
    } catch (e) {
      LogService.error('Error loading stored cart data: $e');
    }
  }

  // ============================================================================
  // CART STORAGE OPERATIONS
  // ============================================================================

  /// Save cart to storage
  Future<void> saveCart(Cart cart) async {
    try {
      LogService.info('Saving cart to storage');

      await _storage.write(_cartKey, cart.toJson());
      await _storage.write(
        _cartLastUpdateKey,
        DateTime.now().toIso8601String(),
      );

      _currentCart.value = cart;
      _lastUpdate.value = DateTime.now();
      _updateCartSummary();

      LogService.info('Cart saved successfully with ${cart.totalItems} items');
    } catch (e) {
      LogService.error('Error saving cart: $e');
      throw Exception('Failed to save cart');
    }
  }

  /// Update cart summary values
  void _updateCartSummary() {
    final cart = _currentCart.value;
    if (cart != null) {
      _totalItems.value = cart.totalItems;
      _totalValue.value = cart.totalValue;
    } else {
      _totalItems.value = 0;
      _totalValue.value = 0.0;
    }
  }

  // ============================================================================
  // CART ITEM OPERATIONS
  // ============================================================================

  /// Add item to local cart
  Future<void> addItemToLocalCart(CartItem item) async {
    try {
      final cart = _currentCart.value;
      if (cart == null) {
        LogService.warning('No cart exists, cannot add item locally');
        return;
      }

      LogService.info('Adding item to local cart: ${item.productId}');

      final updatedItems = List<CartItem>.from(cart.items);

      // Check if item already exists
      final existingIndex = updatedItems.indexWhere(
        (cartItem) => cartItem.productId == item.productId,
      );

      if (existingIndex != -1) {
        // Update existing item quantity
        final existingItem = updatedItems[existingIndex];
        updatedItems[existingIndex] = existingItem.copyWith(
          quantity: existingItem.quantity + item.quantity,
        );
      } else {
        // Add new item
        updatedItems.add(item);
      }

      final updatedCart = Cart(
        id: cart.id,
        userId: cart.userId,
        items: updatedItems,
        createdAt: cart.createdAt,
        updatedAt: DateTime.now(),
      );

      await saveCart(updatedCart);
    } catch (e) {
      LogService.error('Error adding item to local cart: $e');
    }
  }

  /// Update cart item quantity locally
  Future<void> updateItemQuantityLocally(String itemId, int newQuantity) async {
    try {
      final cart = _currentCart.value;
      if (cart == null) return;

      LogService.info(
        'Updating item quantity locally: $itemId (qty: $newQuantity)',
      );

      final updatedItems = List<CartItem>.from(cart.items);
      final itemIndex = updatedItems.indexWhere((item) => item.id == itemId);

      if (itemIndex != -1) {
        if (newQuantity <= 0) {
          // Remove item if quantity is 0 or less
          updatedItems.removeAt(itemIndex);
        } else {
          // Update quantity
          updatedItems[itemIndex] = updatedItems[itemIndex].copyWith(
            quantity: newQuantity,
          );
        }

        final updatedCart = Cart(
          id: cart.id,
          userId: cart.userId,
          items: updatedItems,
          createdAt: cart.createdAt,
          updatedAt: DateTime.now(),
        );

        await saveCart(updatedCart);
      }
    } catch (e) {
      LogService.error('Error updating item quantity locally: $e');
    }
  }

  /// Remove item from local cart
  Future<void> removeItemFromLocalCart(String itemId) async {
    try {
      final cart = _currentCart.value;
      if (cart == null) return;

      LogService.info('Removing item from local cart: $itemId');

      final updatedItems = List<CartItem>.from(cart.items);
      updatedItems.removeWhere((item) => item.id == itemId);

      final updatedCart = Cart(
        id: cart.id,
        userId: cart.userId,
        items: updatedItems,
        createdAt: cart.createdAt,
        updatedAt: DateTime.now(),
      );

      await saveCart(updatedCart);
    } catch (e) {
      LogService.error('Error removing item from local cart: $e');
    }
  }

  /// Clear local cart
  Future<void> clearLocalCart() async {
    try {
      LogService.info('Clearing local cart');

      await _storage.remove(_cartKey);
      await _storage.remove(_cartLastUpdateKey);

      _currentCart.value = null;
      _lastUpdate.value = null;
      _updateCartSummary();

      LogService.info('Local cart cleared successfully');
    } catch (e) {
      LogService.error('Error clearing local cart: $e');
    }
  }

  // ============================================================================
  // CART QUERIES
  // ============================================================================

  /// Check if cart is empty
  bool get isCartEmpty {
    return _currentCart.value?.isEmpty ?? true;
  }

  /// Check if cart has items
  bool get hasItems {
    return !isCartEmpty;
  }

  /// Get cart items count
  int getItemsCount() {
    return _currentCart.value?.totalItems ?? 0;
  }

  /// Get cart total value
  double getTotalValue() {
    return _currentCart.value?.totalValue ?? 0.0;
  }

  /// Get formatted total value
  String getFormattedTotal() {
    return _currentCart.value?.formattedTotal ?? '₹0.00';
  }

  /// Check if product is in cart
  bool isProductInCart(String productId) {
    final cart = _currentCart.value;
    if (cart == null) return false;

    return cart.items.any((item) => item.productId == productId);
  }

  /// Get cart item for specific product
  CartItem? getCartItemForProduct(String productId) {
    final cart = _currentCart.value;
    if (cart == null) return null;

    try {
      return cart.items.firstWhere((item) => item.productId == productId);
    } catch (e) {
      return null;
    }
  }

  /// Get quantity of specific product in cart
  int getProductQuantityInCart(String productId) {
    final cartItem = getCartItemForProduct(productId);
    return cartItem?.quantity ?? 0;
  }

  /// Get all cart items
  List<CartItem> getAllItems() {
    return _currentCart.value?.items ?? [];
  }

  /// Get cart item by ID
  CartItem? getCartItemById(String itemId) {
    final cart = _currentCart.value;
    if (cart == null) return null;

    try {
      return cart.items.firstWhere((item) => item.id == itemId);
    } catch (e) {
      return null;
    }
  }

  // ============================================================================
  // CART STATISTICS
  // ============================================================================

  /// Get cart statistics
  Map<String, dynamic> getCartStatistics() {
    final cart = _currentCart.value;

    return {
      'total_items': totalItems,
      'unique_products': cart?.items.length ?? 0,
      'total_value': totalValue,
      'formatted_total': getFormattedTotal(),
      'is_empty': isCartEmpty,
      'last_update': _lastUpdate.value?.toIso8601String(),
    };
  }

  /// Get cart summary for display
  String getCartSummary() {
    if (isCartEmpty) {
      return 'Cart is empty';
    }

    final cart = _currentCart.value!;
    return '${cart.totalItems} item${cart.totalItems > 1 ? 's' : ''} - ${cart.formattedTotal}';
  }

  // ============================================================================
  // CART VALIDATION
  // ============================================================================

  /// Validate local cart data
  bool validateLocalCart() {
    final cart = _currentCart.value;
    if (cart == null) return true; // Empty cart is valid

    try {
      // Basic validation
      if (cart.items.any((item) => item.quantity <= 0)) {
        LogService.warning('Cart contains items with invalid quantity');
        return false;
      }

      if (cart.items.any((item) => item.unitPrice <= 0)) {
        LogService.warning('Cart contains items with invalid price');
        return false;
      }

      return true;
    } catch (e) {
      LogService.error('Error validating local cart: $e');
      return false;
    }
  }

  /// Check if cart needs sync with server
  bool needsSync() {
    // You can implement logic to determine if local cart is out of sync
    // For example, check if last update is too old
    return false;
  }
}
