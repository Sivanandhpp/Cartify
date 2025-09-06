import 'package:cartify/app/modules/buyer_panel/buyer_cart/views/widgets/address_selection_sheet.dart';
import 'package:cartify/app/modules/buyer_panel/buyer_profile/controllers/buyer_address_controller.dart';
import 'package:cartify/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/index.dart';

class BuyerCartController extends GetxController {
  final CartService _cartService = Get.find<CartService>();
  final BuyerAddressController addressController =
      Get.find<BuyerAddressController>();
  final OrderService _orderService = Get.find<OrderService>();

  final RxDouble deliveryTip = 0.0.obs;
  final RxBool isProcessingPayment = false.obs;

  bool get hasAddresses => addressController.addresses.isNotEmpty;
  get isAddressLoading => addressController.isLoading.value;
  get selectedAddress => addressController.selectedAddress.value;
  get getAddressTypeIcon =>
      addressController.getAddressTypeIcon(selectedAddress.addressType);

  // Store the original order of cart items (non-reactive)
  final List<String> _itemOrder = [];

  // Getters using CartService's existing properties
  CartModel? get cartData => _cartService.cartData;

  // Modified getter to maintain stable order WITHOUT modifying reactive lists
  List<CartItem> get cartItems {
    final items = _cartService.cartData?.items ?? [];
    if (items.isEmpty) {
      return items;
    }

    // If order is not initialized, initialize it (non-reactive)
    if (_itemOrder.isEmpty && items.isNotEmpty) {
      _itemOrder.addAll(items.map((item) => item.id));
      return items;
    }

    // Sort items based on the stored order
    final sortedItems = <CartItem>[];
    final currentItemIds = items.map((item) => item.id).toSet();

    // Add items in the stored order
    for (final itemId in _itemOrder) {
      if (currentItemIds.contains(itemId)) {
        final item = items.firstWhere((item) => item.id == itemId);
        sortedItems.add(item);
      }
    }

    // Add any new items that weren't in the original order
    for (final item in items) {
      if (!_itemOrder.contains(item.id)) {
        sortedItems.add(item);
        _itemOrder.add(item.id);
      }
    }

    return sortedItems;
  }

  double get subtotal => cartItems.fold(
    0.0,
    (sum, item) => sum + (item.product.effectivePrice * item.quantity),
  );

  double get totalSavings => cartItems.fold(0.0, (sum, item) {
    if (item.product.hasOffer) {
      final discountPerItem = item.product.price - item.product.offerPrice!;
      return sum + (discountPerItem * item.quantity);
    }
    return sum;
  });

  int get itemCount => _cartService.cartItemsCount;
  bool get isEmpty => cartItems.isEmpty;
  bool get isLoading => _cartService.isLoading;
  double get cartTotalPrice => _cartService.cartTotalPrice;

  // Constants
  static const double _handlingFeeConstant = 9.80;
  static const double _deliveryPartnerFeeConstant = 30.0;
  static const double gstRate = 0.18;

  // Getters for constants (instance access)
  double get handlingFee => _handlingFeeConstant;
  double get deliveryPartnerFee => _deliveryPartnerFeeConstant;

  // Calculated values
  double get gstAmount => subtotal * gstRate;
  double get finalTotal =>
      subtotal +
      _handlingFeeConstant +
      _deliveryPartnerFeeConstant +
      gstAmount +
      deliveryTip.value;

  @override
  void onInit() {
    super.onInit();
    deliveryTip.value = 0.0;
    _loadCart();
  }

  /// Load cart data on initialization
  Future<void> _loadCart() async {
    await _cartService.getCart();
    // Initialize item order when cart is first loaded
    final items = _cartService.cartData?.items ?? [];
    if (items.isNotEmpty && _itemOrder.isEmpty) {
      _itemOrder.addAll(items.map((item) => item.id));
    }
  }

  // Cart operations using existing CartService methods
  Future<void> incrementQuantity(String productId) async {
    final success = await _cartService.incrementProductQuantity(productId);
    if (!success) {
      NotificationService.showError(
        title: 'Error',
        message: 'Failed to update cart',
      );
    }
  }

