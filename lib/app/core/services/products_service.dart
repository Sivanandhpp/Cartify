import 'package:get/get.dart';
import '../models/hot_deals_model.dart';
import 'log_service.dart';

/// Service for managing products data from the JSON API
///
/// This service handles fetching, caching, and providing products data
/// specifically for the hot deals section and other product-related operations.
class ProductsService extends GetxService {
  static ProductsService get instance => Get.find<ProductsService>();

  // Configuration for grid layout
  final RxInt _gridRows = 2.obs;
  final RxInt _gridColumns = 6.obs;

  // Data storage
  final Rx<HotDealsModel?> _hotDeals = Rx<HotDealsModel?>(null);
  final RxBool _isLoading = false.obs;
  final RxString _error = ''.obs;

  // Getters
  int get gridRows => _gridRows.value;
  int get gridColumns => _gridColumns.value;
  int get totalItemsToShow => gridRows * gridColumns;
  HotDealsModel? get hotDeals => _hotDeals.value;
  bool get isLoading => _isLoading.value;
  String get error => _error.value;
  bool get hasError => _error.value.isNotEmpty;

  // Hot deals products getter with grid limit applied
  List<HotDealProduct> get hotDealsProducts {
    if (_hotDeals.value == null) return [];
    return _hotDeals.value!.products.take(totalItemsToShow).toList();
  }

  @override
  void onInit() {
    super.onInit();
    LogService.info('ProductsService initialized');
    _loadMockData(); // Load mock data initially
  }

  /// Configure the grid layout dynamically
  void configureGrid({int? rows, int? columns}) {
    if (rows != null && rows > 0) {
      _gridRows.value = rows;
      LogService.info('Grid rows updated to: $rows');
    }
    if (columns != null && columns > 0) {
      _gridColumns.value = columns;
      LogService.info('Grid columns updated to: $columns');
    }
  }

  /// Fetch hot deals from the JSON API
  Future<void> fetchHotDeals() async {
    try {
      _isLoading.value = true;
      _error.value = '';

      LogService.info('Loading hot deals data...');

      // For now, load mock data.
      // TODO: Implement HTTP call to fetch from API when http package is added
      _loadMockData();

      LogService.info('Hot deals loaded successfully');
    } catch (e) {
      _error.value = 'Failed to load products: ${e.toString()}';
      LogService.error('Error fetching hot deals: ${e.toString()}');

      // Fallback to mock data
      _loadMockData();
    } finally {
      _isLoading.value = false;
    }
  }

