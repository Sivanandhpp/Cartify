import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_endpoints.dart';
import 'log_service.dart';
import 'secure_storage_service.dart';

/// Production-level cart API service
///
/// Handles all cart-related API operations with comprehensive error handling,
/// authentication, and response validation.
class CartApiService {
  static const Duration _timeout = Duration(seconds: 30);

  /// Get authenticated headers for API requests
  static Map<String, String> _getHeaders() {
    final headers = <String, String>{'Content-Type': 'application/json'};

    final authHeader = SecureStorageService().getAuthorizationHeader();
    if (authHeader != null) {
      headers['Authorization'] = authHeader;
    }

    return headers;
  }

  /// Get logged-in user's complete cart
  static Future<Map<String, dynamic>> getCart() async {
    try {
      LogService.info('Fetching user cart from API');

      final response = await http
          .get(
            Uri.parse('${ApiEndpoints.baseUrl}/cart'),
            headers: _getHeaders(),
          )
          .timeout(_timeout);

      LogService.apiResponse(
        'GET',
        '/cart',
        response.statusCode,
        response.body,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        LogService.info('Cart fetched successfully');
        return {'success': true, 'data': data};
      } else {
        final error = json.decode(response.body);
        LogService.error('Failed to fetch cart: ${response.statusCode}');
        return {
          'success': false,
          'message': error['message'] ?? 'Failed to fetch cart',
        };
      }
    } catch (e) {
      LogService.error('Error fetching cart from API', e);
      return {'success': false, 'message': 'Network error occurred'};
    }
  }

  /// Add an item to cart
  static Future<Map<String, dynamic>> addItemToCart({
    required String productId,
    required int quantity,
  }) async {
    try {
      LogService.info('Adding item to cart via API', {
        'productId': productId,
        'quantity': quantity,
      });

      final body = json.encode({'product_id': productId, 'quantity': quantity});

      final response = await http
          .post(
            Uri.parse('${ApiEndpoints.baseUrl}/cart/items'),
            headers: _getHeaders(),
            body: body,
          )
          .timeout(_timeout);

      LogService.apiResponse(
        'POST',
        '/cart/items',
        response.statusCode,
        response.body,
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        LogService.business('Item added to cart successfully', {
          'productId': productId,
          'quantity': quantity,
        });
        return {'success': true, 'data': data};
      } else {
        final error = json.decode(response.body);
        LogService.error('Failed to add item to cart: ${response.statusCode}');
        return {
          'success': false,
          'message': error['message'] ?? 'Failed to add item to cart',
        };
      }
    } catch (e) {
      LogService.error('Error adding item to cart', e);
      return {'success': false, 'message': 'Network error occurred'};
    }
  }

  /// Update the quantity of an item in cart
  static Future<Map<String, dynamic>> updateCartItemQuantity({
    required String cartItemId,
    required int quantity,
  }) async {
    try {
      LogService.info('Updating cart item quantity via API', {
        'cartItemId': cartItemId,
        'quantity': quantity,
      });

      final body = json.encode({'quantity': quantity});

      final response = await http
          .patch(
            Uri.parse('${ApiEndpoints.baseUrl}/cart/items/$cartItemId'),
            headers: _getHeaders(),
            body: body,
          )
          .timeout(_timeout);

      LogService.apiResponse(
        'PATCH',
        '/cart/items/$cartItemId',
        response.statusCode,
        response.body,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        LogService.business('Cart item quantity updated successfully', {
          'cartItemId': cartItemId,
          'quantity': quantity,
        });
        return {'success': true, 'data': data};
      } else {
        final error = json.decode(response.body);
        LogService.error(
          'Failed to update cart item quantity: ${response.statusCode}',
        );
        return {
          'success': false,
          'message': error['message'] ?? 'Failed to update item quantity',
        };
      }
    } catch (e) {
      LogService.error('Error updating cart item quantity', e);
      return {'success': false, 'message': 'Network error occurred'};
    }
  }

  /// Remove an item from cart
  static Future<Map<String, dynamic>> removeCartItem(String cartItemId) async {
    try {
      LogService.info('Removing cart item via API', {'cartItemId': cartItemId});

      final response = await http
          .delete(
            Uri.parse('${ApiEndpoints.baseUrl}/cart/items/$cartItemId'),
            headers: _getHeaders(),
          )
          .timeout(_timeout);

      LogService.apiResponse(
        'DELETE',
        '/cart/items/$cartItemId',
        response.statusCode,
        response.body,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        LogService.business('Cart item removed successfully', {
          'cartItemId': cartItemId,
        });
        return {'success': true, 'data': data};
      } else {
        final error = json.decode(response.body);
        LogService.error('Failed to remove cart item: ${response.statusCode}');
        return {
          'success': false,
          'message': error['message'] ?? 'Failed to remove item from cart',
        };
      }
    } catch (e) {
      LogService.error('Error removing cart item', e);
      return {'success': false, 'message': 'Network error occurred'};
    }
  }

  /// Clear the entire cart
  static Future<Map<String, dynamic>> clearCart() async {
    try {
      LogService.info('Clearing entire cart via API');

      final response = await http
          .delete(
            Uri.parse('${ApiEndpoints.baseUrl}/cart'),
            headers: _getHeaders(),
          )
          .timeout(_timeout);

      LogService.apiResponse(
        'DELETE',
        '/cart',
        response.statusCode,
        response.body,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        LogService.business('Cart cleared successfully');
        return {'success': true, 'data': data};
      } else {
        final error = json.decode(response.body);
        LogService.error('Failed to clear cart: ${response.statusCode}');
        return {
          'success': false,
          'message': error['message'] ?? 'Failed to clear cart',
        };
      }
    } catch (e) {
      LogService.error('Error clearing cart', e);
      return {'success': false, 'message': 'Network error occurred'};
    }
  }
}
