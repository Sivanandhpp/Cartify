import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/index.dart';
import '../controllers/cart_controller.dart';
import 'widgets/cart_item_card.dart';
import 'widgets/delivery_tip_section.dart';
import 'widgets/bill_details_section.dart';
import 'widgets/add_more_items_section.dart';
import 'widgets/payment_section.dart';

class CartView extends GetView<CartController> {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: _buildAppBar(),
      body: Obx(() {
        if (controller.isEmpty) {
          return _buildEmptyCart();
        }

        return Column(
          children: [
            // Savings banner
            // if (controller.totalSavings > 0) _buildSavingsBanner(),

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Review your order section
                    _buildReviewOrderSection(),

                    const SizedBox(height: 16),

                    // Add more items section
                    const AddMoreItemsSection(),

                    const SizedBox(height: 16),

                    // Delivery tip section
                    // const DeliveryTipSection(),

                    // const SizedBox(height: 16),

                    // Add more items section
                    // const AddMoreItemsSection(),

                    // const SizedBox(height: 16),

                    // Bill details section
                    const BillDetailsSection(),

                    const SizedBox(height: 100), // Space for payment button
                  ],
                ),
              ),
            ),
          ],
        );
      }),
      bottomSheet: Obx(
        () => controller.isEmpty
            ? const SizedBox.shrink()
            : const PaymentSection(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.lightBackground,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Get.back(),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Kozhikode Work',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          Text(
            'Ui Technology Solutions, Ui Cyberpark, Ui Cyb...',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.share_outlined, color: Colors.black),
          onPressed: () {
            // Share functionality
          },
        ),
        IconButton(
          icon: const Icon(Icons.more_vert, color: Colors.black),
          onPressed: () {
            // More options
          },
        ),
      ],
    );
  }

  Widget _buildSavingsBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: const Color(0xFF4CAF50),
      child: Text(
        '₹${controller.totalSavings.toStringAsFixed(0)} saved! Add items worth ₹139 to get ₹100 free cash',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildReviewOrderSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const Row(
            children: [
              Text(
                'Review your Order',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Delivery info
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  '10 Mins',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.speed, size: 16, color: Color(0xFF4CAF50)),
              const SizedBox(width: 4),
              const Text(
                'Superfast',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF4CAF50),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Text(
                '${controller.itemCount} items',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Cart items
          ...controller.cartItems.map((item) => CartItemCard(item: item)),
        ],
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Your cart is empty',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add some items to get started',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: controller.addMoreItems,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.lightPrimary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Start Shopping'),
          ),
        ],
      ),
    );
  }
}