  /// Load mock data based on the attached products.json structure
  void _loadMockData() {
    try {
      LogService.info('Loading mock hot deals data...');

      // Using the exact structure from the attached products.json
      final Map<String, dynamic> mockData = {
        "title": "🌿 Today's Fresh Vegetable Deals",
        "description":
            "Handpicked from local farms! Get the freshest vegetables at the best prices.",
        "products": [
          {
            "id": "prod_veg_001",
            "name": "Fresh Onion",
            "brand": "Local Farm",
            "price": 45.00,
            "discountPrice": 32.00,
            "discountPercentage": 29,
            "unit": "kg",
            "rating": 4.6,
            "reviewCount": 1850,
            "imageUrl": "https://api.example.com/products/fresh_onion.jpg",
            "badge": "Daily Essential",
            "inStock": true,
            "fastDelivery": true,
          },
          {
            "id": "prod_veg_002",
            "name": "Ripe Tomatoes",
            "brand": "Local Farm",
            "price": 30.00,
            "discountPrice": 22.00,
            "discountPercentage": 27,
            "unit": "kg",
            "rating": 4.7,
            "reviewCount": 2100,
            "imageUrl": "https://api.example.com/products/ripe_tomatoes.jpg",
            "badge": "Best Price",
            "inStock": true,
            "fastDelivery": true,
          },
          {
            "id": "prod_veg_003",
            "name": "Fresh Potatoes",
            "brand": "Hillside Farms",
            "price": 35.00,
            "discountPrice": 25.00,
            "discountPercentage": 28,
            "unit": "kg",
            "rating": 4.5,
            "reviewCount": 1900,
            "imageUrl": "https://api.example.com/products/fresh_potatoes.jpg",
            "inStock": true,
          },
          {
            "id": "prod_veg_004",
            "name": "Carrots",
            "brand": "Organic Fields",
            "price": 60.00,
            "discountPrice": 48.00,
            "discountPercentage": 20,
            "unit": "kg",
            "rating": 4.8,
            "reviewCount": 1750,
            "imageUrl": "https://api.example.com/products/carrots.jpg",
            "badge": "Farm Fresh",
            "inStock": true,
          },
          {
            "id": "prod_veg_005",
            "name": "Spinach Bunch",
            "brand": "Green Valley",
            "price": 25.00,
            "discountPrice": 18.00,
            "discountPercentage": 28,
            "unit": "bunch",
            "rating": 4.9,
            "reviewCount": 1300,
            "imageUrl": "https://api.example.com/products/spinach.jpg",
            "inStock": true,
            "fastDelivery": true,
          },
          {
            "id": "prod_veg_006",
            "name": "Cauliflower",
            "brand": "Local Farm",
            "price": 40.00,
            "discountPrice": 30.00,
            "discountPercentage": 25,
            "unit": "piece",
            "rating": 4.6,
            "reviewCount": 1100,
            "imageUrl": "https://api.example.com/products/cauliflower.jpg",
            "inStock": true,
          },
          {
            "id": "prod_veg_007",
            "name": "Fresh Ginger",
            "brand": "Herbal Roots",
            "price": 120.00,
            "discountPrice": 95.00,
            "discountPercentage": 21,
            "unit": "kg",
            "rating": 4.7,
            "reviewCount": 2500,
            "imageUrl": "https://api.example.com/products/ginger.jpg",
            "badge": "Top Rated",
            "inStock": true,
          },
          {
            "id": "prod_veg_008",
            "name": "Garlic",
            "brand": "Local Farm",
            "price": 200.00,
            "discountPrice": 160.00,
            "discountPercentage": 20,
            "unit": "kg",
            "rating": 4.7,
            "reviewCount": 2300,
            "imageUrl": "https://api.example.com/products/garlic.jpg",
            "inStock": true,
          },
          {
            "id": "prod_veg_009",
            "name": "Green Chillies",
            "brand": "Spice Garden",
            "price": 80.00,
            "discountPrice": 65.00,
            "discountPercentage": 19,
            "unit": "kg",
            "rating": 4.6,
            "reviewCount": 1600,
            "imageUrl": "https://api.example.com/products/green_chillies.jpg",
            "inStock": true,
            "fastDelivery": true,
          },
          {
            "id": "prod_veg_010",
            "name": "Cucumber",
            "brand": "Cooling Farms",
            "price": 25.00,
            "discountPrice": 20.00,
            "discountPercentage": 20,
            "unit": "kg",
            "rating": 4.5,
            "reviewCount": 1450,
            "imageUrl": "https://api.example.com/products/cucumber.jpg",
            "inStock": true,
          },
          {
            "id": "prod_veg_011",
            "name": "Lady's Finger (Okra)",
            "brand": "Local Farm",
            "price": 50.00,
            "discountPrice": 40.00,
            "discountPercentage": 20,
            "unit": "kg",
            "rating": 4.4,
            "reviewCount": 950,
            "imageUrl": "https://api.example.com/products/ladys_finger.jpg",
            "inStock": true,
          },
          {
            "id": "prod_veg_012",
            "name": "Fresh Lemon",
            "brand": "Citrus Grove",
            "price": 60.00,
            "discountPrice": 45.00,
            "discountPercentage": 25,
            "unit": "kg",
            "rating": 4.8,
            "reviewCount": 2800,
            "imageUrl": "https://api.example.com/products/lemon.jpg",
            "inStock": true,
          },
        ],
      };

      _hotDeals.value = HotDealsModel.fromJson(mockData);
      LogService.info(
        'Mock hot deals loaded successfully: ${_hotDeals.value!.products.length} products',
      );
    } catch (e) {
      _error.value = 'Failed to load mock data: ${e.toString()}';
      LogService.error('Error loading mock data: ${e.toString()}');
    }
  }

  /// Refresh data by fetching from API
  Future<void> refreshData() async {
    LogService.info('Refreshing products data...');
    await fetchHotDeals();
  }

  /// Get products for a specific page in grid layout
  List<HotDealProduct> getProductsForPage(int page) {
    final products = hotDealsProducts;
    final startIndex = page * totalItemsToShow;
    final endIndex = (startIndex + totalItemsToShow).clamp(0, products.length);

    if (startIndex >= products.length) return [];

    return products.sublist(startIndex, endIndex);
  }

  /// Get total number of pages based on available products
  int get totalPages {
    final totalProducts = _hotDeals.value?.products.length ?? 0;
    return (totalProducts / totalItemsToShow).ceil();
  }

  /// Clear cached data and error state
  void clearData() {
    _hotDeals.value = null;
    _error.value = '';
    LogService.info('Products data cleared');
  }
}
