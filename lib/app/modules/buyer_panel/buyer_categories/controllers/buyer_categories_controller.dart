import 'package:cartify/app/core/index.dart';
import 'package:cartify/app/modules/buyer_panel/buyer_dashboard/controllers/product_sheet_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BuyerCategoriesController extends GetxController {
  final ProductService _productService = Get.find<ProductService>();
  final CartService _cartService = Get.find<CartService>();
  final ProductSheetController _productSheetController =
      Get.find<ProductSheetController>();

  // Observable states
  final RxList<CategoryModel> topLevelCategories = <CategoryModel>[].obs;
  final RxList<ProductModel> filteredProducts = <ProductModel>[].obs;

  final RxBool isLoadingCategories = false.obs;
  final RxBool isLoadingProducts = false.obs;
  final Rxn<CategoryModel> selectedCategory = Rxn<CategoryModel>();
  final Rxn<CategoryModel> selectedSubCategory = Rxn<CategoryModel>();

  @override
  void onInit() {
    super.onInit();
    loadCategories();
  }

  /// Load the complete category tree structure
  Future<void> loadCategories() async {
    try {
      isLoadingCategories.value = true;
      LogService.info('Loading category tree');

      final categories = await _productService.getAllCategories();
      topLevelCategories.value = categories;

      LogService.info('Loaded ${categories.length} top-level categories');
    } catch (e) {
      LogService.error('Error loading categories', e);
    } finally {
      isLoadingCategories.value = false;
    }
  }

  /// Select a main category and load all products in its tree
  Future<void> selectCategory(CategoryModel category) async {
    selectedCategory.value = category;
    selectedSubCategory.value = null;

    try {
      isLoadingProducts.value = true;
      LogService.info('Loading products for category tree', {
        'categoryId': category.id,
        'categoryName': category.name,
      });

      // Use the new category tree endpoint to get ALL products in the category tree
      final products = await _productService.getProductsInCategoryTree(
        category.id,
      );
      filteredProducts.value = products;

      LogService.info('Loaded ${products.length} products in category tree');
    } catch (e) {
      LogService.error('Error loading products for category', e);
      filteredProducts.clear();
    } finally {
      isLoadingProducts.value = false;
    }
  }

  /// Select a specific sub-category to show only its products
  Future<void> selectSubCategory(CategoryModel? subCategory) async {
    selectedSubCategory.value = subCategory;

    if (subCategory == null) {
      // Show all products in the main category tree
      if (selectedCategory.value != null) {
        await selectCategory(selectedCategory.value!);
      }
      return;
    }

    try {
      isLoadingProducts.value = true;
      LogService.info('Loading products for specific sub-category', {
        'subCategoryId': subCategory.id,
        'subCategoryName': subCategory.name,
      });

      // Use the specific category endpoint to get products ONLY from this sub-category
      final products = await _productService.getProductsByCategory(
        subCategory.id,
      );
      filteredProducts.value = products;

      LogService.info('Loaded ${products.length} products for sub-category');
    } catch (e) {
      LogService.error('Error loading products for sub-category', e);
      filteredProducts.clear();
    } finally {
      isLoadingProducts.value = false;
    }
  }

  /// Clear all selections and go back to category grid
  void clearSelection() {
    selectedCategory.value = null;
    selectedSubCategory.value = null;
    filteredProducts.clear();
  }

  /// Refresh all data
  Future<void> refresh() async {
    clearSelection();
    await loadCategories();
  }

  // ===== CART FUNCTIONALITY =====

  /// Increments product quantity in cart (adds if not exists)
  Future<void> incrementProductQuantity(String productId) async {
    final success = await _cartService.incrementProductQuantity(productId);
    if (!success) {
      Get.snackbar(
        'Error',
        'Failed to update cart',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Decrements product quantity in cart (removes if quantity becomes 0)
  Future<void> decrementProductQuantity(String productId) async {
    final success = await _cartService.decrementProductQuantity(productId);
    if (!success) {
      Get.snackbar(
        'Error',
        'Failed to update cart',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Gets quantity of a specific product in cart
  int getProductQuantityInCart(String productId) {
    return _cartService.getProductQuantityInCart(productId);
  }

  /// Show Product sheet
  void showProductSheet(BuildContext context, ProductModel product) {
    _productSheetController.showProductSheet(context, product);
  }

  // ===== GETTERS FOR UI =====

  bool get hasCategories => topLevelCategories.isNotEmpty;
  bool get hasProducts => filteredProducts.isNotEmpty;
  bool get isAnyCategorySelected => selectedCategory.value != null;
  bool get isLoading => isLoadingCategories.value || isLoadingProducts.value;

  String get selectedCategoryName => selectedCategory.value?.name ?? '';
  String get selectedSubCategoryName =>
      selectedSubCategory.value?.name ?? 'All';

  /// Get parent categories (top-level categories)
  List<CategoryModel> get parentCategories => topLevelCategories;

  /// Get sub-categories of the currently selected category
  List<CategoryModel> get subCategories =>
      selectedCategory.value?.children ?? [];

  /// Check if the selected category has sub-categories
  bool get hasSubCategories => subCategories.isNotEmpty;

  /// Get cart item count for display
  int get cartItemsCount => _cartService.cartItemsCount;

  /// Get cart total for display
  double get cartTotal => _cartService.cartTotalPrice;
}
