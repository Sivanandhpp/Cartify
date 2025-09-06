// lib/app/core/services/order/order_service.dart

import 'package:cartify/app/core/models/order/order_item_model.dart';
import 'package:cartify/app/core/models/order/update_order_item_dto.dart';
import 'package:dio/dio.dart';
import 'package:cartify/app/core/index.dart';

/// Service for order management (both buyer and seller operations)
class OrderService {
  final ApiClient _apiClient;

  OrderService(this._apiClient);

  /// Creates a new order from the user's current cart (Buyer operation)
  Future<OrderModel?> placeOrder(CreateOrderDto dto) async {
    try {
      LogService.business('Placing order', {'addressId': dto.addressId});

      final response = await _apiClient.dio.post('/orders', data: dto.toJson());

      LogService.info('Order API Response', {
        'statusCode': response.statusCode,
        'data': response.data,
      });

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

  /// Retrieves buyer's order history
  Future<List<OrderModel>> getBuyerOrderHistory() async {
    try {
      LogService.info('Fetching buyer order history');

      final response = await _apiClient.dio.get('/orders');

      LogService.info('Raw API Response', {
        'statusCode': response.statusCode,
        'dataType': response.data.runtimeType.toString(),
        'dataLength': response.data is List
            ? (response.data as List).length
            : 'N/A',
      });

      if (response.data == null) {
        LogService.warning('API returned null data for buyer orders');
        return [];
      }

      if (response.data is! List) {
        LogService.error('API response is not a list', {
          'actualType': response.data.runtimeType.toString(),
          'data': response.data,
        });
        return [];
      }

      final List<OrderModel> orders = [];
      final responseList = response.data as List;

      for (int i = 0; i < responseList.length; i++) {
        try {
          final orderData = responseList[i];
          if (orderData is Map<String, dynamic>) {
            final order = OrderModel.fromJson(orderData);
            orders.add(order);
          } else {
            LogService.warning('Order at index $i is not a valid object', {
              'index': i,
              'type': orderData.runtimeType.toString(),
              'data': orderData,
            });
          }
        } catch (e, stackTrace) {
          LogService.error('Error parsing order at index $i', {
            'index': i,
            'error': e.toString(),
            'stackTrace': stackTrace.toString(),
            'orderData': responseList[i],
          });
          // Continue processing other orders instead of failing completely
        }
      }

      LogService.info('Successfully fetched ${orders.length} buyer orders');
      return orders;
    } on DioException catch (e) {
      LogService.error('DioException getting buyer order history', {
        'statusCode': e.response?.statusCode,
        'error': e.response?.data,
        'message': e.message,
      });
      return [];
    } catch (e, stackTrace) {
      LogService.error('Unexpected error getting buyer order history', {
        'error': e.toString(),
        'stackTrace': stackTrace.toString(),
      });
      return [];
    }
  }

  /// Retrieves the full details of a single order
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

  // ===== SELLER-SPECIFIC METHODS =====

  /// Get incoming orders for the authenticated seller
  /// GET /orders (seller view - filtered)
  Future<List<OrderModel>> getMyIncomingOrders() async {
    try {
      LogService.info('Fetching seller incoming orders');

      final response = await _apiClient.dio.get('/orders');

      final List<dynamic> ordersJson = response.data;
      final orders = ordersJson
          .map((json) => OrderModel.fromJson(json))
          .toList();

      LogService.info('Fetched ${orders.length} incoming orders for seller');
      return orders;
    } on DioException catch (e) {
      LogService.error('Error fetching seller incoming orders', {
        'statusCode': e.response?.statusCode,
        'error': e.response?.data,
      });
      return [];
    } catch (e) {
      LogService.error('Unexpected error fetching seller incoming orders', e);
      return [];
    }
  }

  /// Updates the status of a specific order item (Seller operation)
  /// PATCH /orders/items/:itemId
  Future<OrderItem?> updateOrderItemStatus(
    String itemId,
    UpdateOrderItemDto dto,
  ) async {
    try {
      LogService.business('Updating order item status', {
        'itemId': itemId,
        'newStatus': dto.status.toString(),
      });

      final response = await _apiClient.dio.patch(
        '/orders/items/$itemId',
        data: dto.toJson(),
      );

      if (response.data == null) {
        LogService.error('Update order item API returned null data');
        return null;
      }

      final updatedItem = OrderItem.fromJson(response.data);

      LogService.business('Order item status updated successfully', {
        'itemId': itemId,
        'newStatus': updatedItem.status.toString(),
      });

      return updatedItem;
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        LogService.error(
          'Forbidden: Cannot update item that doesn\'t belong to seller',
          {'itemId': itemId},
        );
      } else {
        LogService.error('Error updating order item status', {
          'statusCode': e.response?.statusCode,
          'error': e.response?.data,
          'itemId': itemId,
        });
      }
      return null;
    } catch (e) {
      LogService.error('Unexpected error updating order item status', e);
      return null;
    }
  }

  /// Helper method to get orders by status
  Future<List<OrderModel>> getOrdersByStatus(String status) async {
    final allOrders = await getMyIncomingOrders();
    return allOrders
        .where((order) => order.items.any((item) => item.status.toString().split('.').last == status))
        .toList();
  }

  /// Get pending orders for seller
  Future<List<OrderModel>> getPendingOrders() async {
    return getOrdersByStatus('PENDING');
  }

  /// Get orders by multiple statuses
  Future<List<OrderModel>> getOrdersByStatuses(List<String> statuses) async {
    final allOrders = await getMyIncomingOrders();
    return allOrders
        .where(
          (order) => order.items.any((item) => statuses.contains(item.status.toString().split('.').last)),
        )
        .toList();
  }
}