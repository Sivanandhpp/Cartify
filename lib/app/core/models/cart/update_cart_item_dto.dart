// lib/app/core/models/cart/update_cart_item_dto.dart

/// DTO for updating a cart item's quantity.
class UpdateCartItemDto {
  final int quantity;

  UpdateCartItemDto({required this.quantity});

  Map<String, dynamic> toJson() {
    return {'quantity': quantity};
  }
}
