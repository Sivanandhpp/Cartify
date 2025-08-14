import 'package:cartify/app/core/models/product/product_model.dart';
import 'package:cartify/app/core/widgets/app_image.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onTap;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;
  final int currentQuantity;
  final bool isGridView;
  final double? width;
  final double? height;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onIncrement,
    this.onDecrement,
    this.currentQuantity = 0,
    this.isGridView = false,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isOutOfStock = product.stockQuantity <= 0;

    return Container(
      width: width,
      height: height,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          onTap: isOutOfStock ? null : onTap,
          borderRadius: BorderRadius.circular(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image with Add/Remove Controls
              Expanded(
                flex: isGridView ? 3 : 2,
                child: Stack(
                  children: [
                    // Product Image
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                        color: Colors.grey[100],
                      ),
                      child: AppImages.network(
                        url: product.images.first,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                      ),
                    ),

                    // Quantity Controls (Top Right)
                    if (!isOutOfStock)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: _buildQuantityControls(theme),
                      ),

                    // Out of Stock Overlay
                    if (isOutOfStock)
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              'OUT OF STOCK',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Product Details
              Expanded(
                flex: isGridView ? 2 : 3,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Name
                      Text(
                        product.name,
                        style: TextStyle(
                          fontSize: isGridView ? 12 : 14,
                          fontWeight: FontWeight.w600,
                          color: isOutOfStock ? Colors.grey : Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      // Measure (if available)
                      if (product.displayMeasure.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          product.displayMeasure,
                          style: TextStyle(
                            fontSize: isGridView ? 10 : 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],

                      const SizedBox(height: 4),

                      // Rating (if available)
                      if (product.averageRating > 0) ...[
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              size: isGridView ? 12 : 14,
                              color: Colors.amber,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              product.averageRating.toStringAsFixed(1),
                              style: TextStyle(
                                fontSize: isGridView ? 10 : 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '(${_generateReviewCount()})',
                              style: TextStyle(
                                fontSize: isGridView ? 10 : 12,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                      ],

                      const Spacer(),

                      // Price Section
                      Row(
                        children: [
                          // Current Price
                          Text(
                            '₹${product.displayPrice}',
                            style: TextStyle(
                              fontSize: isGridView ? 14 : 16,
                              fontWeight: FontWeight.bold,
                              color: isOutOfStock
                                  ? Colors.grey
                                  : Colors.green[700],
                            ),
                          ),

                          const SizedBox(width: 8),

                          // Discount Badge (Mock - you can add discount field to ProductModel)
                          if (_hasDiscount()) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red[100],
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '${_getDiscountPercentage()}% OFF',
                                style: TextStyle(
                                  fontSize: isGridView ? 8 : 10,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.red[700],
                                ),
                              ),
                            ),
                          ],
                        ],
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

  Widget _buildQuantityControls(ThemeData theme) {
    if (currentQuantity == 0) {
      // Show just the add button when quantity is 0
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onIncrement,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
              child: Icon(Icons.add, size: 20, color: theme.primaryColor),
            ),
          ),
        ),
      );
    }

    // Show quantity controls when quantity > 0
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Decrement Button
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onDecrement,
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(8),
              ),
              child: Container(
                width: 28,
                height: 32,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(8),
                  ),
                ),
                child: Icon(Icons.remove, size: 16, color: theme.primaryColor),
              ),
            ),
          ),

          // Quantity Display
          Container(
            width: 32,
            height: 32,
            color: theme.primaryColor.withOpacity(0.1),
            child: Center(
              child: Text(
                currentQuantity.toString(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: theme.primaryColor,
                ),
              ),
            ),
          ),

          // Increment Button
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onIncrement,
              borderRadius: const BorderRadius.horizontal(
                right: Radius.circular(8),
              ),
              child: Container(
                width: 28,
                height: 32,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.horizontal(
                    right: Radius.circular(8),
                  ),
                ),
                child: Icon(Icons.add, size: 16, color: theme.primaryColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Mock methods - you can replace these with actual business logic
  bool _hasDiscount() {
    // You can add discount logic here or add discount fields to ProductModel
    return product.price > 100; // Mock condition
  }

  int _getDiscountPercentage() {
    // Mock discount calculation
    if (product.price > 200) return 15;
    if (product.price > 100) return 10;
    return 5;
  }

  int _generateReviewCount() {
    // Mock review count based on rating
    if (product.averageRating >= 4.5)
      return 50 + (product.averageRating * 10).round();
    if (product.averageRating >= 4.0)
      return 25 + (product.averageRating * 8).round();
    if (product.averageRating >= 3.0)
      return 10 + (product.averageRating * 5).round();
    return (product.averageRating * 3).round();
  }
}
