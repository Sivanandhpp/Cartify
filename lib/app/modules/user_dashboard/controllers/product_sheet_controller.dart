import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductSheetController extends GetxController {
  static ProductSheetController get to => Get.find();

  late DraggableScrollableController draggableController;
  late PageController imagePageController;

  // Sheet size constants
  static const double minSheetSize = 0.1;
  static const double initialSheetSize = 0.6;
  static const double maxSheetSize = 0.95;

  // UI State Observables (Keep only what's actually used in widgets)
  var isDetailsExpanded = false.obs;
  var currentImageIndex = 0.obs;
  var cartQuantity = 0.obs;

  // Product Data Observables (Keep only what's actually used in widgets)
  var productName = 'Fresh Bell Pepper (Capsicum)';
  var productDescription =
      'Fresh, crispy bell peppers perfect for salads, cooking, and snacking. Rich in vitamins and antioxidants.'
          ;
  var productWeight = '250g';
  var deliveryTime = 'Delivery in 15-30 mins';
  var originalPrice = 85.0;
  var discountedPrice = 68.0;
  var discountPercentage = 20;

  // Seller Data Observables (Keep only what's actually used in widgets)
  var sellerName = 'Fresh Mart Store';
  var sellerLocation = 'Koramangala, Bangalore';
  var sellerRating = 4.3;

  // Product Images
  List<String> get productImages => [
    'assets/images/products/product1.png',
    'assets/images/products/product2.png',
    'assets/images/products/product3.png',
  ];

  @override
  void onInit() {
    super.onInit();
    draggableController = DraggableScrollableController();
    imagePageController = PageController();
  }

  @override
  void onClose() {
    draggableController.dispose();
    imagePageController.dispose();
    super.onClose();
  }

  // UI Actions
  void toggleDetails() {
    isDetailsExpanded.value = !isDetailsExpanded.value;
  }

  void closeSheet() {
    Get.back();
  }

  void onImagePageChanged(int index) {
    currentImageIndex.value = index;
  }

  // Product Actions
  void addToCart() {
    cartQuantity.value++;
    Get.snackbar(
      'Added to Cart',
      '${productName} added to cart',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
    );
  }

  void removeFromCart() {
    if (cartQuantity.value > 0) {
      cartQuantity.value--;
    }
  }

  void addToWishlist() {
    Get.snackbar(
      'Added to Wishlist',
      '${productName} added to wishlist',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
    );
  }

  // Seller Actions
  void visitSellerStore() {
    Get.snackbar(
      'Opening Store',
      'Redirecting to ${sellerName}',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
    );
  }

  void contactSeller() {
    Get.snackbar(
      'Contact Seller',
      'Opening chat with ${sellerName}',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
    );
  }

}
