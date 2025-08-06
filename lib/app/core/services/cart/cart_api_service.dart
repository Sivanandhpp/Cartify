/// Cart API Service for Cartify
/// Handles all cart-related API calls including adding, updating,
/// removing items, and clearing the cart

import 'package:get/get.dart';

import '../../models/cart_models.dart';
import '../api_service.dart';
import '../log_service.dart';
import '../error_service.dart';

/// Service for cart API calls
class CartApiService extends GetxService {
  final ApiService _apiService = Get.find<ApiService>();

  // ============================================================================
  // CART OPERATIONS
  // ============================================================================

  /// Get current user's cart
  Future<Cart?> getCart() async {
    try {
      LogService.info('Fetching user cart');

      final response = await _apiService.get('/cart');

      if (response.statusCode == 200) {
        final cart = Cart.fromJson(response.data);
        LogService.info(
          'Cart fetched successfully with ${cart.totalItems} items',
        );
        return cart;
      } else {
        LogService.error('Failed to fetch cart: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      LogService.error('Error fetching cart: $e');
      ErrorService.showError('Failed to load cart. Please try again.');
      return null;
    }
  }

  /// Add item to cart
  Future<CartItem?> addItemToCart(String productId, int quantity) async {
    try {
      LogService.info('Adding item to cart: $productId (qty: $quantity)');

      final requestData = AddToCartDto(
        productId: productId,
        quantity: quantity,
      );

      final response = await _apiService.post(
        '/cart/items',
        data: requestData.toJson(),
      );

      if (response.statusCode == 201) {
        final cartItem = CartItem.fromJson(response.data);
        LogService.info('Item added to cart successfully');
        ErrorService.showSuccess('Item added to cart');
        return cartItem;
      } else {
        LogService.error('Failed to add item to cart: ${response.statusCode}');
        ErrorService.showError('Failed to add item to cart. Please try again.');
        return null;
      }
    } catch (e) {
      LogService.error('Error adding item to cart: $e');
      ErrorService.showError('Failed to add item to cart. Please try again.');
      return null;
    }
  }

  /// Update cart item quantity
  Future<CartItem?> updateCartItemQuantity(
    String itemId,
    int newQuantity,
  ) async {
    try {
      LogService.info(
        'Updating cart item quantity: $itemId (qty: $newQuantity)',
      );

      final requestData = UpdateCartItemDto(quantity: newQuantity);

      final response = await _apiService.patch(
        '/cart/items/$itemId',
        data: requestData.toJson(),
      );

      if (response.statusCode == 200) {
        final updatedItem = CartItem.fromJson(response.data);
        LogService.info('Cart item quantity updated successfully');
        return updatedItem;
      } else {
        LogService.error('Failed to update cart item: ${response.statusCode}');
        ErrorService.showError('Failed to update quantity. Please try again.');
        return null;
      }
    } catch (e) {
      LogService.error('Error updating cart item: $e');
      ErrorService.showError('Failed to update quantity. Please try again.');
      return null;
    }
  }

  /// Remove item from cart
  Future<bool> removeItemFromCart(String itemId) async {
    try {
      LogService.info('Removing item from cart: $itemId');

      final response = await _apiService.delete('/cart/items/$itemId');

      if (response.statusCode == 200) {
        LogService.info('Item removed from cart successfully');
        ErrorService.showSuccess('Item removed from cart');
        return true;
      } else {
        LogService.error(
          'Failed to remove item from cart: ${response.statusCode}',
        );
        ErrorService.showError('Failed to remove item. Please try again.');
        return false;
      }
    } catch (e) {
      LogService.error('Error removing item from cart: $e');
      ErrorService.showError('Failed to remove item. Please try again.');
      return false;
    }
  }

  /// Clear entire cart
  Future<bool> clearCart() async {
    try {
      LogService.info('Clearing cart');

      final response = await _apiService.delete('/cart');

      if (response.statusCode == 200) {
        LogService.info('Cart cleared successfully');
        ErrorService.showSuccess('Cart cleared');
        return true;
      } else {
        LogService.error('Failed to clear cart: ${response.statusCode}');
        ErrorService.showError('Failed to clear cart. Please try again.');
        return false;
      }
    } catch (e) {
      LogService.error('Error clearing cart: $e');
      ErrorService.showError('Failed to clear cart. Please try again.');
      return false;
    }
  }

  // ============================================================================
  // CART ITEM HELPERS
  // ============================================================================

  /// Increase item quantity by 1
  Future<CartItem?> increaseItemQuantity(
    String itemId,
    int currentQuantity,
  ) async {
    return await updateCartItemQuantity(itemId, currentQuantity + 1);
  }

  /// Decrease item quantity by 1 (removes if quantity becomes 0)
  Future<bool> decreaseItemQuantity(String itemId, int currentQuantity) async {
    if (currentQuantity <= 1) {
      return await removeItemFromCart(itemId);
    } else {
      final updatedItem = await updateCartItemQuantity(
        itemId,
        currentQuantity - 1,
      );
      return updatedItem != null;
    }
  }

  /// Check if product is already in cart
  /// This is a helper method that would be used with cached cart data
  bool isProductInCart(String productId, List<CartItem> cartItems) {
    return cartItems.any((item) => item.productId == productId);
  }

  /// Get cart item for specific product
  /// This is a helper method that would be used with cached cart data
  CartItem? getCartItemForProduct(String productId, List<CartItem> cartItems) {
    try {
      return cartItems.firstWhere((item) => item.productId == productId);
    } catch (e) {
      return null;
    }
  }

  /// Add multiple items to cart (bulk operation)
  Future<List<CartItem>> addMultipleItemsToCart(
    List<AddToCartDto> items,
  ) async {
    final List<CartItem> addedItems = [];

    for (final item in items) {
      final cartItem = await addItemToCart(item.productId, item.quantity);
      if (cartItem != null) {
        addedItems.add(cartItem);
      }
    }

    LogService.info(
      'Added ${addedItems.length} out of ${items.length} items to cart',
    );
    return addedItems;
  }

  // ============================================================================
  // CART VALIDATION
  // ============================================================================

  /// Validate cart before checkout
  Future<bool> validateCart() async {
    try {
      LogService.info('Validating cart for checkout');

      final cart = await getCart();
      if (cart == null) {
        ErrorService.showError('Cart is empty');
        return false;
      }

      if (cart.isEmpty) {
        ErrorService.showError('Cart is empty');
        return false;
      }

      // Check if all items are still available and in stock
      bool allItemsValid = true;
      for (final item in cart.items) {
        if (!item.product.isInStock) {
          ErrorService.showError('${item.product.name} is out of stock');
          allItemsValid = false;
        } else if (item.quantity > item.product.stockQuantity) {
          ErrorService.showError('${item.product.name} has insufficient stock');
          allItemsValid = false;
        }
      }

      if (allItemsValid) {
        LogService.info('Cart validation passed');
      } else {
        LogService.warning('Cart validation failed');
      }

      return allItemsValid;
    } catch (e) {
      LogService.error('Error validating cart: $e');
      ErrorService.showError('Failed to validate cart. Please try again.');
      return false;
    }
  }
}
