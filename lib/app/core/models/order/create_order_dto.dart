// lib/app/core/models/order/create_order_dto.dart

/// DTO for placing a new order.
class CreateOrderDto {
  final String addressId;

  CreateOrderDto({required this.addressId});

  Map<String, dynamic> toJson() {
    return {'address_id': addressId};
  }
}
