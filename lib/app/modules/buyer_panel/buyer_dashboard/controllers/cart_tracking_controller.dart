import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../app/core/index.dart';
import '../../../../routes/app_pages.dart';
import '../views/widgets/expanded_cart_view.dart';

class CartTrackingController extends GetxController {
  // Use new cart services
  final CartApiService _cartApiService = Get.find<CartApiService>();
  final CartStorageService _cartStorageService = Get.find<CartStorageService>();

  // Expose reactive properties for the view
  bool get isCartEmpty => _cartStorageService.isCartEmpty;
  int get totalQuantity => _cartStorageService.totalItems;
  int get itemCount => _cartStorageService.getItemsCount();
  double get totalSavings => _calculateSavings();
  List<CartItem> get cartItems => _cartStorageService.getAllItems();
  double get totalValue => _cartStorageService.totalValue;

  void goToCart() {
    Get.toNamed(Routes.CART);
  }

  void _closeBottomSheet() {
    if (Get.isBottomSheetOpen ?? false) {
      Get.back();
    }
  }

  void navigateToCartAndCloseSheet() {
    _closeBottomSheet();
    goToCart();
  }

  /// Increment item quantity in cart
  Future<void> incrementQuantity(String productId) async {
    try {
      await _cartApiService.updateCartItemQuantity(productId, 1);
      // Refresh cart data
      await _cartApiService.getCart();
    } catch (e) {
      LogService.error('Error incrementing quantity: $e');
      ErrorService.showError('Failed to update cart');
    }
  }

  /// Decrement item quantity in cart
  Future<void> decrementQuantity(String productId) async {
    try {
      await _cartApiService.updateCartItemQuantity(productId, -1);
      // Refresh cart data
      await _cartApiService.getCart();
    } catch (e) {
      LogService.error('Error decrementing quantity: $e');
      ErrorService.showError('Failed to update cart');
    }
  }

  void showExpandedCart() {
    if (Get.context == null) return;

    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ExpandedCartView(
        cartItems: cartItems,
        totalQuantity: totalQuantity,
        totalSavings: totalSavings,
        onIncrement: incrementQuantity,
        onDecrement: decrementQuantity,
        onGoToCart: navigateToCartAndCloseSheet,
        onClose: _closeBottomSheet,
      ),
    );
  }

  double _calculateSavings() {
    return cartItems.fold(0.0, (sum, item) {
      // Calculate savings based on original product price vs cart unit price
      final originalPrice = item.product.price;
      final currentPrice = item.unitPrice;

      if (originalPrice > currentPrice) {
        return sum + ((originalPrice - currentPrice) * item.quantity);
      }
      return sum;
    });
  }
}
