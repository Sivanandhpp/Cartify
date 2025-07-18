import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../config/app_config.dart';
import '../models/cart_item_model.dart';
import '../models/product_model.dart';
import 'log_service.dart';
import 'notification_service.dart';

/// Production-level cart management service
///
/// This service handles all cart operations including adding/removing items,
/// calculating totals, applying discounts, and persisting cart state.
class CartService extends GetxService {
  static CartService get instance => Get.find<CartService>();

  // Storage instance
  final GetStorage _storage = GetStorage();

  // Observable cart items
  final RxList<CartItem> _cartItems = <CartItem>[].obs;

  // Observable cart totals
  final RxDouble _subtotal = 0.0.obs;
  final RxDouble _tax = 0.0.obs;
  final RxDouble _shipping = 0.0.obs;
  final RxDouble _discount = 0.0.obs;
  final RxDouble _total = 0.0.obs;

  // Cart settings
  final RxBool _isLoading = false.obs;
  final RxString _appliedCoupon = ''.obs;

  // Getters
  List<CartItem> get cartItems => _cartItems.toList();
  int get itemCount => _cartItems.length;
  int get totalQuantity =>
      _cartItems.fold(0, (sum, item) => sum + item.quantity);
  double get subtotal => _subtotal.value;
  double get tax => _tax.value;
  double get shipping => _shipping.value;
  double get discount => _discount.value;
  double get total => _total.value;
  bool get isEmpty => _cartItems.isEmpty;
  bool get isNotEmpty => _cartItems.isNotEmpty;
  bool get isLoading => _isLoading.value;
  String get appliedCoupon => _appliedCoupon.value;

  @override
  void onInit() {
    super.onInit();
    LogService.info('CartService initialized');
    _loadCartFromStorage();
  }

  /// Load cart items from local storage
  void _loadCartFromStorage() {
    try {
      final cartData = _storage.read<List>(AppConfig.cartStorageKey);
      if (cartData != null) {
        _cartItems.value = cartData
            .map((item) => CartItem.fromJson(Map<String, dynamic>.from(item)))
            .toList();
        _calculateTotals();
        LogService.info('Cart loaded from storage: ${_cartItems.length} items');
      }
    } catch (e) {
      LogService.error('Failed to load cart from storage', e);
    }
  }

  /// Save cart items to local storage
  Future<void> _saveCartToStorage() async {
    try {
      final cartData = _cartItems.map((item) => item.toJson()).toList();
      await _storage.write(AppConfig.cartStorageKey, cartData);
      LogService.debug('Cart saved to storage: ${_cartItems.length} items');
    } catch (e) {
      LogService.error('Failed to save cart to storage', e);
    }
  }

  /// Add item to cart
  Future<void> addToCart(Product product, {int quantity = 1}) async {
    try {
      _isLoading.value = true;

      // Check if item already exists in cart
      final existingIndex = _cartItems.indexWhere(
        (item) => item.productId == product.id,
      );

      if (existingIndex != -1) {
        // Update quantity of existing item
        _cartItems[existingIndex] = _cartItems[existingIndex].copyWith(
          quantity: _cartItems[existingIndex].quantity + quantity,
        );
        LogService.business('Updated cart item quantity', {
          'productId': product.id,
          'newQuantity': _cartItems[existingIndex].quantity,
        });
      } else {
        // Add new item to cart
        final cartItem = CartItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          productId: product.id,
          productName: product.name,
          productImage: product.imageUrl,
          price: product.price,
          discountPrice: product.discountPrice,
          quantity: quantity,
          addedAt: DateTime.now(),
        );

        _cartItems.add(cartItem);
        LogService.business('Added item to cart', {
          'productId': product.id,
          'quantity': quantity,
          'price': product.price,
        });
      }

      _calculateTotals();
      await _saveCartToStorage();

      // Show success message
      NotificationService.showSuccess(
        title: 'Added to Cart',
        message: '${product.name} has been added to your cart',
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      LogService.error('Failed to add item to cart', e);
      NotificationService.showError(
        title: 'Error',
        message: 'Failed to add item to cart. Please try again.',
      );
    } finally {
      _isLoading.value = false;
    }
  }

