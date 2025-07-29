import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Example Controller for demonstration
class ExampleController extends GetxController {
  var isLoading = false.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;
  var products = <ExampleProduct>[].obs;

  // Example methods
  void refreshHotDeals() {
    // Simulate refresh
    isLoading.value = true;
    Future.delayed(Duration(seconds: 2), () {
      isLoading.value = false;
      // Load some mock data
    });
  }
}

// Example Product model for demonstration
class ExampleProduct {
  final String name;
  final String brand;
  final String category;
  final double price;
  final int stockQuantity;
  final String? imageUrl;

  ExampleProduct({
    required this.name,
    required this.brand,
    required this.category,
    required this.price,
    required this.stockQuantity,
    this.imageUrl,
  });
}

// Example usage of reusable widgets
class ExampleUsagePage extends StatelessWidget {
  final ExampleController controller = Get.put(ExampleController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reusable Widgets Example')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Example 1: Stats Cards
            Text(
              'Stats Cards Example:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),

            // StatsCardsWidget(
            //   cards: [
            //     StatsCardData(
            //       title: 'Total Sales',
            //       value: '1,234',
            //       icon: Icons.trending_up,
            //       color: Colors.green,
            //       subtitle: '+12% this month',
            //       onTap: () => print('Sales tapped'),
            //     ),
            //     StatsCardData(
            //       title: 'Products',
            //       value: '567',
            //       icon: Icons.inventory,
            //       color: Colors.blue,
            //       subtitle: '89 in stock',
            //     ),
            //   ],
            //   isLoading: false,
            // ),
            SizedBox(height: 32),

            // Example 2: Quick Actions
            Text(
              'Quick Actions Example:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),

            // QuickActionsWidget(
            //   title: 'Quick Actions',
            //   actions: [
            //     QuickActionData(
            //       title: 'Add Product',
            //       icon: Icons.add,
            //       color: Colors.blue,
            //       onTap: () => print('Add Product tapped'),
            //     ),
            //     QuickActionData(
            //       title: 'View Reports',
            //       icon: Icons.analytics,
            //       color: Colors.green,
            //       onTap: () => print('Reports tapped'),
            //     ),
            //     QuickActionData(
            //       title: 'Settings',
            //       icon: Icons.settings,
            //       color: Colors.orange,
            //       onTap: () => print('Settings tapped'),
            //     ),
            //   ],
            //   isLoading: false,
            // ),
            SizedBox(height: 32),

            // Example 3: Horizontal Product List
            Text(
              'Horizontal Product List Example:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),

            /*
            HorizontalProductListWidget<ExampleProduct>(
              title: 'Hot Deals',
              products: controller.products.take(10).toList(),
              isLoading: controller.isLoading.value,
              hasError: controller.hasError.value,
              errorMessage: controller.errorMessage.value,
              getName: (product) => product.name,
              getBrand: (product) => product.brand,
              getCategory: (product) => product.category,
              getPrice: (product) => product.price,
              getStockQuantity: (product) => product.stockQuantity,
              getImageUrl: (product) => product.imageUrl,
              onSeeAllPressed: () {
                print('See All button pressed in Hot Deals');
              },
              onRetryPressed: () => controller.refreshHotDeals(),
              onProductTap: (product) {
                print('Product tapped: ${product.name}');
              },
            ),
            */
            SizedBox(height: 32),

            // Example 4: Recent Products (Vertical List)
            Text(
              'Recent Products Example:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),

            /*
            RecentProductsWidget<ExampleProduct>(
              title: 'Recent Products',
              products: controller.products.take(5).toList(),
              isLoading: controller.isLoading.value,
              hasError: controller.hasError.value,
              errorMessage: controller.errorMessage.value,
              getName: (product) => product.name,
              getBrand: (product) => product.brand,
              getCategory: (product) => product.category,
              getPrice: (product) => product.price,
              getStockQuantity: (product) => product.stockQuantity,
              getImageUrl: (product) => product.imageUrl,
              onSeeAllPressed: () {
                print('See All button pressed in Recent Products');
              },
              onRetryPressed: () {
                print('Retry pressed');
              },
              onProductTap: (product) {
                print('Product tapped: ${product.name}');
              },
              maxItems: 5,
            ),
            */
            SizedBox(height: 32),

            // Instructions
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'How to use these widgets:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '1. Import the widgets: import "../../widgets/widgets.dart";\n'
                    '2. Use them with your data models\n'
                    '3. Provide the required callback functions\n'
                    '4. Handle loading, error, and success states\n'
                    '5. Customize colors, icons, and behavior as needed',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
