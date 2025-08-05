// lib/app/core/services/cart/cart_service.dart

import 'package:cartify/app/core/models/cart/add_item_to_cart_dto.dart';
import 'package:cartify/app/core/models/cart/cart_model.dart';
import 'package:cartify/app/core/models/cart/update_cart_item_dto.dart';
import 'package:cartify/app/core/services/api_client.dart';
import 'package:dio/dio.dart';

/// Service for managing the user's shopping cart.
class CartService {
  final ApiClient _apiClient;

  CartService(this._apiClient);

  /// Retrieves the full contents of the user's cart.
  Future<CartModel?> getCart() async {
    try {
      final response = await _apiClient.dio.get('/cart');
      return CartModel.fromJson(response.data);
    } on DioException catch (e) {
      print('Error getting cart: ${e.response?.data}');
      return null;
    }
  }

  /// Adds an item to the cart.
  Future<CartModel?> addItemToCart(AddItemToCartDto dto) async {
    try {
      final response = await _apiClient.dio.post(
        '/cart/items',
        data: dto.toJson(),
      );
      return CartModel.fromJson(response.data);
    } on DioException catch (e) {
      print('Error adding item to cart: ${e.response?.data}');
      return null;
    }
  }

  /// Updates the quantity of a specific item in the cart.
  Future<CartModel?> updateCartItemQuantity(
    String itemId,
    UpdateCartItemDto dto,
  ) async {
    try {
      final response = await _apiClient.dio.patch(
        '/cart/items/$itemId',
        data: dto.toJson(),
      );
      return CartModel.fromJson(response.data);
    } on DioException catch (e) {
      print('Error updating cart item: ${e.response?.data}');
      return null;
    }
  }

  /// Removes an item completely from the cart.
  Future<CartModel?> removeItemFromCart(String itemId) async {
    try {
      final response = await _apiClient.dio.delete('/cart/items/$itemId');
      return CartModel.fromJson(response.data);
    } on DioException catch (e) {
      print('Error removing item from cart: ${e.response?.data}');
      return null;
    }
  }

  /// Removes all items from the user's cart.
  Future<bool> clearCart() async {
    try {
      await _apiClient.dio.delete('/cart');
      return true;
    } on DioException catch (e) {
      print('Error clearing cart: ${e.response?.data}');
      return false;
    }
  }
}