  /// Remove item from cart
  Future<void> removeFromCart(String cartItemId) async {
    try {
      _isLoading.value = true;

      final removedItem = _cartItems.firstWhere(
        (item) => item.id == cartItemId,
      );
      _cartItems.removeWhere((item) => item.id == cartItemId);

      LogService.business('Removed item from cart', {
        'cartItemId': cartItemId,
        'productId': removedItem.productId,
      });

      _calculateTotals();
      await _saveCartToStorage();

      NotificationService.showInfo(
        title: 'Removed from Cart',
        message: '${removedItem.productName} has been removed from your cart',
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      LogService.error('Failed to remove item from cart', e);
    } finally {
      _isLoading.value = false;
    }
  }

  /// Update item quantity
  Future<void> updateQuantity(String cartItemId, int newQuantity) async {
    try {
      if (newQuantity <= 0) {
        await removeFromCart(cartItemId);
        return;
      }

      final itemIndex = _cartItems.indexWhere((item) => item.id == cartItemId);
      if (itemIndex != -1) {
        _cartItems[itemIndex] = _cartItems[itemIndex].copyWith(
          quantity: newQuantity,
        );

        LogService.business('Updated cart item quantity', {
          'cartItemId': cartItemId,
          'newQuantity': newQuantity,
        });

        _calculateTotals();
        await _saveCartToStorage();
      }
    } catch (e) {
      LogService.error('Failed to update item quantity', e);
    }
  }

  /// Clear entire cart
  Future<void> clearCart() async {
    try {
      _isLoading.value = true;
      _cartItems.clear();
      _appliedCoupon.value = '';

      LogService.business('Cart cleared');

      _calculateTotals();
      await _saveCartToStorage();

      NotificationService.showInfo(
        title: 'Cart Cleared',
        message: 'All items have been removed from your cart',
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      LogService.error('Failed to clear cart', e);
    } finally {
      _isLoading.value = false;
    }
  }

  /// Apply coupon code
  Future<bool> applyCoupon(String couponCode) async {
    try {
      _isLoading.value = true;

      // Simulate API call to validate coupon
      await Future.delayed(const Duration(seconds: 1));

      // Mock coupon validation
      final validCoupons = {'SAVE10': 0.10, 'SAVE20': 0.20, 'WELCOME': 0.15};

      if (validCoupons.containsKey(couponCode.toUpperCase())) {
        _appliedCoupon.value = couponCode.toUpperCase();
        _calculateTotals();
        await _saveCartToStorage();

        LogService.business('Coupon applied', {
          'couponCode': couponCode,
          'discountPercent': validCoupons[couponCode.toUpperCase()],
        });

        NotificationService.showSuccess(
          title: 'Coupon Applied',
          message: 'Your coupon has been applied successfully!',
        );

        return true;
      } else {
        NotificationService.showError(
          title: 'Invalid Coupon',
          message: 'The coupon code you entered is not valid.',
        );
        return false;
      }
    } catch (e) {
      LogService.error('Failed to apply coupon', e);
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  /// Remove applied coupon
  Future<void> removeCoupon() async {
    _appliedCoupon.value = '';
    _calculateTotals();
    await _saveCartToStorage();

    LogService.business('Coupon removed');
  }

  /// Calculate cart totals
  void _calculateTotals() {
    // Calculate subtotal
    _subtotal.value = _cartItems.fold(0.0, (sum, item) {
      final price = item.discountPrice ?? item.price;
      return sum + (price * item.quantity);
    });

    // Calculate discount
    double discountAmount = 0.0;
    if (_appliedCoupon.value.isNotEmpty) {
      final validCoupons = {'SAVE10': 0.10, 'SAVE20': 0.20, 'WELCOME': 0.15};
      final discountPercent = validCoupons[_appliedCoupon.value] ?? 0.0;
      discountAmount = _subtotal.value * discountPercent;
    }
    _discount.value = discountAmount;

    // Calculate shipping (free shipping over $50)
    _shipping.value = _subtotal.value > 50 ? 0.0 : 5.99;

    // Calculate tax (8% of subtotal after discount)
    final taxableAmount = _subtotal.value - _discount.value;
    _tax.value = taxableAmount * 0.08;

    // Calculate total
    _total.value =
        _subtotal.value - _discount.value + _tax.value + _shipping.value;

    LogService.debug('Cart totals calculated', {
      'subtotal': _subtotal.value,
      'discount': _discount.value,
      'tax': _tax.value,
      'shipping': _shipping.value,
      'total': _total.value,
    });
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

  /// Get cart summary for checkout
  Map<String, dynamic> getCartSummary() {
    return {
      'items': cartItems.map((item) => item.toJson()).toList(),
      'itemCount': itemCount,
      'totalQuantity': totalQuantity,
      'subtotal': subtotal,
      'tax': tax,
      'shipping': shipping,
      'discount': discount,
      'total': total,
      'appliedCoupon': appliedCoupon,
    };
  }

  /// Get quantity of a specific product in cart
  int getQuantity(String productId) {
    final item = getCartItem(productId);
    return item?.quantity ?? 0;
  }

  /// Increment quantity of a product in cart
  Future<void> incrementQuantity(String productId) async {
    final existingIndex = _cartItems.indexWhere(
      (item) => item.productId == productId,
    );

    if (existingIndex != -1) {
      _cartItems[existingIndex] = _cartItems[existingIndex].copyWith(
        quantity: _cartItems[existingIndex].quantity + 1,
      );
      await _saveCartToStorage();
      _calculateTotals();
      LogService.business('Incremented product quantity', {
        'productId': productId,
        'newQuantity': _cartItems[existingIndex].quantity,
      });
    }
  }

  /// Decrement quantity of a product in cart
  Future<void> decrementQuantity(String productId) async {
    final existingIndex = _cartItems.indexWhere(
      (item) => item.productId == productId,
    );

    if (existingIndex != -1) {
      final currentQuantity = _cartItems[existingIndex].quantity;
      if (currentQuantity > 1) {
        _cartItems[existingIndex] = _cartItems[existingIndex].copyWith(
          quantity: currentQuantity - 1,
        );
        LogService.business('Decremented product quantity', {
          'productId': productId,
          'newQuantity': _cartItems[existingIndex].quantity,
        });
      } else {
        // Remove item if quantity becomes 0
        await removeFromCart(productId);
        return;
      }
      await _saveCartToStorage();
      _calculateTotals();
    }
  }
}
