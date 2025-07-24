import 'package:get/get.dart';
import '../core/index.dart';

/// Example showing how to configure the hot deals grid layout dynamically
///
/// This example demonstrates different ways to configure the grid layout
/// for the hot deals section programmatically.
class HotDealsGridConfigExample {
  /// Example 1: Configure grid to 2 rows x 6 columns (default)
  static void configureDefault() {
    final ProductsService productsService = Get.find<ProductsService>();

    productsService.configureGrid(rows: 2, columns: 6);

    print('Grid configured to 2x6 layout');
    print('Total items to show: ${productsService.totalItemsToShow}');
  }

  /// Example 2: Configure grid to 3 rows x 4 columns
  static void configureCompact() {
    final ProductsService productsService = Get.find<ProductsService>();

    productsService.configureGrid(rows: 3, columns: 4);

    print('Grid configured to 3x4 layout');
    print('Total items to show: ${productsService.totalItemsToShow}');
  }

  /// Example 3: Configure grid to 1 row x 12 columns (horizontal scroll effect)
  static void configureHorizontal() {
    final ProductsService productsService = Get.find<ProductsService>();

    productsService.configureGrid(rows: 1, columns: 12);

    print('Grid configured to 1x12 layout');
    print('Total items to show: ${productsService.totalItemsToShow}');
  }

  /// Example 4: Configure grid to 4 rows x 3 columns (vertical layout)
  static void configureVertical() {
    final ProductsService productsService = Get.find<ProductsService>();

    productsService.configureGrid(rows: 4, columns: 3);

    print('Grid configured to 4x3 layout');
    print('Total items to show: ${productsService.totalItemsToShow}');
  }

  /// Example 5: Get current configuration information
  static void printCurrentConfiguration() {
    final ProductsService productsService = Get.find<ProductsService>();

    print('Current Grid Configuration:');
    print('- Rows: ${productsService.gridRows}');
    print('- Columns: ${productsService.gridColumns}');
    print('- Total Items to Show: ${productsService.totalItemsToShow}');
    print('- Available Products: ${productsService.hotDealsProducts.length}');
    print('- Total Pages: ${productsService.totalPages}');
  }

  /// Example 6: Dynamic configuration based on screen size
  static void configureBasedOnScreenSize(double screenWidth) {
    final ProductsService productsService = Get.find<ProductsService>();

    int columns;
    int rows;

    if (screenWidth > 800) {
      // Large screens - more columns
      columns = 6;
      rows = 2;
    } else if (screenWidth > 600) {
      // Medium screens
      columns = 4;
      rows = 3;
    } else {
      // Small screens - fewer columns
      columns = 2;
      rows = 6;
    }

    productsService.configureGrid(rows: rows, columns: columns);

    print('Grid configured based on screen width $screenWidth:');
    print('Layout: ${rows}x$columns');
  }

  /// Example 7: Refresh products data
  static Future<void> refreshProductsData() async {
    final ProductsService productsService = Get.find<ProductsService>();

    print('Refreshing products data...');
    await productsService.refreshData();

    if (productsService.hasError) {
      print('Error loading products: ${productsService.error}');
    } else {
      print(
        'Products loaded successfully: ${productsService.hotDealsProducts.length} items',
      );
    }
  }
}

/// Usage Examples:
/// 
/// ```dart
/// // In your controller or widget:
/// 
/// // Configure to default 2x6 layout
/// HotDealsGridConfigExample.configureDefault();
/// 
/// // Configure to compact 3x4 layout
/// HotDealsGridConfigExample.configureCompact();
/// 
/// // Configure based on screen size
/// final screenWidth = MediaQuery.of(context).size.width;
/// HotDealsGridConfigExample.configureBasedOnScreenSize(screenWidth);
/// 
/// // Print current configuration
/// HotDealsGridConfigExample.printCurrentConfiguration();
/// 
/// // Refresh data
/// await HotDealsGridConfigExample.refreshProductsData();
/// ```
