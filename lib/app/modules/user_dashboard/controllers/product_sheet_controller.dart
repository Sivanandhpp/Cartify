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
  var isDetailsExpanded = false.obs;
  var currentImageIndex = 0.obs;
  var isAppBarVisible = false.obs;
  var cartQuantity = 0.obs;

  // Product Data Observables
  var productName = 'Fresh Bell Pepper (Capsicum)'.obs;
  var productDescription =
      'Fresh, crispy bell peppers perfect for salads, cooking, and snacking. Rich in vitamins and antioxidants.'
          .obs;
  var productWeight = '250g'.obs;
  var deliveryTime = 'Delivery in 15-30 mins'.obs;
  var originalPrice = 85.0.obs;
  var discountedPrice = 68.0.obs;
  var discountPercentage = 20.obs;
  var minimumOrderAmount = 199.obs;
  var isVegetarian = true.obs;

  // Seller Data Observables
  var sellerName = 'Fresh Mart Store'.obs;
  var sellerLocation = 'Koramangala, Bangalore'.obs;
  var sellerRating = 4.3.obs;

  // Product Images
  var productImageUrl = ''.obs;

  List<String> get productImages => [
    if (productImageUrl.value.isNotEmpty) productImageUrl.value,
    'assets/images/products/product1.png',
    'assets/images/products/product2.png',
    'assets/images/products/product3.png',
  ];

  /// Initialize controller with API product data
  void initializeWithProduct(ApiProduct product) {
    productName.value = product.name;
    productDescription.value = product.description;
    productWeight.value = product.volume;
    originalPrice.value = product.priceINR;
    discountedPrice.value = product.offerPrice;
    discountPercentage.value = product.offerPercentage;
    sellerName.value = product.brand;
    deliveryTime.value = 'Delivery in 15-30 mins';
    minimumOrderAmount.value = 199;
    isVegetarian.value = true;
    sellerLocation.value = 'Store Location';
    sellerRating.value = product.rating;
    productImageUrl.value = product.imageUrl;
  }

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
  void toggleDetails() {
    isDetailsExpanded.value = !isDetailsExpanded.value;
  }

  void closeSheet() {
    Get.back();
  }

  void onImagePageChanged(int index) {
    currentImageIndex.value = index;
  }

  void _onSheetSizeChanged() {
    if (draggableController.isAttached) {
      final size = draggableController.size;
      isAppBarVisible.value = size > 0.8;
    }
  }

  // Product Actions
  void addToCart() {
    cartQuantity.value++;
    Get.snackbar(
      'Added to Cart',
      '${productName.value} added to cart',
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
      '${productName.value} added to wishlist',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
    );
  }
}
