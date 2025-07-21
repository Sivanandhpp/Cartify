import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/index.dart';
import '../../controllers/user_dashboard_controller.dart';
import '../../models/category_model.dart';

class CategoriesPage extends GetView<UserDashboardController> {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // App Bar
        SliverAppBar(
          floating: true,
          pinned: false,
          backgroundColor: AppColors.primary,
          title: const Text(
            'Categories',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          elevation: 0,
        ),

        // Search Bar
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search categories...',
                prefixIcon: const Icon(Icons.search, color: AppColors.grey),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
            ),
          ),
        ),

        // Categories Grid
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            delegate: SliverChildBuilderDelegate((context, index) {
              final category = controller.categories[index];
              return _buildCategoryCard(category, index);
            }, childCount: controller.categories.length),
          ),
        ),

        // Add bottom padding for safe area
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }

  Widget _buildCategoryCard(CategoryModel category, int index) {
    final colors = [
      AppColors.primary,
      Colors.orange,
      Colors.green,
      Colors.purple,
      Colors.blue,
      Colors.red,
    ];

    return Container(
      decoration: BoxDecoration(
        color: colors[index % colors.length].withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colors[index % colors.length].withOpacity(0.3),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () {
          // Navigate to category products
          Get.snackbar(
            'Category Selected',
            'Opening ${category.label} category',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 1),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(category.icon, size: 48, color: colors[index % colors.length]),
            const SizedBox(height: 12),
            Text(
              category.label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: colors[index % colors.length],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
