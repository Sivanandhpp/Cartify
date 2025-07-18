import 'package:flutter/material.dart';
import '../../../../core/themes/app_colors.dart';
import '../../models/category_model.dart';

class CategorySection extends StatelessWidget {
  final List<CategoryModel> categories;
  const CategorySection({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        decoration: const BoxDecoration(color: AppColors.primary),

        height: 84,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemBuilder: (context, index) {
            final category = categories[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: AppColors.white,
                    child: Icon(category.icon, color: AppColors.primary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    category.label,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
