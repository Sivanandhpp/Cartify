import 'package:cartify/app/core/models/product/category_model.dart';
import 'package:cartify/app/core/models/product/product_model.dart';
import 'package:cartify/app/core/services/product/product_service.dart';
import 'package:get/get.dart';

class BuyerCategoriesController extends GetxController {
  final ProductService _productService = Get.find<ProductService>();

  // Observable states
  final RxList<CategoryModel> allCategories = <CategoryModel>[].obs;
  final RxList<CategoryModel> parentCategories = <CategoryModel>[].obs;
  final RxList<CategoryModel> subCategories = <CategoryModel>[].obs;
  final RxList<ProductModel> allProducts = <ProductModel>[].obs;
  final RxList<ProductModel> filteredProducts = <ProductModel>[].obs;
  
  final RxBool isLoadingCategories = false.obs;
  final RxBool isLoadingProducts = false.obs;
  final RxString selectedCategoryId = ''.obs;
  final RxString selectedSubCategoryId = ''.obs;
  final Rxn<CategoryModel> selectedCategory = Rxn<CategoryModel>();
  final Rxn<CategoryModel> selectedSubCategory = Rxn<CategoryModel>();

  @override
  void onInit() {
    super.onInit();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    await Future.wait([
      loadCategories(),
      loadProducts(),
    ]);
  }

  Future<void> loadCategories() async {
    try {
      isLoadingCategories.value = true;
      final categories = await _productService.getAllCategories();
      allCategories.value = categories;
      _organizeCategories();
    } finally {
      isLoadingCategories.value = false;
    }
  }

  Future<void> loadProducts() async {
    try {
      isLoadingProducts.value = true;
      final products = await _productService.getAllProducts();
      allProducts.value = products;
    } finally {
      isLoadingProducts.value = false;
    }
  }

  void _organizeCategories() {
    parentCategories.value = allCategories
        .where((category) => category.parentId == null || category.parentId!.isEmpty)
        .toList();
  }

  void selectCategory(CategoryModel category) {
    selectedCategory.value = category;
    selectedCategoryId.value = category.id;
    selectedSubCategoryId.value = '';
    selectedSubCategory.value = null;
    
    _loadSubCategories(category.id);
    _filterProductsByCategory(category.id);
  }

  void selectSubCategory(CategoryModel? subCategory) {
    if (subCategory == null) {
      selectedSubCategory.value = null;
      selectedSubCategoryId.value = '';
      _filterProductsByCategory(selectedCategoryId.value);
    } else {
      selectedSubCategory.value = subCategory;
      selectedSubCategoryId.value = subCategory.id;
      _filterProductsByCategory(subCategory.id);
    }
  }

  void _loadSubCategories(String parentCategoryId) {
    subCategories.value = allCategories
        .where((category) => category.parentId == parentCategoryId)
        .toList();
  }

  void _filterProductsByCategory(String categoryId) {
    if (categoryId.isEmpty) {
      filteredProducts.value = allProducts;
      return;
    }

    final categoryIds = _getCategoryAndSubCategoryIds(categoryId);
    filteredProducts.value = allProducts
        .where((product) => categoryIds.contains(product.category?.id))
        .toList();
  }

  List<String> _getCategoryAndSubCategoryIds(String categoryId) {
    final ids = <String>[categoryId];
    final subCats = allCategories
        .where((cat) => cat.parentId == categoryId)
        .map((cat) => cat.id)
        .toList();
    ids.addAll(subCats);
    return ids;
  }

  void clearSelection() {
    selectedCategory.value = null;
    selectedSubCategory.value = null;
    selectedCategoryId.value = '';
    selectedSubCategoryId.value = '';
    subCategories.clear();
    filteredProducts.value = allProducts;
  }

  void refresh() {
    _loadInitialData();
  }

  // Getters for UI
  bool get hasCategories => parentCategories.isNotEmpty;
  bool get hasSubCategories => subCategories.isNotEmpty;
  bool get hasProducts => filteredProducts.isNotEmpty;
  bool get isAnyCategorySelected => selectedCategory.value != null;
  String get selectedCategoryName => selectedCategory.value?.name ?? '';
  String get selectedSubCategoryName => selectedSubCategory.value?.name ?? 'All';
  bool get isLoading => isLoadingCategories.value || isLoadingProducts.value;
}