import 'package:cartify/app/core/models/product/product_model.dart';
import 'package:cartify/app/modules/buyer_panel/buyer_cart/controllers/buyer_cart_controller.dart';
import 'package:cartify/app/modules/buyer_panel/buyer_dashboard/views/widgets/product_sheet.dart';
import 'package:cartify/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Controller for managing product sheet state and interactions.
class ProductSheetController extends GetxController {
  // -----------------------
  // Dependencies
  // -----------------------
  final BuyerCartController cartController = Get.find<BuyerCartController>();

  // -----------------------
  // Reactive Variables
  // -----------------------
  final RxDouble scrollOffset = 0.0.obs;
  final RxBool isExpanded = false.obs;
  final RxInt currentImageIndex = 0.obs;
  final RxBool isAddingToCart = false.obs;

  // -----------------------
  // Private Variables
  // -----------------------
  late final ScrollController scrollController;
  late final PageController pageController;

  // -----------------------
  // Lifecycle
  // -----------------------
  @override
  void onInit() {
    super.onInit();
    scrollController = ScrollController();
    pageController = PageController();
    scrollController.addListener(_handleScrollChange);
  }

  @override
  void onClose() {
    scrollController.dispose();
    pageController.dispose();
    super.onClose();
  }

  // -----------------------
  // UI Methods
  // -----------------------

  /// Shows the product sheet modal.
  void showProductSheet(BuildContext context, ProductModel product) {
    _resetState();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ProductBottomSheet(product: product),
    );
  }

  /// Closes the product sheet.
  void closeSheet() {
    _resetState();
    Get.back();
  }

  /// Handles page changes in image carousel.
  void onPageChanged(int index) {
    currentImageIndex.value = index;
  }

  /// Updates scroll state for expansion logic.
  void onScrollUpdate(double offset) {
    final shouldExpand = offset > 0;
    if (shouldExpand != isExpanded.value) {
      isExpanded.value = shouldExpand;
    }
  }

  // -----------------------
  // Business Logic
  // -----------------------

  /// Checks if product has a description.
  bool hasDescription(ProductModel product) =>
      product.description?.isNotEmpty == true;

  /// Checks if product has attributes.
  bool hasAttributes(ProductModel product) =>
      product.attributes?.isNotEmpty == true;

  /// Checks if product is in stock.
  bool isInStock(ProductModel product) => product.stockQuantity > 0;

  /// Checks if product has multiple images.
  bool hasMultipleImages(ProductModel product) => product.images.length > 1;

  /// Checks if product has an offer.
  bool hasOffer(ProductModel product) => product.hasOffer;

  /// Checks if product has a rating.
  bool hasRating(ProductModel product) => product.averageRating > 0;

  /// Checks if product has brand or category.
  bool hasBrandOrCategory(ProductModel product) =>
      (product.brand?.isNotEmpty == true) ||
      (product.category?.name?.isNotEmpty == true);

  /// Gets product quantity in cart.
  int getProductQuantityInCart(ProductModel product) {
    return cartController.getProductQuantityInCart(product.id);
  }

  // -----------------------
  // Action Handlers
  // -----------------------

  /// Increments product quantity in cart.
  void onIncrementQuantity(ProductModel product) {
    cartController.incrementQuantity(product.id);
  }

  /// Decrements product quantity in cart.
  void onDecrementQuantity(ProductModel product) {
    cartController.decrementQuantity(product.id);
  }

  /// Handles buy now action.
  void onBuyNow(ProductModel product) {
    isAddingToCart.value = true;
    cartController.incrementQuantity(product.id).then((_) {
      isAddingToCart.value = false;
      Get.toNamed(Routes.BUYER_CART);
    });
  }

  /// Toggles product in wishlist (placeholder).
  void onToggleWishlist(ProductModel product) {
    // TODO: Implement wishlist functionality
  }

  // -----------------------
  // Private Helpers
  // -----------------------

  /// Handles scroll changes.
  void _handleScrollChange() {
    scrollOffset.value = scrollController.offset;
  }

  /// Resets sheet state.
  void _resetState() {
    isExpanded.value = false;
    currentImageIndex.value = 0;
  }
}
