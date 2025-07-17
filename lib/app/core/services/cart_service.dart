import 'package:get/get.dart';
import '../model/cart_item_model.dart';
import '../model/product_model.dart';

class CartService extends GetxService {
  // Use RxList to make the list of cart items observable
  final cartItems = <CartItemModel>[].obs;

  // Method to add a product to the cart
  void addItem(ProductModel product) {
    // Check if the item is already in the cart
    final index = cartItems.indexWhere((item) => item.product.id == product.id);

    if (index != -1) {
      // If it exists, just increment the quantity
      cartItems[index].quantity.value++;
    } else {
      // If not, add a new CartItemModel to the list
      cartItems.add(CartItemModel(product: product));
    }

    // Optional: Show a snackbar confirmation
    Get.snackbar(
      'Product Added',
      '${product.name} was added to your cart.',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  // Method to remove an item from the cart
  void removeItem(String productId) {
    cartItems.removeWhere((item) => item.product.id == productId);
  }

  // Method to increment an item's quantity
  void incrementQuantity(String productId) {
    final index = cartItems.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      cartItems[index].quantity.value++;
    }
  }

  // Method to decrement an item's quantity
  void decrementQuantity(String productId) {
    final index = cartItems.indexWhere((item) => item.product.id == productId);
    if (index != -1 && cartItems[index].quantity.value > 1) {
      cartItems[index].quantity.value--;
    } else if (index != -1) {
      // If quantity is 1, remove the item completely
      removeItem(productId);
    }
  }

  // Computed property (getter) for the total number of items in the cart
  double get totalItemCount =>
      cartItems.fold(0, (sum, item) => sum + item.quantity.value);

  // Computed property for the total price of all items in the cart
  double get totalPrice =>
      cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);

  // Method to clear the entire cart
  void clearCart() {
    cartItems.clear();
  }
}
