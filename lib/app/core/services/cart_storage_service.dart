import 'package:get_storage/get_storage.dart';
import '../config/app_config.dart';
import '../models/cart_item_model.dart';
import 'log_service.dart';

/// Production-level cart storage service
///
/// Handles all local storage operations for cart data with error handling
/// and comprehensive logging for debugging and monitoring.
class CartStorageService {
  static final GetStorage _storage = GetStorage();

  /// Load cart items from local storage
  static List<CartItem> loadCartItems() {
    try {
      final cartData = _storage.read<List>(AppConfig.cartStorageKey);
      if (cartData != null && cartData.isNotEmpty) {
        final items = cartData
            .map((item) => CartItem.fromJson(Map<String, dynamic>.from(item)))
            .toList();
        LogService.info('Cart loaded from storage: ${items.length} items');
        return items;
      }
      LogService.debug('No cart data found in storage');
      return [];
    } catch (e) {
      LogService.error('Failed to load cart from storage', e);
      return [];
    }
  }

  /// Save cart items to local storage
  static Future<void> saveCartItems(List<CartItem> items) async {
    try {
      final cartData = items.map((item) => item.toJson()).toList();
      await _storage.write(AppConfig.cartStorageKey, cartData);
      LogService.debug('Cart saved to storage: ${items.length} items');
    } catch (e) {
      LogService.error('Failed to save cart to storage', e);
      throw Exception('Failed to save cart to storage');
    }
  }

  /// Clear all cart data from storage
  static Future<void> clearCartStorage() async {
    try {
      await _storage.remove(AppConfig.cartStorageKey);
      LogService.info('Cart storage cleared');
    } catch (e) {
      LogService.error('Failed to clear cart storage', e);
      throw Exception('Failed to clear cart storage');
    }
  }

  /// Check if cart data exists in storage
  static bool hasCartData() {
    try {
      final cartData = _storage.read<List>(AppConfig.cartStorageKey);
      return cartData != null && cartData.isNotEmpty;
    } catch (e) {
      LogService.error('Failed to check cart data existence', e);
      return false;
    }
  }

  /// Get cart data size (number of items)
  static int getCartSize() {
    try {
      final cartData = _storage.read<List>(AppConfig.cartStorageKey);
      return cartData?.length ?? 0;
    } catch (e) {
      LogService.error('Failed to get cart size', e);
      return 0;
    }
  }
}
