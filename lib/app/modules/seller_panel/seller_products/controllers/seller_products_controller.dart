import 'package:cartify/app/core/index.dart';
import 'package:cartify/app/core/widgets/app_dialog.dart';
import 'package:cartify/app/routes/app_pages.dart';
import 'package:get/get.dart';

class SellerProductsController extends GetxController {
  // Services
  final ProductService _productService = Get.find<ProductService>();

  // Observable lists
  final RxList<ProductModel> products = <ProductModel>[].obs;
  final RxList<ProductModel> filteredProducts = <ProductModel>[].obs;

  // Loading states
  final RxBool isLoading = false.obs;
  final RxBool isRefreshing = false.obs;

  // Search and filter
  final RxString searchQuery = ''.obs;
  final RxString selectedCategory = 'All'.obs;
  final RxString selectedStatus = 'All'.obs;

  // New filter for stock status
  final RxString selectedStockFilter = 'All'.obs;

  // Statistics
  final RxInt totalProducts = 0.obs;
  final RxInt activeProducts = 0.obs;
  final RxInt inactiveProducts = 0.obs;
  final RxInt lowStockProducts = 0.obs;

  // Observable for actual categories
  final RxList<String> _availableCategories = <String>['All'].obs;

  // Getter for available categories
  List<String> get availableCategories => _availableCategories.toList();

