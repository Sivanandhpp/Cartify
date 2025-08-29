import 'package:flutter/material.dart';
import 'package:cartify/app/core/index.dart';
import 'package:get/get.dart';

class BuyerHomeSliverAppBar extends StatelessWidget {
  final List<CategoryModel> categories;
  final String selectedLocation;
  final VoidCallback? onLocationTap;
  final VoidCallback? onCartTap;
  final Function(String)? onSearchChanged;
  final Function(CategoryModel?)?
  onCategoryTap; // Changed to accept null for "All"
  final CategoryModel? selectedCategory;

  const BuyerHomeSliverAppBar({
    super.key,
    required this.categories,
    this.selectedLocation = 'Kozhikode Work',
    this.onLocationTap,
    this.onCartTap,
    this.onSearchChanged,
    this.onCategoryTap,
    this.selectedCategory,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      backgroundColor: const Color(0xFF2196F3),
      pinned: true,
      floating: true,
      snap: false,
      elevation: 0,
      expandedHeight: 210.0,
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          final appBarHeight = constraints.biggest.height;
          final expandedHeight = 200.0;
          final collapsedHeight =
              kToolbarHeight + MediaQuery.of(context).padding.top;
          final collapseRatio =
              ((expandedHeight - appBarHeight) /
                      (expandedHeight - collapsedHeight))
                  .clamp(0.0, 1.0);

          return FlexibleSpaceBar(
            titlePadding: EdgeInsets.zero,
            background: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppColors.primary, AppColors.secondaryBrand],
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    _buildTopBar(context, collapseRatio),
                    if (collapseRatio < 0.8)
                      _buildSearchBar(context, collapseRatio),
                    if (collapseRatio < 0.5)
                      _buildCategoriesSection(context, collapseRatio),
                  ],
                ),
              ),
            ),
            title: collapseRatio > 0.5 ? _buildCollapsedContent(context) : null,
          );
        },
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, double collapseRatio) {
    return Container(
      height: kToolbarHeight,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: onLocationTap,
              child: Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          selectedLocation,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Text(
                          'UL Technology Solutions, UL Cyberpark, UL Cy...',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            onPressed: onCartTap,
            icon: const CircleAvatar(
              radius: 16,
              backgroundColor: Colors.white24,
              child: Icon(Icons.person, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, double collapseRatio) {
    return Opacity(
      opacity: (1.0 - collapseRatio * 2).clamp(0.0, 1.0),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: TextField(
          onChanged: onSearchChanged,
          decoration: InputDecoration(
            hintText: 'Search for \'Wine\'',
            hintStyle: const TextStyle(color: Colors.grey),
            prefixIcon: const Icon(Icons.search, color: Colors.grey),
            suffixIcon: Container(
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFF2196F3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.tune, color: Colors.white, size: 20),
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesSection(BuildContext context, double collapseRatio) {
    return Opacity(
      opacity: (1.0 - collapseRatio * 3).clamp(0.0, 1.0),
      child: Container(
        height: 80,
        margin: const EdgeInsets.only(top: 8),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: categories.length + 1, // +1 for "All" option
          itemBuilder: (context, index) {
            // First item is "All"
            if (index == 0) {
              final isSelected = selectedCategory == null;
              return GestureDetector(
                onTap: () {
                  // Use callback instead of direct navigation
                  onCategoryTap?.call(null);
                },
                child: Container(
                  width: 60,
                  margin: const EdgeInsets.only(right: 16),
                  child: Column(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.white
                              : Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.apps_rounded,
                          color: isSelected ? AppColors.primary : Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'All',
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.white70,
                          fontSize: 11,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            }

            // Regular categories (index - 1 because of "All" at index 0)
            final category = categories[index - 1];
            final isSelected = selectedCategory?.id == category.id;

            return GestureDetector(
              onTap: () {
                // Use callback instead of direct navigation
                onCategoryTap?.call(category);
              },
              child: Container(
                width: 60,
                margin: const EdgeInsets.only(right: 16),
                child: Column(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.white
                            : Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child:
                            category.imageUrl != null &&
                                category.imageUrl!.isNotEmpty
                            ? AppImage.network(
                                url: category.imageUrl!,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                errorWidget: _buildCategoryIcon(isSelected),
                              )
                            : _buildCategoryIcon(isSelected),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      category.name,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.white70,
                        fontSize: 11,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCategoryIcon(bool isSelected) {
    return Icon(
      Icons.category,
      color: isSelected ? AppColors.primary : Colors.white,
      size: 28,
    );
  }

  Widget _buildCollapsedContent(BuildContext context) {
    return Container(
      height: kToolbarHeight,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        onChanged: onSearchChanged,
        decoration: InputDecoration(
          hintText: 'Search for \'Ciders\'',
          hintStyle: const TextStyle(color: Colors.grey),
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          suffixIcon: Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFF2196F3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.tune, color: Colors.white, size: 20),
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
        ),
      ),
    );
  }
}
