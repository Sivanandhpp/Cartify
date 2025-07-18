import 'package:get/get.dart';
import '../model/cart_item_model.dart';
import '../model/product_model.dart';
import 'error_service.dart';
import 'log_service.dart';

class CartService extends GetxService {
  // Use RxList to make the list of cart items observable
  final cartItems = <CartItemModel>[].obs;

  // Computed properties
  int get itemCount => cartItems.length;
  int get totalQuantity =>
      cartItems.fold(0, (sum, item) => sum + item.quantity.value);
  double get totalPrice =>
      cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);

  // Method to add a product to the cart
  void addItem(ProductModel product) {
    try {
      // Check if the item is already in the cart
      final index = cartItems.indexWhere(
        (item) => item.product.id == product.id,
      );

      if (index != -1) {
        // If it exists, just increment the quantity
        cartItems[index].quantity.value++;
        LogService.info('Incremented quantity for product: ${product.name}');
      } else {
        // If not, add a new CartItemModel to the list
        cartItems.add(CartItemModel(product: product));
        LogService.info('Added new product to cart: ${product.name}');
      }

      // Show success feedback
      ErrorService.showSuccess('${product.name} added to cart');
    } catch (error) {
      LogService.error('Failed to add item to cart', error);
      ErrorService.showError('Failed to add item to cart');
    }
  }

  // Method to remove an item from the cart
  void removeItem(String productId) {
    try {
      final index = cartItems.indexWhere(
        (item) => item.product.id == productId,
      );

      if (index != -1) {
        final productName = cartItems[index].product.name;
        cartItems.removeAt(index);
        LogService.info('Removed product from cart: $productName');
        ErrorService.showSuccess('Item removed from cart');
      }
    } catch (error) {
      LogService.error('Failed to remove item from cart', error);
      ErrorService.showError('Failed to remove item');
    }
  }

  // Method to update quantity of a specific item
  void updateQuantity(String productId, int newQuantity) {
    try {
      final index = cartItems.indexWhere(
        (item) => item.product.id == productId,
      );

      if (index != -1) {
        if (newQuantity <= 0) {
          removeItem(productId);
        } else {
          cartItems[index].quantity.value = newQuantity;
          LogService.info(
            'Updated quantity for product: ${cartItems[index].product.name} to $newQuantity',
          );
        }
      }
    } catch (error) {
      LogService.error('Failed to update quantity', error);
      ErrorService.showError('Failed to update quantity');
    }
  }

  // Method to increment quantity
  void incrementQuantity(String productId) {
    final index = cartItems.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      cartItems[index].quantity.value++;
    }
  }

  // Method to decrement quantity
  void decrementQuantity(String productId) {
    final index = cartItems.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      if (cartItems[index].quantity.value > 1) {
        cartItems[index].quantity.value--;
      } else {
        removeItem(productId);
      }
    }
  }

  // Method to get quantity of a specific product
  int getQuantity(String productId) {
    final index = cartItems.indexWhere((item) => item.product.id == productId);
    return index != -1 ? cartItems[index].quantity.value : 0;
  }

  // Method to check if a product is in cart
  bool isInCart(String productId) {
    return cartItems.any((item) => item.product.id == productId);
  }

  // Method to clear the entire cart
  void clearCart() {
    try {
      cartItems.clear();
      LogService.info('Cart cleared');
      ErrorService.showSuccess('Cart cleared');
    } catch (error) {
      LogService.error('Failed to clear cart', error);
      ErrorService.showError('Failed to clear cart');
    }
  }

  @override
  void onInit() {
    super.onInit();
    LogService.info('CartService initialized');
  }

  @override
  void onClose() {
    LogService.info('CartService disposed');
    super.onClose();
  }
}