  Future<void> decrementQuantity(String productId) async {
    final success = await _cartService.decrementProductQuantity(productId);
    if (!success) {
      NotificationService.showError(
        title: 'Error',
        message: 'Failed to update cart',
      );
    } else {
      // Clean up order list after successful operation (schedule for next frame)
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _cleanupOrderList();
      });
    }
  }

  Future<void> removeItem(String cartItemId) async {
    final cart = await _cartService.removeItemFromCart(cartItemId);
    if (cart == null) {
      NotificationService.showError(
        title: 'Error',
        message: 'Failed to remove item from cart',
      );
    } else {
      // Clean up order list after successful operation
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _itemOrder.remove(cartItemId);
      });
    }
  }

  Future<void> clearCart() async {
    final success = await _cartService.clearCart();
    if (!success) {
      NotificationService.showError(
        title: 'Error',
        message: 'Failed to clear cart',
      );
    } else {
      // Clear order list after successful operation
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _itemOrder.clear();
      });
    }
  }

  /// Clean up order list to remove items that no longer exist
  void _cleanupOrderList() {
    final items = _cartService.cartData?.items ?? [];
    final currentItemIds = items.map((item) => item.id).toSet();
    _itemOrder.removeWhere((itemId) => !currentItemIds.contains(itemId));
  }

  /// Get quantity of a specific product in cart
  int getProductQuantityInCart(String productId) {
    return _cartService.getProductQuantityInCart(productId);
  }

  // Tip management
  void setDeliveryTip(double amount) {
    deliveryTip.value = amount;
  }

  void addMoreItems() {
    Get.back();
  }

  Future<void> refreshCart() async {
    await _cartService.getCart();
  }

  void showAddressSelectionSheet() {
    Get.bottomSheet(
      DraggableScrollableSheet(
        initialChildSize: 0.75,
        minChildSize: 0.5,
        maxChildSize: 0.75,
        expand: false,
        builder: (context, scrollController) {
          return const AddressSelectionSheet();
        },
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: true,
    );
  }

  /// Enhanced order validation before placing
  bool _validateOrder() {
    // Check if cart is empty
    if (isEmpty) {
      NotificationService.showError(
        title: 'Empty Cart',
        message: 'Please add items to your cart before proceeding',
      );
      return false;
    }

    // Check if address is selected
    if (selectedAddress == null) {
      NotificationService.showError(
        title: 'No Address Selected',
        message: 'Please select a delivery address',
      );
      return false;
    }

    // Validate address completeness
    if (!selectedAddress!.isValid) {
      NotificationService.showError(
        title: 'Invalid Address',
        message: 'The selected address is incomplete. Please update it.',
      );
      return false;
    }

    // Check if all items are still in stock (if you have stock validation)
    for (final item in cartItems) {
      if (item.product.stockQuantity <= 0) {
        NotificationService.showError(
          title: 'Item Out of Stock',
          message: '${item.product.name} is currently out of stock',
        );
        return false;
      }
    }

    return true;
  }

  // Replace the processPayment method with this implementation
  Future<void> processPayment() async {
    // Use the enhanced validation
    if (!_validateOrder()) {
      return;
    }

    try {
      isProcessingPayment.value = true;
      // Create order DTO
      final createOrderDto = CreateOrderDto(addressId: selectedAddress!.id);

      // Place the order
      final order = await _orderService.placeOrder(createOrderDto);

      if (order != null) {
        // Show success message with order details
        LogService.info('Order placed successfully: ${order.id}');
        // Navigate to success status screen
        Get.offNamed(Routes.BUYER_ORDER_STATUS, arguments: {'success': true, 'order': order});
        // Clear the cart after successful order
        await clearCart();
      } else {
        // Navigate to failure status screen
        Get.offNamed(Routes.BUYER_ORDER_STATUS, arguments: {'success': false});
      }
    } catch (e) {
      // Close loading dialog if open
      if (Get.isDialogOpen == true) {
        Get.back();
      }

      // Show error message
      NotificationService.showError(
        title: 'Order Failed',
        message: 'An error occurred while placing your order. Please try again.',
      );

      LogService.error('Error placing order', e);
    } finally {
      isProcessingPayment.value = false;
    }
  }
}