  @override
  void onInit() {
    super.onInit();
    loadProducts();
    _extractCategories(); // Extract categories from products

    // Listen to search changes
    debounce(
      searchQuery,
      (_) => filterProducts(),
      time: const Duration(milliseconds: 500),
    );
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  // Load products from API (replaces mock data)
  Future<void> loadProducts() async {
    try {
      isLoading.value = true;

      LogService.info('Loading seller products from API');

      // Actual API call to GET /products/admin
      final fetchedProducts = await _productService.getMyProducts();

      if (fetchedProducts.isNotEmpty) {
        products.assignAll(fetchedProducts);
        filteredProducts.assignAll(fetchedProducts);

        LogService.info(
          'Successfully loaded ${fetchedProducts.length} products',
        );

        updateStatistics();

        NotificationService.showSuccess(
          title: 'Products Loaded',
          message: 'Found ${fetchedProducts.length} products in your inventory',
        );
      } else {
        // Handle empty result
        products.clear();
        filteredProducts.clear();
        updateStatistics();

        LogService.info('No products found for seller');
      }
    } catch (e) {
      LogService.error('Failed to load seller products', e);

      NotificationService.showError(
        title: 'Loading Failed',
        message: 'Failed to load your products. Please try again.',
      );

      // Clear products on error
      products.clear();
      filteredProducts.clear();
      updateStatistics();
    } finally {
      isLoading.value = false;
    }
  }

  // Refresh products
  Future<void> refreshProducts() async {
    try {
      isRefreshing.value = true;
      LogService.info('Refreshing seller products');

      await loadProducts();

      LogService.info('Products refreshed successfully');
    } catch (e) {
      LogService.error('Failed to refresh products', e);

      NotificationService.showError(
        title: 'Refresh Failed',
        message: 'Failed to refresh products. Please try again.',
      );
    } finally {
      isRefreshing.value = false;
    }
  }

  // Load products by category (optional filter)
  Future<void> loadProductsByCategory(String categoryId) async {
    try {
      isLoading.value = true;

      LogService.info('Loading seller products by category', {
        'categoryId': categoryId,
      });

      // Note: If your ProductService doesn't have getMyProductsByCategory,
      // you can modify the getMyProducts method to accept categoryId parameter
      // For now, we'll load all and filter locally
      await loadProducts();

      // Filter by category locally if needed
      if (categoryId != 'All') {
        final categoryFiltered = products
            .where(
              (product) =>
                  product.categoryId == categoryId ||
                  product.category?.id == categoryId,
            )
            .toList();

        filteredProducts.assignAll(categoryFiltered);
      }
    } catch (e) {
      LogService.error('Failed to load products by category', e);

      NotificationService.showError(
        title: 'Loading Failed',
        message: 'Failed to load products for selected category.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Search products
  void searchProducts(String query) {
    searchQuery.value = query;
  }

  /// Extract unique categories from products
  void _extractCategories() {
    final categorySet = <String>{'All'};
    print('yyyyyyyyyyyyyyyyyyyyyyyyyyyy');
    for (final product in products) {
      print('Product: ${product.name}');
      if (product.category != null && product.category!.name.isNotEmpty) {
        print('Category: ${product.category!.name}');
        categorySet.add(product.category!.name);
      }
    }

    _availableCategories.assignAll(categorySet.toList()..sort());

    LogService.debug('Categories extracted', {
      'categories': _availableCategories.length - 1, // Exclude 'All'
      'list': _availableCategories.sublist(1), // Show actual categories
    });
  }

  // Filter products based on search, category, and status
  void filterProducts() {
    List<ProductModel> filtered = List.from(products);

    // Filter by search query
    if (searchQuery.value.isNotEmpty) {
      filtered = filtered
          .where(
            (product) =>
                product.name.toLowerCase().contains(
                  searchQuery.value.toLowerCase(),
                ) ||
                (product.description?.toLowerCase().contains(
                      searchQuery.value.toLowerCase(),
                    ) ??
                    false),
          )
          .toList();
    }

    // Filter by category
    if (selectedCategory.value != 'All') {
      filtered = filtered
          .where(
            (product) =>
                product.categoryId == selectedCategory.value ||
                product.category?.id == selectedCategory.value,
          )
          .toList();
    }

    // Filter by status
    if (selectedStatus.value != 'All') {
      bool isActive = selectedStatus.value == 'Active';
      filtered = filtered
          .where((product) => product.isActive == isActive)
          .toList();
    }

    // Apply stock filter
    if (selectedStockFilter.value != 'All') {
      switch (selectedStockFilter.value) {
        case 'In Stock':
          filtered = filtered
              .where((product) => product.stockQuantity > 10)
              .toList();
          break;
        case 'Low Stock':
          filtered = filtered
              .where(
                (product) =>
                    product.stockQuantity > 0 && product.stockQuantity <= 10,
              )
              .toList();
          break;
        case 'Out of Stock':
          filtered = filtered
              .where((product) => product.stockQuantity == 0)
              .toList();
          break;
      }
    }

    filteredProducts.assignAll(filtered);

    LogService.debug('Filtered products', {
      'originalCount': products.length,
      'filteredCount': filtered.length,
      'searchQuery': searchQuery.value,
      'selectedCategory': selectedCategory.value,
      'selectedStatus': selectedStatus.value,
      'selectedStockFilter': selectedStockFilter.value,
    });
  }

  /// Update category filter
  void updateCategoryFilter(String category) {
    selectedCategory.value = category;
    _applyFilters();

    LogService.debug('Category filter updated', {'category': category});
  }

  /// Update stock filter
  void updateStockFilter(String stockFilter) {
    selectedStockFilter.value = stockFilter;
    _applyFilters();

    LogService.debug('Stock filter updated', {'stockFilter': stockFilter});
  }

  /// Apply all filters to products
  void _applyFilters() {
    List<ProductModel> filtered = List.from(products);

    // Apply search filter
    if (searchQuery.value.isNotEmpty) {
      filtered = filtered
          .where(
            (product) =>
                product.name.toLowerCase().contains(
                  searchQuery.value.toLowerCase(),
                ) ||
                (product.category?.name.toLowerCase().contains(
                      searchQuery.value.toLowerCase(),
                    ) ??
                    false),
          )
          .toList();
    }

    // Apply category filter
    if (selectedCategory.value != 'All') {
      filtered = filtered
          .where((product) => product.category?.name == selectedCategory.value)
          .toList();
    }

    // Apply status filter
    if (selectedStatus.value != 'All') {
      final isActive = selectedStatus.value == 'Active';
      filtered = filtered
          .where((product) => (product.isActive ?? true) == isActive)
          .toList();
    }

    // Apply stock filter
    if (selectedStockFilter.value != 'All') {
      switch (selectedStockFilter.value) {
        case 'In Stock':
          filtered = filtered
              .where((product) => product.stockQuantity > 10)
              .toList();
          break;
        case 'Low Stock':
          filtered = filtered
              .where(
                (product) =>
                    product.stockQuantity > 0 && product.stockQuantity <= 10,
              )
              .toList();
          break;
        case 'Out of Stock':
          filtered = filtered
              .where((product) => product.stockQuantity == 0)
              .toList();
          break;
      }
    }

    filteredProducts.assignAll(filtered);

    LogService.debug('Filters applied', {
      'total': products.length,
      'filtered': filteredProducts.length,
      'search': searchQuery.value,
      'category': selectedCategory.value,
      'status': selectedStatus.value,
      'stock': selectedStockFilter.value,
    });
  }

  // Update status filter
  void updateStatusFilter(String status) {
    selectedStatus.value = status;
    filterProducts();
  }

  // Toggle product status (with API call)
  Future<void> toggleProductStatus(ProductModel product) async {
    try {
      final newStatus = !(product.isActive ?? false);

      LogService.info('Toggling product status', {
        'productId': product.id,
        'currentStatus': product.isActive,
        'newStatus': newStatus,
      });

      // Call API to update product status
      final updatedProduct = await _productService.toggleProductStatus(
        product.id,
        newStatus,
      );

      if (updatedProduct != null) {
        // Update local product list
        final index = products.indexWhere((p) => p.id == product.id);
        if (index != -1) {
          products[index] = updatedProduct;
          filterProducts();
          updateStatistics();

          NotificationService.showSuccess(
            title: 'Status Updated',
            message: 'Product status updated successfully',
          );

          LogService.info('Product status updated successfully', {
            'productId': product.id,
            'newStatus': updatedProduct.isActive,
          });
        }
      } else {
        throw Exception('Failed to update product status');
      }
    } catch (e) {
      LogService.error('Failed to toggle product status', {
        'productId': product.id,
        'error': e.toString(),
      });

      NotificationService.showError(
        title: 'Update Failed',
        message: 'Failed to update product status. Please try again.',
      );
    }
  }

  // Delete product (with API call)
  Future<void> deleteProduct(ProductModel product) async {
    AppDialog(
      title: 'Delete Product',
      content:
          'Are you sure you want to delete "${product.name}"? This action cannot be undone.',
      confirmText: 'Delete',
      confirmButtonColor: AppColors.error,
      onConfirm: () async {
        Get.back(); // Close dialog first

        try {
          LogService.info('Deleting product', {
            'productId': product.id,
            'productName': product.name,
          });

          final success = await _productService.deleteProduct(product.id);

          if (success) {
            // Remove from local lists
            products.removeWhere((p) => p.id == product.id);
            filterProducts();
            updateStatistics();

            NotificationService.showSuccess(
              title: 'Product Deleted',
              message: 'Product "${product.name}" deleted successfully',
            );

            LogService.info('Product deleted successfully', {
              'productId': product.id,
            });
          } else {
            throw Exception('Failed to delete product');
          }
        } catch (e) {
          LogService.error('Failed to delete product', {
            'productId': product.id,
            'error': e.toString(),
          });

          NotificationService.showError(
            title: 'Delete Failed',
            message: 'Failed to delete product. Please try again.',
          );
        }
      },
      onCancel: () => Get.back(),
    ).show();
  }

  // Edit product
  void editProduct(ProductModel product) {
    LogService.info('Navigating to edit product', {
      'productId': product.id,
      'productName': product.name,
    });

    // Navigate to edit product screen
    Get.toNamed(Routes.SELLER_CREATE_PRODUCT, arguments: product);
  }

  // Add new product
  void addNewProduct() {
    LogService.info('Navigating to add new product');

    // Navigate to add product screen (your existing create product flow)
    Get.toNamed(Routes.SELLER_CREATE_PRODUCT);
  }

  // Update statistics based on current products
  void updateStatistics() {
    totalProducts.value = products.length;
    activeProducts.value = products.where((p) => p.isActive == true).length;
    inactiveProducts.value = products.where((p) => p.isActive == false).length;
    lowStockProducts.value = products.where((p) => p.stockQuantity < 10).length;

    LogService.debug('Updated product statistics', {
      'total': totalProducts.value,
      'active': activeProducts.value,
      'inactive': inactiveProducts.value,
      'lowStock': lowStockProducts.value,
    });
  }

  // Get products by status (helper method)
  List<ProductModel> getProductsByStatus(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return products.where((p) => p.isActive == true).toList();
      case 'inactive':
        return products.where((p) => p.isActive == false).toList();
      case 'low_stock':
        return products.where((p) => p.stockQuantity < 10).toList();
      default:
        return products.toList();
    }
  }

  // Get products by category (helper method)
  List<ProductModel> getProductsByCategory(String categoryId) {
    if (categoryId == 'All') return products.toList();

    return products
        .where(
          (product) =>
              product.categoryId == categoryId ||
              product.category?.id == categoryId,
        )
        .toList();
  }

  /// Reset all filters
  void resetFilters() {
    searchQuery.value = '';
    selectedCategory.value = 'All';
    selectedStatus.value = 'All';
    selectedStockFilter.value = 'All';
    filterProducts();

    LogService.info('All filters reset');
  }
}
