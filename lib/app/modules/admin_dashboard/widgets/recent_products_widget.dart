import 'package:flutter/material.dart';

class RecentProductsWidget<T> extends StatelessWidget {
  final String title;
  final List<T> products;
  final bool isLoading;
  final bool hasError;
  final String errorMessage;
  final String Function(T) getName;
  final String Function(T) getBrand;
  final String Function(T) getCategory;
  final double Function(T) getPrice;
  final int Function(T) getStockQuantity;
  final String? Function(T)? getImageUrl;
  final VoidCallback onSeeAllPressed;
  final VoidCallback? onRetryPressed;
  final Function(T)? onProductTap;
  final int maxItems;

  const RecentProductsWidget({
    super.key,
    this.title = 'Recent Products',
    required this.products,
    this.isLoading = false,
    this.hasError = false,
    this.errorMessage = '',
    required this.getName,
    required this.getBrand,
    required this.getCategory,
    required this.getPrice,
    required this.getStockQuantity,
    this.getImageUrl,
    required this.onSeeAllPressed,
    this.onRetryPressed,
    this.onProductTap,
    this.maxItems = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            TextButton(
              onPressed: onSeeAllPressed,
              child: const Text(
                'View All',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                spreadRadius: 0,
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: _buildContent(),
        ),
      ],
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return Container(
        height: 120,
        child: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
        ),
      );
    }

    if (hasError) {
      return Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red.shade400, size: 48),
            const SizedBox(height: 16),
            Text(
              errorMessage.isNotEmpty
                  ? errorMessage
                  : 'Failed to load products',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
            if (onRetryPressed != null) ...[
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: onRetryPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Retry'),
              ),
            ],
          ],
        ),
      );
    }

    if (products.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(
              Icons.inventory_2_outlined,
              color: Colors.grey.shade400,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              'No products found',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    final displayProducts = products.take(maxItems).toList();

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: displayProducts.length,
      separatorBuilder: (context, index) =>
          Divider(color: Colors.grey.shade200, height: 1),
      itemBuilder: (context, index) {
        final product = displayProducts[index];
        return _buildProductItem(product);
      },
    );
  }

  Widget _buildProductItem(T product) {
    final imageUrl = getImageUrl?.call(product);
    final stockQuantity = getStockQuantity(product);

    return ListTile(
      contentPadding: const EdgeInsets.all(16),
      onTap: onProductTap != null ? () => onProductTap!(product) : null,
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: imageUrl != null && imageUrl.isNotEmpty
            ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.image_rounded, color: Colors.grey),
                ),
              )
            : const Icon(Icons.image_rounded, color: Colors.grey),
      ),
      title: Text(
        getName(product),
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
      ),
      subtitle: Text(
        '${getBrand(product)} • ${getCategory(product)}',
        style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '\$${getPrice(product).toStringAsFixed(2)}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: stockQuantity > 10
                  ? Colors.green.withOpacity(0.1)
                  : Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Stock: $stockQuantity',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: stockQuantity > 10
                    ? Colors.green.shade700
                    : Colors.orange.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
