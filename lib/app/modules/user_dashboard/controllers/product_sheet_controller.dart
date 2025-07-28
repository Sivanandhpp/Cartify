import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/models/api_product_model.dart';

class ProductSheetController extends GetxController {
  static ProductSheetController get to => Get.find();

  late DraggableScrollableController draggableController;
  late PageController imagePageController;

  // Sheet size constants
  static const double minSheetSize = 0.1;
  static const double initialSheetSize = 0.6;
  static const double maxSheetSize = 0.95;

  // UI State Observables
  var isAppBarVisible = false.obs;
  var currentImageIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    draggableController = DraggableScrollableController();
    imagePageController = PageController();

    // Listen to draggable controller changes
    draggableController.addListener(_onSheetSizeChanged);
  }

  @override
  void onClose() {
    draggableController.removeListener(_onSheetSizeChanged);
    draggableController.dispose();
    imagePageController.dispose();
    super.onClose();
  }

  // UI Actions
  void closeSheet() {
    Get.back();
  }

  void onImagePageChanged(int index) {
    currentImageIndex.value = index;
  }

  /// Get product images with fallback
  List<String> getProductImages(ApiProduct product) {
    List<String> images = [];

    // Add API product images if available
    if (product.imageList.isNotEmpty) {
      images.addAll(product.imageList);
    }

    // Add fallback placeholder images if no API images
    if (images.isEmpty) {
      images.addAll([
        'assets/images/products/product1.png',
        'assets/images/products/product2.png',
        'assets/images/products/product3.png',
      ]);
    }

    return images;
  }

  void _onSheetSizeChanged() {
    if (draggableController.isAttached) {
      final size = draggableController.size;
      isAppBarVisible.value = size > 0.8;
    }
  }

  // Product Actions
  void addToCart() {
    Get.snackbar(
      'Added to Cart',
      'Product added to cart',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
    );
  }

  void removeFromCart() {
    // Cart removal logic can be handled here
  }

  void addToWishlist() {
    Get.snackbar(
      'Added to Wishlist',
      'Product added to wishlist',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
    );
  }
}
