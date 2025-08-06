import 'package:get/get.dart';
import '../../../../core/index.dart';

class BuyerCartController extends GetxController {
  // Use new core services
  final CartApiService _cartApiService = Get.find<CartApiService>();

  // Observable state
  final RxDouble deliveryTip = 0.0.obs;
  final RxBool isProcessingPayment = false.obs;
  final RxBool isLoading = false.obs;
  final RxList<CartItem> cartItems = <CartItem>[].obs;

  // Getters from cart services
  int get itemCount => cartItems.length;
  bool get isEmpty => cartItems.isEmpty;

  // Calculated values
  double get subtotal =>
      cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
  double get totalSavings => cartItems.fold(
    0.0,
    (sum, item) =>
        sum + 0.0, // No discount info available in current Product model
  );

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
    _loadCartData();
  }

  /// Load cart data from API and cache
  Future<void> _loadCartData() async {
    try {
      isLoading.value = true;

      // Fetch fresh data from API
      final Cart? apiCart = await _cartApiService.getCart();
      if (apiCart != null && apiCart.items.isNotEmpty) {
        cartItems.value = apiCart.items;
      }
    } catch (e) {
      LogService.error('Error loading cart data: $e');
      ErrorService.showError('Failed to load cart');
    } finally {
      isLoading.value = false;
    }
  }

  // Cart operations using new services
  Future<void> incrementQuantity(String cartItemId) async {
    try {
      // Find the current item to get its quantity
      final currentItem = cartItems.firstWhere((item) => item.id == cartItemId);
      await _cartApiService.updateCartItemQuantity(
        cartItemId,
        currentItem.quantity + 1,
      );
      await _loadCartData(); // Refresh cart data
    } catch (e) {
      LogService.error('Error incrementing quantity: $e');
      ErrorService.showError('Failed to update cart');
    }
  }

  Future<void> decrementQuantity(String cartItemId) async {
    try {
      // Find the current item to get its quantity
      final currentItem = cartItems.firstWhere((item) => item.id == cartItemId);
      if (currentItem.quantity > 1) {
        await _cartApiService.updateCartItemQuantity(
          cartItemId,
          currentItem.quantity - 1,
        );
      } else {
        await removeItem(cartItemId);
        return;
      }
      await _loadCartData(); // Refresh cart data
    } catch (e) {
      LogService.error('Error decrementing quantity: $e');
      ErrorService.showError('Failed to update cart');
    }
  }

  Future<void> removeItem(String cartItemId) async {
    try {
      await _cartApiService.removeItemFromCart(cartItemId);
      await _loadCartData(); // Refresh cart data
      ErrorService.showSuccess('Item removed from cart');
    } catch (e) {
      LogService.error('Error removing item: $e');
      ErrorService.showError('Failed to remove item');
    }
  }

  Future<void> clearCart() async {
    try {
      await _cartApiService.clearCart();
      cartItems.clear();
      ErrorService.showSuccess('Cart cleared');
    } catch (e) {
      LogService.error('Error clearing cart: $e');
      ErrorService.showError('Failed to clear cart');
    }
  }

  // Tip management
  void setDeliveryTip(double amount) {
    deliveryTip.value = amount;
  }

  // Payment processing
  Future<void> processPayment() async {
    if (isEmpty) {
      NotificationService.showError(
        title: 'Empty Cart',
        message: 'Please add items to your cart before proceeding',
      );
      return;
    }

    try {
      isProcessingPayment.value = true;
      NotificationService.showLoading(
        title: 'Processing Payment',
        message: 'Please wait while we process your order...',
      );

      await Future.delayed(const Duration(seconds: 3));

      NotificationService.dismiss();
      clearCart();

      NotificationService.showSuccess(
        title: 'Order Placed Successfully',
        message: 'Your order has been placed and will be delivered soon!',
      );

      Get.back();
    } catch (e) {
      NotificationService.dismiss();
      NotificationService.showError(
        title: 'Payment Failed',
        message:
            'There was an error processing your payment. Please try again.',
      );
    } finally {
      isProcessingPayment.value = false;
    }
  }

  void addMoreItems() {
    Get.back();
  }
}
