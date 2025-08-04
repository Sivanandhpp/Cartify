import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cartify/app/core/index.dart';
import '../../../../routes/app_pages.dart';
import '../views/widgets/expanded_cart_view.dart';

class CartTrackingController extends GetxController {
  // Services
  final CartService _cartService = Get.find<CartService>();

  // State management
  final Rx<CartModel?> _cart = Rx<CartModel?>(null);
  final RxBool isLoading = false.obs;

  // Cart getters
  bool get isCartEmpty => _cart.value?.items.isEmpty ?? true;
  int get totalQuantity {
    if (_cart.value?.items == null) return 0;
    return _cart.value!.items.fold(0, (sum, item) => sum + item.quantity);
  }

  int get itemCount => _cart.value?.items.length ?? 0;
  double get totalSavings => _calculateSavings();
  List<CartItem> get cartItems => _cart.value?.items ?? [];

  @override
  void onInit() {
    super.onInit();
    loadCartData();
  }

  // Load cart data
  Future<void> loadCartData() async {
    try {
      isLoading.value = true;
      final cartData = await _cartService.getCart();
      _cart.value = cartData;
    } catch (e) {
      LogService.error('Error loading cart: $e');
    } finally {
      isLoading.value = false;
    }
  }

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
        onIncrement: _incrementQuantity,
        onDecrement: _decrementQuantity,
        onGoToCart: navigateToCartAndCloseSheet,
        onClose: _closeBottomSheet,
      ),
    );
  }

  // Update item quantity methods
  Future<void> _incrementQuantity(String itemId) async {
    final item = cartItems.firstWhere((item) => item.id == itemId);
    await _updateQuantity(itemId, item.quantity + 1);
  }

  Future<void> _decrementQuantity(String itemId) async {
    final item = cartItems.firstWhere((item) => item.id == itemId);
    if (item.quantity > 1) {
      await _updateQuantity(itemId, item.quantity - 1);
    } else {
      await _removeItem(itemId);
    }
  }

  Future<void> _updateQuantity(String itemId, int quantity) async {
    try {
      final updateDto = UpdateCartItemDto(quantity: quantity);
      await _cartService.updateCartItemQuantity(itemId, updateDto);
      await loadCartData();
    } catch (e) {
      LogService.error('Error updating quantity: $e');
    }
  }

  Future<void> _removeItem(String itemId) async {
    try {
      await _cartService.removeItemFromCart(itemId);
      await loadCartData();
    } catch (e) {
      LogService.error('Error removing item: $e');
    }
  }

  double _calculateSavings() {
    return cartItems.fold(0.0, (sum, item) {
      // Calculate savings based on discount if available
      // This would depend on your CartItem model structure
      return sum;
    });
  }
}
