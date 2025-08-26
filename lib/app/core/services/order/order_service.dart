// lib/app/core/services/order/order_service.dart

import 'package:cartify/app/core/models/order/create_order_dto.dart';
import 'package:cartify/app/core/models/order/order_model.dart';
import 'package:cartify/app/core/services/api_client.dart';
import 'package:cartify/app/core/services/log_service.dart';
import 'package:dio/dio.dart';

/// Service for creating and viewing orders.
class OrderService {
  final ApiClient _apiClient;

  OrderService(this._apiClient);

  /// Creates a new order from the user's current cart.
  Future<OrderModel?> placeOrder(CreateOrderDto dto) async {
    try {
      LogService.business('Placing order', {'addressId': dto.addressId});

      final response = await _apiClient.dio.post('/orders', data: dto.toJson());

      // Log the raw response to debug the issue
      LogService.info('Order API Response', {
        'statusCode': response.statusCode,
        'data': response.data,
      });

      // Validate response data before parsing
      if (response.data == null) {
        LogService.error('Order API returned null data');
        return null;
      }

      final order = OrderModel.fromJson(response.data);

      LogService.business('Order placed successfully', {
        'orderId': order.id,
        'totalAmount': order.totalAmount,
      });

      return order;
    } on DioException catch (e) {
      LogService.error('Error placing order', {
        'statusCode': e.response?.statusCode,
        'error': e.response?.data,
        'addressId': dto.addressId,
      });
      return null;
    } catch (e, stackTrace) {
      LogService.error('Unexpected error placing order', {
        'error': e.toString(),
        'stackTrace': stackTrace.toString(),
      });
      return null;
    }
  }

  /// Retrieves a list of all past orders for the authenticated user.
  Future<List<OrderModel>> getOrderHistory() async {
    try {
      final response = await _apiClient.dio.get('/orders');
      final orders = (response.data as List)
          .map((order) => OrderModel.fromJson(order))
          .toList();

      LogService.info('Fetched ${orders.length} orders from history');
      return orders;
    } on DioException catch (e) {
      LogService.error('Error getting order history', e.response?.data);
      return [];
    }
  }

  /// Retrieves the full details of a single order.
  Future<OrderModel?> getOrderById(String orderId) async {
    try {
      final response = await _apiClient.dio.get('/orders/$orderId');
      return OrderModel.fromJson(response.data);
    } on DioException catch (e) {
      LogService.error('Error getting order by ID', {
        'orderId': orderId,
        'error': e.response?.data,
      });
      return null;
    }
  }
}
