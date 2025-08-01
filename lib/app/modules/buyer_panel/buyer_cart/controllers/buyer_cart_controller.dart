import 'package:get/get.dart';
import '../../../../core/index.dart';

class BuyerCartController extends GetxController {
  final CartService _cartService = Get.find<CartService>();

  final RxDouble deliveryTip = 0.0.obs;
  final RxBool isProcessingPayment = false.obs;

  // Getters
  List<CartItem> get cartItems => _cartService.cartItems;
  double get subtotal => _cartService.subtotal;
  double get totalSavings => cartItems.fold(
    0.0,
    (sum, item) => sum + (item.hasDiscount ? item.totalDiscount : 0.0),
  );
  int get itemCount => _cartService.itemCount;
  bool get isEmpty => _cartService.isEmpty;
  bool get isLoading => _cartService.isLoading;

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
  }

  // Cart operations
  Future<void> incrementQuantity(String productId) async {
    await _cartService.incrementQuantity(productId);
  }

  Future<void> decrementQuantity(String productId) async {
    await _cartService.decrementQuantity(productId);
  }

  void removeItem(String cartItemId) {
    _cartService.removeFromCart(cartItemId);
  }

  void clearCart() {
    _cartService.clearCart();
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
