// lib/app/core/services/cart/cart_service.dart

import 'package:cartify/app/core/models/cart/add_item_to_cart_dto.dart';
import 'package:cartify/app/core/models/cart/cart_model.dart';
import 'package:cartify/app/core/models/cart/update_cart_item_dto.dart';
import 'package:cartify/app/core/services/api_client.dart';
import 'package:cartify/app/core/services/log_service.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

/// Service for managing the user's shopping cart.
class CartService {
  final ApiClient _apiClient;

  // Current cart data
  final Rx<CartModel?> _cartData = Rx<CartModel?>(null);
  final RxBool _isLoading = false.obs;

  CartService(this._apiClient);

  // Getters
  CartModel? get cartData => _cartData.value;
  bool get isLoading => _isLoading.value;
  int get cartItemsCount => _cartData.value?.items.length ?? 0;
  double get cartTotalPrice => _cartData.value?.totalPrice ?? 0.0;

  /// Retrieves the full contents of the user's cart.
  Future<CartModel?> getCart() async {
    try {
      final response = await _apiClient.dio.get('/cart');
      final cart = CartModel.fromJson(response.data);
      _cartData.value = cart;
      return cart;
    } on DioException catch (e) {
      LogService.error('Error getting cart', e.response?.data);
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
      final cart = CartModel.fromJson(response.data);
      _cartData.value = cart;
      return cart;
    } on DioException catch (e) {
      LogService.error('Error adding item to cart', e.response?.data);
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
      final cart = CartModel.fromJson(response.data);
      _cartData.value = cart;
      return cart;
    } on DioException catch (e) {
      LogService.error('Error updating cart item', e.response?.data);
      return null;
    }
  }

  /// Removes an item completely from the cart.
  Future<CartModel?> removeItemFromCart(String itemId) async {
    try {
      final response = await _apiClient.dio.delete('/cart/items/$itemId');
      final cart = CartModel.fromJson(response.data);
      _cartData.value = cart;
      return cart;
    } on DioException catch (e) {
      LogService.error('Error removing item from cart', e.response?.data);
      return null;
    }
  }

  /// Removes an item completely from the cart.
  Future<bool> removeProductFromCart(String itemId) async {
    try {
      final response = await _apiClient.dio.delete('/cart/items/$itemId');
      final cart = CartModel.fromJson(response.data);
      _cartData.value = cart;
      return true;  // Return true on success
    } on DioException catch (e) {
      LogService.error('Error removing item from cart', e.response?.data);
      return false;  // Return false on failure
    }
  }

  /// Removes all items from the user's cart.
  Future<bool> clearCart() async {
    try {
      await _apiClient.dio.delete('/cart');
      _cartData.value = CartModel(
        id: '',
        userId: null,
        items: [],
        totalPrice: 0.0,
      );
      return true;
    } on DioException catch (e) {
      LogService.error('Error clearing cart', e.response?.data);
      return false;
    }
  }

  /// Gets cart item by product ID
  CartItem? _getCartItemByProductId(String productId) {
    final cart = _cartData.value;
    if (cart == null) return null;

    try {
      return cart.items.firstWhere((item) => item.product.id == productId);
    } catch (e) {
      return null;
    }
  }

  /// Increments product quantity in cart (adds if not exists)
  Future<bool> incrementProductQuantity(String productId) async {
    try {
      _isLoading.value = true;

      final existingItem = _getCartItemByProductId(productId);
      CartModel? updatedCart;

      if (existingItem == null) {
        // Product not in cart, add it
        final addItemDto = AddItemToCartDto(productId: productId, quantity: 1);
        updatedCart = await addItemToCart(addItemDto);
      } else {
        // Product exists, update quantity
        final newQuantity = existingItem.quantity + 1;
        final updateDto = UpdateCartItemDto(quantity: newQuantity);
        updatedCart = await updateCartItemQuantity(existingItem.id, updateDto);
      }

      return updatedCart != null;
    } catch (e) {
      LogService.error('Error incrementing product quantity: $e');
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  /// Decrements product quantity in cart (removes if quantity becomes 0)
  Future<bool> decrementProductQuantity(String productId) async {
    try {
      _isLoading.value = true;

      final existingItem = _getCartItemByProductId(productId);
      if (existingItem == null) return false;

      CartModel? updatedCart;
      final newQuantity = existingItem.quantity - 1;

      if (newQuantity <= 0) {
        // Remove item completely
        updatedCart = await removeItemFromCart(existingItem.id);
      } else {
        // Update quantity
        final updateDto = UpdateCartItemDto(quantity: newQuantity);
        updatedCart = await updateCartItemQuantity(existingItem.id, updateDto);
      }

      return updatedCart != null;
    } catch (e) {
      LogService.error('Error decrementing product quantity: $e');
      return false;
    } finally {
      _isLoading.value = false;
    }
  }

  /// Gets quantity of a specific product in cart
  int getProductQuantityInCart(String productId) {
    final cartItem = _getCartItemByProductId(productId);
    return cartItem?.quantity ?? 0;
  }
}
