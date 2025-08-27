import 'package:cartify/app/core/index.dart';
import 'package:cartify/app/modules/buyer_panel/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/buyer_categories_controller.dart';

class BuyerCategoriesView extends GetView<BuyerCategoriesController> {
  const BuyerCategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: _buildDynamicAppBar(),
      body: Obx(() {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!controller.hasCategories) {
          return _buildEmptyState('No categories available');
        }

        return controller.isAnyCategorySelected
            ? _buildProductsView()
            : _buildCategoriesGrid();
      }),
    );
  }

  PreferredSizeWidget _buildDynamicAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: Obx(
        () => AppBar(
          backgroundColor: Colors.white,
          elevation: 0,

          automaticallyImplyLeading: false,
          leading: controller.isAnyCategorySelected
              ? IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: controller.clearSelection,
                )
              : null,
          title: Text(
            controller.isAnyCategorySelected
                ? controller.selectedCategoryName
                : 'Categories',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.black),
              onPressed: controller.refresh,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(
              Icons.shopping_basket_outlined,
              size: 50,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            message,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Pull to refresh or try again',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
          const SizedBox(height: 24),
          AppButton(text: 'Retry', onPressed: controller.refresh),
        ],
      ),
    );
  }

  Widget _buildCategoriesGrid() {
    return RefreshIndicator(
      onRefresh: controller.refresh,
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.85,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                final category = controller.parentCategories[index];
                return _buildBeautifulCategoryCard(category);
              }, childCount: controller.parentCategories.length),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBeautifulCategoryCard(CategoryModel category) {
    final colors = [
      const Color(0xFF6C63FF),
      const Color(0xFF4ECDC4),
      const Color(0xFFFF6B6B),
      const Color(0xFF4DABF7),
      const Color(0xFF69DB7C),
      const Color(0xFFFFD93D),
      const Color(0xFFFF8CC8),
      const Color(0xFF74C0FC),
    ];

    final categoryIndex = controller.parentCategories.indexOf(category);
    final cardColor = colors[categoryIndex % colors.length];

    return GestureDetector(
      onTap: () => controller.selectCategory(category),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: cardColor.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [cardColor, cardColor.withOpacity(0.8)],
              ),
            ),
            child: Stack(
              children: [
                // Background pattern
                Positioned(
                  top: -20,
                  right: -20,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -30,
                  left: -30,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                // Content
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category image container
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child:
                              category.imageUrl != null &&
                                  category.imageUrl!.isNotEmpty
                              ? Image.network(
                                  category.imageUrl!,
                                  fit: BoxFit.cover,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return Center(
                                          child: CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  Colors.white.withOpacity(0.7),
                                                ),
                                            strokeWidth: 2,
                                          ),
                                        );
                                      },
                                  errorBuilder: (context, error, stackTrace) =>
                                      _buildCategoryIcon(),
                                )
                              : _buildCategoryIcon(),
                        ),
                      ),
                      const Spacer(),
                      // Category name
                      Text(
                        category.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      // Sub-categories count
                      Text(
                        '${category.children.length} subcategories',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryIcon() {
    return const Icon(Icons.category_rounded, color: Colors.white, size: 30);
  }

  Widget _buildProductsView() {
    return Column(
      children: [
        if (controller.hasSubCategories) _buildBeautifulSubCategoryFilter(),
        Expanded(child: _buildProductsGrid()),
      ],
    );
  }

  Widget _buildBeautifulSubCategoryFilter() {
    return Container(
      height: 120,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // "All" chip with category icon
          _buildBeautifulSubCategoryChip(
            'All',
            null,
            controller.selectedSubCategory.value == null,
            () => controller.selectSubCategory(null),
          ),
          const SizedBox(width: 12),
          // Sub-category chips
          ...controller.subCategories.map((subCategory) {
            final isSelected =
                controller.selectedSubCategory.value?.id == subCategory.id;
            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: _buildBeautifulSubCategoryChip(
                subCategory.name,
                subCategory.imageUrl,
                isSelected,
                () => controller.selectSubCategory(subCategory),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildBeautifulSubCategoryChip(
    String label,
    String? imageUrl,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 80,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.grey[100],
          borderRadius: BorderRadius.circular(16),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image or icon container
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withOpacity(0.2)
                    : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? Colors.white.withOpacity(0.3)
                      : Colors.grey[300]!,
                  width: 1,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: imageUrl != null && imageUrl.isNotEmpty
                    ? Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  isSelected ? Colors.white : AppColors.primary,
                                ),
                                strokeWidth: 2,
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) =>
                            _buildSubCategoryIcon(isSelected, label == 'All'),
                      )
                    : _buildSubCategoryIcon(isSelected, label == 'All'),
              ),
            ),
            const SizedBox(height: 8),
            // Label
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? Colors.white : Colors.grey[700],
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubCategoryIcon(bool isSelected, bool isAll) {
    return Icon(
      isAll ? Icons.apps_rounded : Icons.category_outlined,
      color: isSelected ? Colors.white : AppColors.primary,
      size: 24,
    );
  }

  Widget _buildProductsGrid() {
    return Obx(() {
      if (controller.isLoadingProducts.value) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Loading products...'),
            ],
          ),
        );
      }

      if (!controller.hasProducts) {
        return _buildEmptyState('No products found in this category');
      }

      return RefreshIndicator(
        onRefresh: () async {
          if (controller.selectedCategory.value != null) {
            await controller.selectCategory(controller.selectedCategory.value!);
          }
        },
        child: GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.7,
          ),
          itemCount: controller.filteredProducts.length,
          itemBuilder: (context, index) {
            final product = controller.filteredProducts[index];
            return Obx(
              () => ProductCard(
                product: product,
                onTap: () {
                  // Open product sheet when product card is tapped
                  controller.showProductSheet(context, product);
                },
                onIncrement: () {
                  // Add to cart functionality
                  controller.incrementProductQuantity(product.id);
                },
                onDecrement: () {
                  // Remove from cart functionality
                  controller.decrementProductQuantity(product.id);
                },
                currentQuantity: controller.getProductQuantityInCart(
                  product.id,
                ),
              ),
            );
          },
        ),
      );
    });
  }
}
