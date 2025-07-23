import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/product_sheet_controller.dart';

class ProductInfoSection extends StatelessWidget {
  final ProductSheetController controller;

  const ProductInfoSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDeliveryTime(),
            const SizedBox(height: 8),
            _buildProductName(),
            const SizedBox(height: 8),
            _buildProductDescription(),
            const SizedBox(height: 20),
            _buildWeightAndDiscount(),
            const SizedBox(height: 16),
            _buildPriceAndAddButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryTime() {
    return Obx(
      () => Text(
        controller.deliveryTime.value,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildProductName() {
    return Obx(
      () => Text(
        controller.productName.value,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildProductDescription() {
    return Obx(
      () => Text(
        controller.productDescription.value,
        style: const TextStyle(color: Colors.grey, fontSize: 14, height: 1.4),
      ),
    );
  }

  Widget _buildWeightAndDiscount() {
    return Row(
      children: [
        Obx(
          () => Text(
            controller.productWeight.value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),
        const Spacer(),
        _buildPriceWithDiscount(),
      ],
    );
  }

  Widget _buildPriceWithDiscount() {
    return Row(
      children: [
        Obx(
          () => Text(
            '₹${controller.originalPrice.value}',
            style: const TextStyle(
              decoration: TextDecoration.lineThrough,
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Obx(
          () => Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.orange.shade100,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '${controller.discountPercentage.value}% OFF',
              style: TextStyle(
                color: Colors.orange.shade700,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceAndAddButton() {
    return Row(
      children: [
        _buildPriceContainer(),
        const SizedBox(width: 8),
        _buildMinimumOrderText(),
        const Spacer(),
        _buildAddButton(),
      ],
    );
  }

  Widget _buildPriceContainer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.lock, color: Colors.green.shade700, size: 16),
          const SizedBox(width: 4),
          Obx(
            () => Text(
              '₹${controller.discountedPrice.value}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMinimumOrderText() {
    return Obx(
      () => Text(
        'SHOP FOR ₹${controller.minimumOrderAmount.value}',
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return Obx(
      () => ElevatedButton(
        onPressed: controller.addToCart,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          elevation: 0,
        ),
        child: Text(
          controller.cartQuantity.value > 0
              ? 'ADD (${controller.cartQuantity.value})'
              : 'ADD',
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
    );
  }
}
