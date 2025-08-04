// lib/app/core/models/cart/add_item_to_cart_dto.dart

/// DTO for adding an item to the cart.
class AddItemToCartDto {
  final String productId;
  final int quantity;

  AddItemToCartDto({required this.productId, required this.quantity});

  Map<String, dynamic> toJson() {
    return {'product_id': productId, 'quantity': quantity};
  }
}
