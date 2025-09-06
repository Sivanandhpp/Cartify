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
          centerTitle: false,
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
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.0, // Square aspect ratio
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                final category = controller.parentCategories[index];
                return _buildCategoryCard(category);
              }, childCount: controller.parentCategories.length),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(CategoryModel category) {
    return GestureDetector(
      onTap: () => controller.selectCategory(category),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Full-screen category image
              category.imageUrl != null && category.imageUrl!.isNotEmpty
                  ? AppImage.network(
                      url: category.imageUrl!,
                      fit: BoxFit.cover,
                      borderRadius: BorderRadius.circular(16),
                      errorWidget: _buildFallbackImage(),
                    )
                  : _buildFallbackImage(),

              // Dark overlay for text visibility
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                  ),
                ),
              ),

              // Category text content
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Category name with shadow
                      Text(
                        category.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              offset: Offset(1, 1),
                              blurRadius: 3,
                              color: Colors.black54,
                            ),
                          ],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      // Sub-categories count with shadow
                      Text(
                        '${category.children.length} subcategories',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          shadows: [
                            Shadow(
                              offset: Offset(1, 1),
                              blurRadius: 2,
                              color: Colors.black54,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFallbackImage() {
    return Container(
      color: Colors.grey[300],
      child: Center(
        child: Icon(Icons.category_rounded, size: 40, color: Colors.grey[600]),
      ),
    );
  }

  Widget _buildProductsView() {
    return Column(
      children: [
        if (controller.hasSubCategories) _buildSubCategoryFilter(),
        Expanded(child: _buildProductsGrid()),
      ],
    );
  }

  Widget _buildSubCategoryFilter() {
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
          _buildSubCategoryChip(
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
              child: _buildSubCategoryChip(
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

  Widget _buildSubCategoryChip(
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
              child: imageUrl != null && imageUrl.isNotEmpty
                  ? AppImage.network(
                      url: imageUrl,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                      borderRadius: BorderRadius.circular(12),
                      errorWidget: _buildSubCategoryIcon(isSelected, label == 'All'),
                    )
                  : _buildSubCategoryIcon(isSelected, label == 'All'),
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