import 'package:cartify/app/core/models/order/order_item_model.dart';

/// DTO for updating order item status
class UpdateOrderItemDto {
  final OrderItemStatus status;

  UpdateOrderItemDto({
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'status': status.toString().split('.').last,
    };
  }
}