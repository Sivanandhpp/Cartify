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

    // Check if a category was passed from navigation arguments
    _handleNavigationArguments();
  }

  /// Handle navigation arguments to pre-select a category
  void _handleNavigationArguments() {
    final arguments = Get.arguments as Map<String, dynamic>?;
    if (arguments != null && arguments.containsKey('selectedCategory')) {
      final CategoryModel? preSelectedCategory = arguments['selectedCategory'];
      if (preSelectedCategory != null) {
        // Wait for categories to load before selecting
        ever(topLevelCategories, (List<CategoryModel> categories) {
          if (categories.isNotEmpty) {
            // Find the category in the loaded list and select it
            final category = categories.firstWhereOrNull(
              (cat) => cat.id == preSelectedCategory.id,
            );
            if (category != null) {
              selectCategory(category);
            }
          }
        });
      }
    }
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

  /// Public method to select category directly (for dashboard navigation)
  void selectCategoryDirectly(CategoryModel categoryToSelect) {
    if (topLevelCategories.isNotEmpty) {
      // Categories already loaded, select immediately
      final category = topLevelCategories.firstWhereOrNull(
        (cat) => cat.id == categoryToSelect.id,
      );
      if (category != null) {
        selectCategory(category);
      } else {
        LogService.warning('Category not found in loaded categories', {
          'requestedCategoryId': categoryToSelect.id,
          'loadedCategoryCount': topLevelCategories.length,
        });
      }
    } else {
      // Wait for categories to load
      LogService.info('Waiting for categories to load before selecting');
      ever(topLevelCategories, (List<CategoryModel> categories) {
        if (categories.isNotEmpty) {
          final category = categories.firstWhereOrNull(
            (cat) => cat.id == categoryToSelect.id,
          );
          if (category != null) {
            selectCategory(category);
          }
        }
      });
    }
  }

  // ===== CART FUNCTIONALITY =====

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

  int getProductQuantityInCart(String productId) {
    return _cartService.getProductQuantityInCart(productId);
  }

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

  List<CategoryModel> get parentCategories => topLevelCategories;
  List<CategoryModel> get subCategories =>
      selectedCategory.value?.children ?? [];
  bool get hasSubCategories => subCategories.isNotEmpty;

  int get cartItemsCount => _cartService.cartItemsCount;
  double get cartTotal => _cartService.cartTotalPrice;
}
