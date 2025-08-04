import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../app/core/index.dart'; // Assuming CartService, CartItem are here
import '../../../../routes/app_pages.dart';
import '../views/widgets/expanded_cart_view.dart';

class CartTrackingController extends GetxController {
  final CartService cartService = Get.find();

  // Expose reactive properties for the view
  bool get isCartEmpty => cartService.isEmpty;
  int get totalQuantity => cartService.totalQuantity;
  int get itemCount => cartService.itemCount;
  double get totalSavings => _calculateSavings();
  List<CartItem> get cartItems => cartService.cartItems;

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
        onIncrement: cartService.incrementQuantity,
        onDecrement: cartService.decrementQuantity,
        onGoToCart: navigateToCartAndCloseSheet,
        onClose: _closeBottomSheet,
      ),
    );
  }

  double _calculateSavings() {
    return cartService.cartItems.fold(0.0, (sum, item) {
      if (item.discountPrice != null) {
        return sum + ((item.price - item.discountPrice!) * item.quantity);
      }
      return sum;
    });
  }
}