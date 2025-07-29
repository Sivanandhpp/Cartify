import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/widgets.dart'; // Import the barrel file

// Example Controller
class HotDealsController extends GetxController {
  var products = <ExampleProduct>[].obs;
  var isLoading = false.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;

  void refreshHotDeals() {
    isLoading.value = true;
    hasError.value = false;

    // Simulate API call
    Future.delayed(Duration(seconds: 2), () {
      isLoading.value = false;
      // Simulate some products
      products.value = [
        ExampleProduct(
          name: 'iPhone 15 Pro',
          brand: 'Apple',
          category: 'Smartphones',
          price: 999.99,
          stockQuantity: 25,
          imageUrl: 'https://example.com/iphone15pro.jpg',
        ),
        ExampleProduct(
          name: 'MacBook Air M2',
          brand: 'Apple',
          category: 'Laptops',
          price: 1199.99,
          stockQuantity: 15,
          imageUrl: 'https://example.com/macbook.jpg',
        ),
        // Add more products...
      ];
    });
  }
}

// Example Product Model
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

// Example Page using the reusable widgets exactly as requested
class ExampleDashboardPage extends StatelessWidget {
  final HotDealsController hotDealsController = Get.put(HotDealsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats Cards Section
            StatsCardsWidget(
              cards: [
                StatsCardData(
                  title: 'Total Sales',
                  value: '1,234',
                  icon: Icons.trending_up,
                  color: Colors.green,
                  subtitle: '+12% this month',
                  onTap: () => print('Sales card tapped'),
                ),
                StatsCardData(
                  title: 'Products',
                  value: '567',
                  icon: Icons.inventory,
                  color: Colors.blue,
                  subtitle: '89 in stock',
                  onTap: () => print('Products card tapped'),
                ),
                StatsCardData(
                  title: 'Orders',
                  value: '890',
                  icon: Icons.shopping_cart,
                  color: Colors.orange,
                  subtitle: '45 pending',
                  onTap: () => print('Orders card tapped'),
                ),
                StatsCardData(
                  title: 'Revenue',
                  value: '\$12.5K',
                  icon: Icons.attach_money,
                  color: Colors.purple,
                  subtitle: '+8.5% growth',
                  onTap: () => print('Revenue card tapped'),
                ),
              ],
            ),

            SizedBox(height: 32),

            // Quick Actions Section
            QuickActionsWidget(
              title: 'Quick Actions',
              actions: [
                QuickActionData(
                  title: 'Add Product',
                  icon: Icons.add_box,
                  color: Colors.blue,
                  onTap: () => print('Add Product tapped'),
                ),
                QuickActionData(
                  title: 'View Orders',
                  icon: Icons.list_alt,
                  color: Colors.green,
                  onTap: () => print('View Orders tapped'),
                ),
                QuickActionData(
                  title: 'Analytics',
                  icon: Icons.analytics,
                  color: Colors.purple,
                  onTap: () => print('Analytics tapped'),
                ),
              ],
            ),

            SizedBox(height: 32),

            // Horizontal Product List - EXACTLY as requested in the user's example
            Obx(
              () => HorizontalProductListWidget<ExampleProduct>(
                title: 'Hot deals',
                products: hotDealsController.products.take(10).toList(),
                isLoading: hotDealsController.isLoading.value,
                hasError: hotDealsController.hasError.value,
                errorMessage: hotDealsController.errorMessage.value,
                getName: (product) => product.name,
                getBrand: (product) => product.brand,
                getCategory: (product) => product.category,
                getPrice: (product) => product.price,
                getStockQuantity: (product) => product.stockQuantity,
                getImageUrl: (product) => product.imageUrl,
                onSeeAllPressed: () {
                  print('See All button pressed in Hot Deals');
                  // LogService.info('See All button pressed in Hot Deals');
                },
                onRetryPressed: () => hotDealsController.refreshHotDeals(),
                onProductTap: (product) {
                  print('Product tapped: ${product.name}');
                },
              ),
            ),

            SizedBox(height: 32),

            // Recent Products Section
            Obx(
              () => RecentProductsWidget<ExampleProduct>(
                title: 'Recent Products',
                products: hotDealsController.products.take(5).toList(),
                isLoading: hotDealsController.isLoading.value,
                hasError: hotDealsController.hasError.value,
                errorMessage: hotDealsController.errorMessage.value,
                getName: (product) => product.name,
                getBrand: (product) => product.brand,
                getCategory: (product) => product.category,
                getPrice: (product) => product.price,
                getStockQuantity: (product) => product.stockQuantity,
                getImageUrl: (product) => product.imageUrl,
                onSeeAllPressed: () {
                  print('See All button pressed in Recent Products');
                },
                onRetryPressed: () => hotDealsController.refreshHotDeals(),
                onProductTap: (product) {
                  print('Recent product tapped: ${product.name}');
                },
                maxItems: 5,
              ),
            ),

            SizedBox(height: 32),

            // Example of different configurations
            Text(
              'Different Configurations:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16),

            // Horizontal Product List with different settings
            Obx(
              () => HorizontalProductListWidget<ExampleProduct>(
                title: 'Featured Products',
                products: hotDealsController.products,
                isLoading: hotDealsController.isLoading.value,
                hasError: hotDealsController.hasError.value,
                errorMessage: hotDealsController.errorMessage.value,
                getName: (product) => product.name,
                getBrand: (product) => product.brand,
                getCategory: (product) => product.category,
                getPrice: (product) => product.price,
                getStockQuantity: (product) => product.stockQuantity,
                getImageUrl: (product) => product.imageUrl,
                onSeeAllPressed: () {
                  print('See All Featured Products');
                },
                onRetryPressed: () => hotDealsController.refreshHotDeals(),
                onProductTap: (product) {
                  print('Featured product tapped: ${product.name}');
                },
                itemWidth: 200, // Wider cards
                itemHeight: 240, // Taller cards
              ),
            ),

            SizedBox(height: 32),

            // Usage Instructions
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '✅ Perfect! These widgets are now reusable',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.blue.shade700,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Usage pattern exactly as requested:\n\n'
                    'HorizontalProductListWidget(\n'
                    '  title: \'Hot deals\',\n'
                    '  products: hotDealsController.products.take(10).toList(),\n'
                    '  isLoading: hotDealsController.isLoading.value,\n'
                    '  hasError: hotDealsController.hasError.value,\n'
                    '  errorMessage: hotDealsController.errorMessage.value,\n'
                    '  onSeeAllPressed: () {\n'
                    '    LogService.info(\'See All button pressed in Hot Deals\');\n'
                    '  },\n'
                    '  onRetryPressed: () => hotDealsController.refreshHotDeals(),\n'
                    ');',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      color: Colors.blue.shade800,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16),

            // Load data button for demo
            ElevatedButton(
              onPressed: () => hotDealsController.refreshHotDeals(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('Load Sample Data'),
            ),
          ],
        ),
      ),
    );
  }
}
