import 'package:flutter/material.dart';
import 'package:cartify/app/core/index.dart';
import '../../controllers/seller_home_controller.dart';

class ActionsSectionWidget extends StatelessWidget {
  final SellerHomeController controller;

  const ActionsSectionWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _ActionButton(
                  title: 'Add Product',
                  subtitle: 'Create new product',
                  icon: Icons.add_circle_outline,
                  color: AppColors.primary,
                  onTap: controller.navigateToAddProduct,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ActionButton(
                  title: 'View Orders',
                  subtitle: 'Manage orders',
                  icon: Icons.list_alt_outlined,
                  color: Colors.green,
                  onTap: controller.navigateToViewOrders,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _ActionButton(
                  title: 'Products',
                  subtitle: 'Manage inventory',
                  icon: Icons.inventory_2_outlined,
                  color: Colors.blue,
                  onTap: controller.navigateToViewProducts,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ActionButton(
                  title: 'Analytics',
                  subtitle: 'View reports',
                  icon: Icons.analytics_outlined,
                  color: Colors.purple,
                  onTap: () {}, // Placeholder for future feature
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}