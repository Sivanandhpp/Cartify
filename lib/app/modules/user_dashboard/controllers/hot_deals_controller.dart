import 'package:get/get.dart';
import '../../../core/models/api_product_model.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/log_service.dart';

/// Controller for managing hot deals data and state
class HotDealsController extends GetxController {
  // Observable list of products
  final RxList<ApiProduct> products = <ApiProduct>[].obs;

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

      final fetchedProducts = await ApiService.fetchHotDealsProducts(limit: 10);
      products.assignAll(fetchedProducts);

      LogService.info(
        'Successfully loaded ${fetchedProducts.length} hot deals products',
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
}
