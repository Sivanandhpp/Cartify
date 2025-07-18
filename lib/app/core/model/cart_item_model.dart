import 'package:get/get.dart';
import 'product_model.dart';

class CartItemModel {
  final ProductModel product;
  final RxInt quantity;

  CartItemModel({required this.product, int quantity = 1})
    : quantity = quantity.obs;

  // Computed property for the total price of this line item
  double get totalPrice => product.price * quantity.value;
}
