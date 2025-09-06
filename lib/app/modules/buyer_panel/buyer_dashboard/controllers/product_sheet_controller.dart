import 'package:cartify/app/core/models/product/product_model.dart';
import 'package:cartify/app/modules/buyer_panel/buyer_cart/controllers/buyer_cart_controller.dart';
import 'package:cartify/app/modules/buyer_panel/buyer_dashboard/views/widgets/product_sheet.dart';
import 'package:cartify/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductSheetController extends GetxController {
  final BuyerCartController cartController = Get.find<BuyerCartController>();
  final scrollController = ScrollController();
  final pageController = PageController();
  final RxDouble scrollOffset = 0.0.obs;
  final RxBool isExpanded = false.obs;
  final RxInt currentImageIndex = 0.obs;
  final RxBool isAddingToCart = false.obs;

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_handleScrollChange);
  }

  @override
  void onClose() {
    scrollController.dispose();
    pageController.dispose();
    super.onClose();
  }

  void _handleScrollChange() {
    scrollOffset.value = scrollController.offset;
  }

  void showProductSheet(BuildContext context, ProductModel product) {
    _resetState();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ProductBottomSheet(product: product),
    );
  }

  void closeSheet() {
    _resetState();
    Get.back();
  }

  void onPageChanged(int index) {
    currentImageIndex.value = index;
  }

  void onScrollUpdate(double offset) {
    final shouldExpand = offset > 0;
    if (shouldExpand != isExpanded.value) {
      isExpanded.value = shouldExpand;
    }
  }

  void _resetState() {
    isExpanded.value = false;
    currentImageIndex.value = 0;
  }

  // Business logic methods
  bool hasDescription(ProductModel product) =>
      product.description?.isNotEmpty == true;
  bool hasAttributes(ProductModel product) =>
      product.attributes?.isNotEmpty == true;
  bool isInStock(ProductModel product) => product.stockQuantity > 0;
  bool hasMultipleImages(ProductModel product) => product.images.length > 1;
  bool hasOffer(ProductModel product) => product.hasOffer;
  bool hasRating(ProductModel product) => product.averageRating > 0;
  bool hasBrandOrCategory(ProductModel product) =>
      (product.brand?.isNotEmpty == true) ||
      (product.category?.name?.isNotEmpty == true);

  // Action handlers
  void onAddToCart(ProductModel product) {
    cartController.incrementQuantity(product.id);
  }

  void onBuyNow(ProductModel product) {
    isAddingToCart.value = true;
    cartController.incrementQuantity(product.id).then((_) {
      isAddingToCart.value = false;
      Get.toNamed(Routes.BUYER_CART);
    });
  }

  void onToggleWishlist(ProductModel product) {
    // TODO: Implement wishlist functionality
  }
}
