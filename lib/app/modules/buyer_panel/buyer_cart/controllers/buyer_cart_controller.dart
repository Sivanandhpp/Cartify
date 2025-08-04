import 'package:get/get.dart';
import '../../../../core/index.dart';

class BuyerCartController extends GetxController {
  final CartService _cartService = Get.find<CartService>();

  final RxDouble deliveryTip = 0.0.obs;
  final RxBool isProcessingPayment = false.obs;
  final RxBool isLoading = false.obs;

  // Cart data
  final Rx<CartModel?> _cart = Rx<CartModel?>(null);

  // Getters
  List<CartItem> get cartItems => _cart.value?.items ?? [];
  double get subtotal => _cart.value?.totalPrice ?? 0.0;
  double get totalSavings => cartItems.fold(
    0.0,
    (sum, item) =>
        sum +
        (item.product.price * item.quantity -
            (item.product.price *
                item.quantity)), // Assuming no discount logic for now
  );
  int get itemCount => cartItems.fold(0, (sum, item) => sum + item.quantity);
  bool get isEmpty => cartItems.isEmpty;
  bool get isLoadingCart => isLoading.value;

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

  /// Loads the current cart from the API
  Future<void> _loadCart() async {
    try {
      isLoading.value = true;
      final cart = await _cartService.getCart();
      _cart.value = cart;
    } catch (e) {
      LogService.error('Failed to load cart', e);
      ErrorService.showError('Failed to load cart items');
    } finally {
      isLoading.value = false;
    }
  }

  // Cart operations
  Future<void> incrementQuantity(String cartItemId) async {
    try {
      final currentItem = cartItems.firstWhere((item) => item.id == cartItemId);
      final newQuantity = currentItem.quantity + 1;

      final updatedCart = await _cartService.updateCartItemQuantity(
        cartItemId,
        UpdateCartItemDto(quantity: newQuantity),
      );

      if (updatedCart != null) {
        _cart.value = updatedCart;
      }
    } catch (e) {
      LogService.error('Failed to increment quantity', e);
      ErrorService.showError('Failed to update item quantity');
    }
  }

  Future<void> decrementQuantity(String cartItemId) async {
    try {
      final currentItem = cartItems.firstWhere((item) => item.id == cartItemId);

      if (currentItem.quantity <= 1) {
        // Remove item if quantity would become 0
        await removeItem(cartItemId);
        return;
      }

      final newQuantity = currentItem.quantity - 1;
      final updatedCart = await _cartService.updateCartItemQuantity(
        cartItemId,
        UpdateCartItemDto(quantity: newQuantity),
      );

      if (updatedCart != null) {
        _cart.value = updatedCart;
      }
    } catch (e) {
      LogService.error('Failed to decrement quantity', e);
      ErrorService.showError('Failed to update item quantity');
    }
  }

  Future<void> removeItem(String cartItemId) async {
    try {
      final updatedCart = await _cartService.removeItemFromCart(cartItemId);
      if (updatedCart != null) {
        _cart.value = updatedCart;
      }
    } catch (e) {
      LogService.error('Failed to remove item', e);
      ErrorService.showError('Failed to remove item from cart');
    }
  }

  Future<void> clearCart() async {
    try {
      final success = await _cartService.clearCart();
      if (success) {
        _cart.value = null;
      }
    } catch (e) {
      LogService.error('Failed to clear cart', e);
      ErrorService.showError('Failed to clear cart');
    }
  }

  /// Adds a product to the cart
  Future<void> addToCart(String productId, {int quantity = 1}) async {
    try {
      final dto = AddItemToCartDto(productId: productId, quantity: quantity);
      final updatedCart = await _cartService.addItemToCart(dto);

      if (updatedCart != null) {
        _cart.value = updatedCart;
        ErrorService.showSuccess('Item added to cart');
      }
    } catch (e) {
      LogService.error('Failed to add item to cart', e);
      ErrorService.showError('Failed to add item to cart');
    }
  }

  /// Gets the quantity of a specific product in the cart
  int getQuantity(String productId) {
    return cartItems
        .where((item) => item.product.id == productId)
        .fold(0, (sum, item) => sum + item.quantity);
  }

  // Tip management
  void setDeliveryTip(double amount) {
    deliveryTip.value = amount;
  }

  // Payment processing
  Future<void> processPayment() async {
    if (isEmpty) {
      ErrorService.showError('Please add items to your cart before proceeding');
      return;
    }

    try {
      isProcessingPayment.value = true;

      // TODO: Implement actual order placement using OrderService
      // For now, simulate payment processing
      await Future.delayed(const Duration(seconds: 3));

      await clearCart();

      ErrorService.showSuccess(
        'Your order has been placed and will be delivered soon!',
      );
      Get.back();
    } catch (e) {
      LogService.error('Payment processing failed', e);
      ErrorService.showError(
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
