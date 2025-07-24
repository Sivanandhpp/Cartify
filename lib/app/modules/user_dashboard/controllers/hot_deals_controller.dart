import 'package:get/get.dart';
import '../../../core/models/beverage_product_model.dart';
import '../../../core/services/beverage_api_service.dart';
import '../../../core/services/log_service.dart';

/// Controller for managing hot deals data and state
class HotDealsController extends GetxController {
  // Observable list of beverage products
  final RxList<BeverageProduct> beverageProducts = <BeverageProduct>[].obs;

  // Loading state
  final RxBool isLoading = true.obs;

  // Error state
  final RxString errorMessage = ''.obs;
  final RxBool hasError = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchHotDealsProducts();
  }

  /// Fetch hot deals products from API
  Future<void> fetchHotDealsProducts() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      LogService.info('Fetching hot deals products...');

      final products = await BeverageApiService.fetchHotDealsProducts(
        limit: 10,
      );
      beverageProducts.assignAll(products);

      LogService.info(
        'Successfully loaded ${products.length} hot deals products',
      );
    } catch (e) {
      LogService.error('Failed to fetch hot deals products: $e');
      hasError.value = true;
      errorMessage.value = 'Failed to load hot deals. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh hot deals data
  Future<void> refreshHotDeals() async {
    LogService.info('Refreshing hot deals...');
    await fetchHotDealsProducts();
  }

  /// Get limited products for display
  List<BeverageProduct> get displayProducts {
    const maxDisplay = 25;
    return beverageProducts.take(maxDisplay).toList();
  }

  /// Check if there are products to display
  bool get hasProducts => beverageProducts.isNotEmpty;

  /// Get product count
  int get productCount => beverageProducts.length;
}
