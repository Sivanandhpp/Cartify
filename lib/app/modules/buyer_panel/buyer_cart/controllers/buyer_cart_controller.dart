import 'package:cartify/app/modules/buyer_panel/buyer_cart/views/widgets/address_selection_sheet.dart';
import 'package:cartify/app/modules/buyer_panel/buyer_profile/views/widgets/address_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/index.dart';

class BuyerCartController extends GetxController {
  final CartService _cartService = Get.find<CartService>();
  final UserService _userService = Get.find<UserService>();

  // Address management
  final selectedAddress = Rxn<Address>();
  final RxList<Address> addresses = <Address>[].obs;
  final RxBool isLoadingAddresses = false.obs;

  final RxDouble deliveryTip = 0.0.obs;
  final RxBool isProcessingPayment = false.obs;

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
    loadAddresses();
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

  // Address Management Methods
  Future<void> loadAddresses() async {
    try {
      isLoadingAddresses.value = true;
      final result = await _userService.getAddresses();
      addresses.value = result;

      // Auto-select default address if no address is selected
      if (selectedAddress.value == null && addresses.isNotEmpty) {
        final defaultAddress = addresses.firstWhereOrNull(
          (addr) => addr.isDefault,
        );
        if (defaultAddress != null) {
          selectedAddress.value = defaultAddress;
        }
      }
    } catch (e) {
      NotificationService.showError(
        title: 'Failed',
        message: 'Failed to load addresses',
      );
      LogService.error('Error loading addresses', e);
    } finally {
      isLoadingAddresses.value = false;
    }
  }

  void selectAddress(Address address) {
    selectedAddress.value = address;
  }

  Future<void> showAddAddressForm() async {
    final result = await Get.to(() => const AddressFormView());
    if (result == true) {
      await loadAddresses();
    }
  }

  Future<void> showEditAddressForm(Address address) async {
    final result = await Get.to(() => AddressFormView(address: address));
    if (result == true) {
      await loadAddresses();
    }
  }

  String getAddressTypeLabel(AddressType type) {
    switch (type) {
      case AddressType.HOME:
        return 'Home';
      case AddressType.WORK:
        return 'Work';
      case AddressType.HOSTEL:
        return 'Hostel';
      case AddressType.OTHER:
        return 'Other';
    }
  }

  IconData getAddressTypeIcon(AddressType type) {
    switch (type) {
      case AddressType.HOME:
        return Icons.home_outlined;
      case AddressType.WORK:
        return Icons.business_outlined;
      case AddressType.HOSTEL:
        return Icons.school_outlined;
      case AddressType.OTHER:
        return Icons.location_on_outlined;
    }
  }

  // Cart operations using existing CartService methods
  Future<void> incrementQuantity(String productId) async {
    final success = await _cartService.incrementProductQuantity(productId);
    if (!success) {
      Get.snackbar(
        'Error',
        'Failed to update cart',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> decrementQuantity(String productId) async {
    final success = await _cartService.decrementProductQuantity(productId);
    if (!success) {
      Get.snackbar(
        'Error',
        'Failed to update cart',
        snackPosition: SnackPosition.BOTTOM,
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
      Get.snackbar(
        'Error',
        'Failed to remove item from cart',
        snackPosition: SnackPosition.BOTTOM,
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
      Get.snackbar(
        'Error',
        'Failed to clear cart',
        snackPosition: SnackPosition.BOTTOM,
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

  // Payment processing
  Future<void> processPayment() async {
    if (isEmpty) {
      Get.snackbar(
        'Empty Cart',
        'Please add items to your cart before proceeding',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isProcessingPayment.value = true;

      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      await Future.delayed(const Duration(seconds: 3));
      Get.back();
      await clearCart();

      Get.snackbar(
        'Order Placed Successfully',
        'Your order has been placed and will be delivered soon!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      Get.back();
    } catch (e) {
      if (Get.isDialogOpen == true) {
        Get.back();
      }

      Get.snackbar(
        'Payment Failed',
        'There was an error processing your payment. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isProcessingPayment.value = false;
    }
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
          return AddressSelectionSheet();
        },
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: true,
    );
  }
}
