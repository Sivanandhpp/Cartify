import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/index.dart';

class BuyerCartController extends GetxController {
  final CartService _cartService = Get.find<CartService>();

  final RxDouble deliveryTip = 0.0.obs;
  final RxBool isProcessingPayment = false.obs;

  // Store the original order of cart items
  final RxList<String> _itemOrder = <String>[].obs;

  // Getters using CartService's existing properties
  CartModel? get cartData => _cartService.cartData;

  // Modified getter to maintain stable order
  List<CartItem> get cartItems {
    final items = _cartService.cartData?.items ?? [];
    if (items.isEmpty) return items;

    // If order is not initialized, initialize it
    if (_itemOrder.isEmpty) {
      _itemOrder.value = items.map((item) => item.id).toList();
    }

    // Sort items based on the stored order
    final sortedItems = <CartItem>[];
    for (final itemId in _itemOrder) {
      try {
        final item = items.firstWhere((item) => item.id == itemId);
        sortedItems.add(item);
      } catch (e) {
        // Item was removed, remove from order list
        _itemOrder.remove(itemId);
      }
    }

    // Add any new items that weren't in the original order
    for (final item in items) {
      if (!_itemOrder.contains(item.id)) {
        sortedItems.add(item);
        _itemOrder.add(item.id);
      }
    }

    return sortedItems;
  }

  double get subtotal => cartItems.fold(
    0.0,
    (sum, item) => sum + (item.product.effectivePrice * item.quantity),
  );
  double get totalSavings => cartItems.fold(0.0, (sum, item) {
    if (item.product.hasOffer) {
      final discountPerItem = item.product.price - item.product.offerPrice!;
      return sum + (discountPerItem * item.quantity);
    }
    return sum;
  });
  int get itemCount => _cartService.cartItemsCount;
  bool get isEmpty => cartItems.isEmpty;
  bool get isLoading => _cartService.isLoading;
  double get cartTotalPrice => _cartService.cartTotalPrice;

  // Constants
  static const double _handlingFeeConstant = 9.80;
  static const double _deliveryPartnerFeeConstant = 30.0;
  static const double gstRate = 0.18;

  // Getters for constants (instance access)
  double get handlingFee => _handlingFeeConstant;
  double get deliveryPartnerFee => _deliveryPartnerFeeConstant;

  // Calculated values
  double get gstAmount => subtotal * gstRate;
  double get finalTotal =>
      subtotal +
      _handlingFeeConstant +
      _deliveryPartnerFeeConstant +
      gstAmount +
      deliveryTip.value;

  @override
  void onInit() {
    super.onInit();
    deliveryTip.value = 0.0;
    _loadCart();
  }

  /// Load cart data on initialization
  Future<void> _loadCart() async {
    await _cartService.getCart();
    // Initialize item order when cart is first loaded
    final items = _cartService.cartData?.items ?? [];
    if (items.isNotEmpty && _itemOrder.isEmpty) {
      _itemOrder.value = items.map((item) => item.id).toList();
    }
  }

  // Cart operations using existing CartService methods
  Future<void> incrementQuantity(String productId) async {
    final success = await _cartService.incrementProductQuantity(productId);
    if (!success) {
      Get.snackbar(
        'Error',
        'Failed to update cart',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> decrementQuantity(String productId) async {
    final success = await _cartService.decrementProductQuantity(productId);
    if (!success) {
      Get.snackbar(
        'Error',
        'Failed to update cart',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> removeItem(String cartItemId) async {
    final cart = await _cartService.removeItemFromCart(cartItemId);
    if (cart == null) {
      Get.snackbar(
        'Error',
        'Failed to remove item from cart',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      // Remove from order list when item is removed
      _itemOrder.remove(cartItemId);
    }
  }

  Future<void> clearCart() async {
    final success = await _cartService.clearCart();
    if (!success) {
      Get.snackbar(
        'Error',
        'Failed to clear cart',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      // Clear order list when cart is cleared
      _itemOrder.clear();
    }
  }

  /// Get quantity of a specific product in cart
  int getProductQuantityInCart(String productId) {
    return _cartService.getProductQuantityInCart(productId);
  }

  // Tip management
  void setDeliveryTip(double amount) {
    deliveryTip.value = amount;
  }

  // Payment processing
  Future<void> processPayment() async {
    if (isEmpty) {
      Get.snackbar(
        'Empty Cart',
        'Please add items to your cart before proceeding',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isProcessingPayment.value = true;

      // Show loading state
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // Simulate payment processing
      await Future.delayed(const Duration(seconds: 3));

      // Close loading dialog
      Get.back();

      // Clear cart after successful payment
      await clearCart();

      Get.snackbar(
        'Order Placed Successfully',
        'Your order has been placed and will be delivered soon!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Navigate back to home
      Get.back();
    } catch (e) {
      // Close loading dialog if open
      if (Get.isDialogOpen == true) {
        Get.back();
      }

      Get.snackbar(
        'Payment Failed',
        'There was an error processing your payment. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isProcessingPayment.value = false;
    }
  }

  void addMoreItems() {
    Get.back();
  }

  /// Refresh cart data
  Future<void> refreshCart() async {
    await _cartService.getCart();
  }
}
