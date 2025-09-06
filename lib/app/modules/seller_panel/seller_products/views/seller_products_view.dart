import 'package:cartify/app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/seller_products_controller.dart';
import 'widgets/seller_product_card.dart';

class SellerProductsView extends GetView<SellerProductsController> {
  const SellerProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: const Text(
          'My Products',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.white,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          // Statistics Cards
          // _buildStatisticsSection(),

          // Search and Filter Section
          _buildSearchAndFilterSection(),

          // Products List
          Expanded(
            child: Obx(() {
              if (controller.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.filteredProducts.isEmpty) {
                return _buildEmptyState();
              }

              return RefreshIndicator(
                onRefresh: controller.refreshProducts,
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 20),
                  itemCount: controller.filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = controller.filteredProducts[index];
                    return SellerProductCard(
                      product: product,
                      onEdit: () => controller.editProduct(product),
                      onDelete: () => controller.deleteProduct(product),
                      onToggleStatus: () =>
                          controller.toggleProductStatus(product),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.addNewProduct,
        tooltip: 'Add New Product',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildStatisticsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Obx(
        () => Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Total',
                controller.totalProducts.toString(),
                Icons.inventory,
                Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Active',
                controller.activeProducts.toString(),
                Icons.visibility,
                Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Inactive',
                controller.inactiveProducts.toString(),
                Icons.visibility_off,
                Colors.orange,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Low Stock',
                controller.lowStockProducts.toString(),
                Icons.warning,
                Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(title, style: TextStyle(fontSize: 12, color: color)),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilterSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: Colors.white,
      child: Column(
        children: [
          // Search Bar
          TextField(
            onChanged: controller.searchProducts,
            decoration: InputDecoration(
              hintText: 'Search Products',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.blue),
              ),
              filled: true,
              fillColor: Colors.grey[50],
            ),
          ),

          const SizedBox(height: 12),

          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // Category Filter - Using actual categories
                Obx(
                  () => _buildFilterChip(
                    'Category',
                    controller.selectedCategory.value,
                    controller.availableCategories, // Using actual categories
                    controller.updateCategoryFilter,
                  ),
                ),

                const SizedBox(width: 8),

                // Status Filter
                Obx(
                  () => _buildFilterChip(
                    'Status',
                    controller.selectedStatus.value,
                    ['All', 'Active', 'Inactive'],
                    controller.updateStatusFilter,
                  ),
                ),

                const SizedBox(width: 8),

                // Stock Filter
                Obx(
                  () => _buildFilterChip(
                    'Stock',
                    controller.selectedStockFilter.value,
                    ['All', 'In Stock', 'Low Stock', 'Out of Stock'],
                    controller.updateStockFilter,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    String label,
    String selectedValue,
    List<String> options,
    Function(String) onSelected,
  ) {
    return PopupMenuButton<String>(
      onSelected: onSelected,
      child: Chip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$label: $selectedValue',
              style: TextStyle(
                fontSize: 12,
                fontWeight: selectedValue != 'All'
                    ? FontWeight.w600
                    : FontWeight.normal,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.arrow_drop_down,
              size: 18,
              color: selectedValue != 'All'
                  ? Colors.blue[700]
                  : Colors.grey[600],
            ),
          ],
        ),
        backgroundColor: selectedValue != 'All'
            ? Colors.blue[100]
            : Colors.grey[200],
        side: BorderSide(
          color: selectedValue != 'All' ? Colors.blue[300]! : Colors.grey[300]!,
        ),
      ),
      itemBuilder: (context) => options
          .map(
            (option) => PopupMenuItem(
              value: option,
              child: Row(
                children: [
                  if (option == selectedValue)
                    Icon(Icons.check, size: 16, color: Colors.blue[700])
                  else
                    const SizedBox(width: 16),
                  const SizedBox(width: 8),
                  Expanded(child: Text(option)),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No products found',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Obx(
            () => Text(
              controller.searchQuery.value.isNotEmpty
                  ? 'No products match your search criteria'
                  : 'Add your first product to get started',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: controller.addNewProduct,
            icon: const Icon(Icons.add),
            label: const Text('Add Product'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
