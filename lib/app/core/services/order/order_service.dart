// lib/app/core/services/order/order_service.dart

import 'package:cartify/app/core/models/order/create_order_dto.dart';
import 'package:cartify/app/core/models/order/order_model.dart';
import 'package:cartify/app/core/services/api_client.dart';
import 'package:dio/dio.dart';

/// Service for creating and viewing orders.
class OrderService {
  final ApiClient _apiClient;

  OrderService(this._apiClient);

  /// Creates a new order from the user's current cart.
  Future<OrderModel?> placeOrder(CreateOrderDto dto) async {
    try {
      final response = await _apiClient.dio.post('/orders', data: dto.toJson());
      return OrderModel.fromJson(response.data);
    } on DioException catch (e) {
      print('Error placing order: ${e.response?.data}');
      return null;
    }
  }

  /// Retrieves a list of all past orders for the authenticated user.
  Future<List<OrderModel>> getOrderHistory() async {
    try {
      final response = await _apiClient.dio.get('/orders');
      return (response.data as List)
          .map((order) => OrderModel.fromJson(order))
          .toList();
    } on DioException catch (e) {
      print('Error getting order history: ${e.response?.data}');
      return [];
    }
  }

  /// Retrieves the full details of a single order.
  Future<OrderModel?> getOrderById(String orderId) async {
    try {
      final response = await _apiClient.dio.get('/orders/$orderId');
      return OrderModel.fromJson(response.data);
    } on DioException catch (e) {
      print('Error getting order by ID: ${e.response?.data}');
      return null;
    }
  }
}
