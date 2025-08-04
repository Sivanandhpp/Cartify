import 'package:get/get.dart';
import 'package:cartify/app/core/index.dart';

/// Controller for managing hot deals data and state
class HotDealsController extends GetxController {
  // Services
  final ProductService _productService = Get.find<ProductService>();

  // State management
  final RxList<ProductModel> hotDeals = <ProductModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  // Alias for compatibility with existing views
  List<ProductModel> get products => hotDeals;

  @override
  void onInit() {
    super.onInit();
    loadHotDeals();
  }

  /// Load hot deals products from API
  Future<void> loadHotDeals() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      LogService.info('Fetching hot deals products...');

      final products = await _productService.getAllProducts();
      hotDeals.assignAll(products.take(10).toList());

      LogService.info(
        'Successfully loaded ${hotDeals.length} hot deals products',
      );
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Failed to load hot deals. Please try again.';

      LogService.error('Failed to fetch hot deals products: $e');
      NotificationService.showError(
        title: 'Error',
        message: errorMessage.value,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh hot deals data
  Future<void> refreshHotDeals() async {
    LogService.info('Refreshing hot deals...');
    await loadHotDeals();
  }
}
