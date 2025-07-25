// Core imports (absolute)
import 'package:cartify/app/core/index.dart';
import 'package:flutter/material.dart';

// Local widget imports (relative)
import 'api_product_card.dart';

/// Reusable horizontal product list widget with loading and error states
class HorizontalProductListWidget extends StatelessWidget {
  const HorizontalProductListWidget({
    super.key,
    required this.title,
    required this.products,
    required this.isLoading,
    required this.hasError,
    required this.errorMessage,
    this.onSeeAllPressed,
    this.onRetryPressed,
    this.height = 300,
  });

  final String title;
  final List<ApiProduct> products;
  final bool isLoading;
  final bool hasError;
  final String errorMessage;
  final VoidCallback? onSeeAllPressed;
  final VoidCallback? onRetryPressed;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            // Section header
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  if (onSeeAllPressed != null)
                    TextButton(
                      onPressed: onSeeAllPressed,
                      child: const Row(
                        children: [
                          Text(
                            'See All',
                            style: TextStyle(color: Colors.orange),
                          ),
                          Icon(
                            Icons.chevron_right,
                            color: Colors.orange,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Content based on state
            _buildContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return SizedBox(
        height: height,
        child: const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    if (hasError) {
      return SizedBox(
        height: height,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                errorMessage,
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              if (onRetryPressed != null)
                TextButton(
                  onPressed: onRetryPressed,
                  child: const Text(
                    'Retry',
                    style: TextStyle(color: AppColors.primary),
                  ),
                ),
            ],
          ),
        ),
      );
    }

    if (products.isEmpty) {
      return SizedBox(
        height: height,
        child: Center(
          child: Text(
            'No products available',
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
          ),
        ),
      );
    }

    return SizedBox(
      height: height,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        padding: const EdgeInsets.only(left: 16.0),
        itemBuilder: (BuildContext context, int index) {
          final ApiProduct product = products[index];
          return ApiProductCard(product: product);
        },
      ),
    );
  }
}
