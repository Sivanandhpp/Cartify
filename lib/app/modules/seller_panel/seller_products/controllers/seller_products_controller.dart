import 'package:cartify/app/core/index.dart';
import 'package:get/get.dart';

class SellerProductsController extends GetxController {
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
  
  // Statistics
  final RxInt totalProducts = 0.obs;
  final RxInt activeProducts = 0.obs;
  final RxInt inactiveProducts = 0.obs;
  final RxInt lowStockProducts = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadProducts();
    
    // Listen to search changes
    debounce(searchQuery, (_) => filterProducts(), time: const Duration(milliseconds: 500));
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  // Load products (mock data for demo)
  Future<void> loadProducts() async {
    try {
      isLoading.value = true;
      
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock data - replace with actual API call
      filteredProducts.value = products;
      
      updateStatistics();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load products');
    } finally {
      isLoading.value = false;
    }
  }

  // Refresh products
  Future<void> refreshProducts() async {
    try {
      isRefreshing.value = true;
      await loadProducts();
    } finally {
      isRefreshing.value = false;
    }
  }

  // Search products
  void searchProducts(String query) {
    searchQuery.value = query;
  }

  // Filter products based on search, category, and status
  void filterProducts() {
    List<ProductModel> filtered = products;
    
    // Filter by search query
    if (searchQuery.value.isNotEmpty) {
      filtered = filtered.where((product) =>
        product.name?.toLowerCase().contains(searchQuery.value.toLowerCase()) == true ||
        product.description?.toLowerCase().contains(searchQuery.value.toLowerCase()) == true
      ).toList();
    }
    
    // Filter by category
    if (selectedCategory.value != 'All') {
      filtered = filtered.where((product) =>
        product.categoryId == selectedCategory.value
      ).toList();
    }
    
    // Filter by status
    if (selectedStatus.value != 'All') {
      bool isActive = selectedStatus.value == 'Active';
      filtered = filtered.where((product) =>
        product.isActive == isActive
      ).toList();
    }
    
    filteredProducts.value = filtered;
  }

  // Update category filter
  void updateCategoryFilter(String category) {
    selectedCategory.value = category;
    filterProducts();
  }

  // Update status filter
  void updateStatusFilter(String status) {
    selectedStatus.value = status;
    filterProducts();
  }

  // Toggle product status
  void toggleProductStatus(ProductModel product) {
    final index = products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      products[index] = product.copyWith(isActive: !(product.isActive ?? false));
      filterProducts();
      updateStatistics();
      
      Get.snackbar(
        'Success',
        'Product status updated successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Delete product
  void deleteProduct(ProductModel product) {
    Get.defaultDialog(
      title: 'Delete Product',
      middleText: 'Are you sure you want to delete "${product.name}"?',
      textCancel: 'Cancel',
      textConfirm: 'Delete',
      confirmTextColor: Get.theme.colorScheme.onError,
      buttonColor: Get.theme.colorScheme.error,
      onConfirm: () {
        products.removeWhere((p) => p.id == product.id);
        filterProducts();
        updateStatistics();
        Get.back();
        
        Get.snackbar(
          'Success',
          'Product deleted successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      },
    );
  }

  // Edit product
  void editProduct(ProductModel product) {
    // Navigate to edit product screen
    Get.toNamed('/seller/products/edit', arguments: product);
  }

  // Add new product
  void addNewProduct() {
    // Navigate to add product screen
    Get.toNamed('/seller/products/add');
  }

  // Update statistics
  void updateStatistics() {
    totalProducts.value = products.length;
    activeProducts.value = products.where((p) => p.isActive == true).length;
    inactiveProducts.value = products.where((p) => p.isActive == false).length;
    lowStockProducts.value = products.where((p) => (p.stockQuantity ?? 0) < 10).length;
  }

}