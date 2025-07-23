import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/product_sheet_controller.dart';

class ExpandableDetailsSection extends StatelessWidget {
  final ProductSheetController controller;

  const ExpandableDetailsSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            _buildExpandButton(),
            Obx(
              () => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: controller.isDetailsExpanded.value ? null : 0,
                child: controller.isDetailsExpanded.value
                    ? _buildExpandedContent()
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandButton() {
    return Obx(
      () => InkWell(
        onTap: controller.toggleDetails,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Text(
                'Why shop from us?',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const Spacer(),
              AnimatedRotation(
                turns: controller.isDetailsExpanded.value ? 0.5 : 0,
                duration: const Duration(milliseconds: 300),
                child: const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.grey,
                  size: 24,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpandedContent() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: Column(
        children: [
          const Divider(height: 1),
          const SizedBox(height: 16),
          _buildFeatureList(),
          const SizedBox(height: 20),
          _buildNutritionalInfo(),
        ],
      ),
    );
  }

  Widget _buildFeatureList() {
    return Column(
      children: [
        _buildFeatureItem(
          icon: Icons.verified_outlined,
          title: 'Fresh & Quality Assured',
          description: 'Hand-picked fresh produce delivered to your doorstep',
        ),
        const SizedBox(height: 12),
        _buildFeatureItem(
          icon: Icons.local_shipping_outlined,
          title: 'Fast Delivery',
          description: 'Same-day delivery available in select areas',
        ),
        const SizedBox(height: 12),
        _buildFeatureItem(
          icon: Icons.price_check_outlined,
          title: 'Best Prices',
          description: 'Competitive pricing with regular discounts',
        ),
        const SizedBox(height: 12),
        _buildFeatureItem(
          icon: Icons.eco_outlined,
          title: 'Sustainable Packaging',
          description: 'Eco-friendly packaging for a greener tomorrow',
        ),
      ],
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.green.shade600, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNutritionalInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Nutritional Information (per 100g)',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          _buildNutritionRow('Energy', '25 kcal'),
          _buildNutritionRow('Protein', '1.2g'),
          _buildNutritionRow('Carbohydrates', '5.8g'),
          _buildNutritionRow('Fiber', '2.9g'),
          _buildNutritionRow('Vitamin C', '58mg'),
        ],
      ),
    );
  }

  Widget _buildNutritionRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
