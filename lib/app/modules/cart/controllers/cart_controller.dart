import 'package:get/get.dart';
import '../../../core/index.dart';
import '../../../routes/app_pages.dart';

class CartController extends GetxController {
  // Get the cart service instance
  final CartService _cartService = Get.find<CartService>();

  // Reactive variables
  final RxDouble deliveryTip = 0.0.obs;
  final RxBool isProcessingPayment = false.obs;

  // Getters that react to cart service changes
  List<CartItem> get cartItems => _cartService.cartItems;
  double get subtotal => _cartService.subtotal;
  double get total => _cartService.total;
  double get totalSavings => cartItems.fold(
    0.0,
    (sum, item) => sum + (item.hasDiscount ? item.totalDiscount : 0.0),
  );
  int get itemCount => _cartService.itemCount;
  bool get isEmpty => _cartService.isEmpty;
  bool get isLoading => _cartService.isLoading;

  // Constants for charges
  static const double handlingFee = 9.80;
  static const double deliveryPartnerFee = 30.0;
  static const double gstRate = 0.18; // 18% GST

  // Calculated values
  double get gstAmount => subtotal * gstRate;
  double get finalTotal =>
      subtotal +
      handlingFee +
      (deliveryPartnerFee > 0 ? deliveryPartnerFee : 0) +
      gstAmount +
      deliveryTip.value;

  @override
  void onInit() {
    super.onInit();
    // Initialize with default tip
    deliveryTip.value = 0.0;
  }

  // Cart operations
  void incrementQuantity(String cartItemId) {
    _cartService.incrementQuantity(cartItemId);
  }

  void decrementQuantity(String cartItemId) {
    _cartService.decrementQuantity(cartItemId);
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

      // Simulate payment processing
      await Future.delayed(const Duration(seconds: 3));

      NotificationService.dismiss();

      // Generate order details
      final orderId =
          '#ORD${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';
      final deliveryDate = DateTime.now().add(const Duration(minutes: 30));

      // Navigate to order success page with order details
      Get.toNamed(
        Routes.ORDER_SUCCESS,
        arguments: {
          'orderId': orderId,
          'deliveryDate': deliveryDate,
          'totalAmount': finalTotal,
          'itemCount': itemCount,
        },
      );
    } catch (e) {
      NotificationService.dismiss();
      NotificationService.showError(
        title: 'Payment Failed',
        message:
            'There was an error processing your payment. Please try again.',
      );
       Get.toNamed(
        Routes.ORDER_SUCCESS,
        arguments: {
          'orderId': 'orderId',
          'deliveryDate': 'deliveryDate',
          'totalAmount': finalTotal,
          'itemCount': itemCount,
        },
      );
    } finally {
      isProcessingPayment.value = false;
    }
  }

  // Add more items navigation
  void addMoreItems() {
    Get.back(); // Go back to shopping
  }
}
