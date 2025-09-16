import 'package:cartify/app/core/models/product/product_model.dart';
import 'package:cartify/app/core/widgets/app_image.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onTap;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;
  final int currentQuantity;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onIncrement,
    this.onDecrement,
    this.currentQuantity = 0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isOutOfStock = product.stockQuantity <= 0;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: isOutOfStock ? null : onTap,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: 180,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImageSection(isOutOfStock, theme),
              _buildDetailsSection(isOutOfStock, theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection(bool isOutOfStock, ThemeData theme) {
    return SizedBox(
      height: 140,
      width: double.infinity,
      child: Stack(
        children: [
          // Product Image
          Container(
            width: double.infinity,
            height: double.infinity,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              color: Colors.grey[100],
            ),
            child: AppImage.network(
              url: product.images.isNotEmpty ? product.images.first : '',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          // Quantity Controls (Top Right)
          if (!isOutOfStock)
            Positioned(top: 8, right: 8, child: _buildQuantityControls(theme)),

          // Discount Badge (Top Left) - Using attributes
          if (product.hasOffer && !isOutOfStock)
            Positioned(top: 8, left: 8, child: _buildDiscountBadge()),

          // Out of Stock Overlay
          if (isOutOfStock)
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
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
    );
  }

  Widget _buildDetailsSection(bool isOutOfStock, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Product Name
          Text(
            product.name,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isOutOfStock ? Colors.grey : Colors.black87,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 2),

          // Brand - Using attributes
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (product.brand != null)
                Text(
                  product.brand!,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w400,
                  ),
                ),
              if (product.averageRating > 0) ...[
                Row(
                  children: [
                    const Icon(Icons.star, size: 14, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      product.averageRating.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),

          // Price Section - Using attributes
          _buildPriceSection(isOutOfStock, theme),
        ],
      ),
    );
  }

  Widget _buildPriceSection(bool isOutOfStock, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // Effective Price (offer price or regular price)
            Text(
              product.displayEffectivePrice,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isOutOfStock
                    ? Colors.grey
                    : product.hasOffer
                    ? Colors.green[700]
                    : theme.primaryColor,
              ),
            ),
            if (product.displayMeasure.isNotEmpty)
              Text(
                " / ${product.displayMeasure}",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
        // Original Price (strikethrough if offer exists)
        if (product.hasOffer && !isOutOfStock)
          Row(
            children: [
              Text(
                product.displayPrice,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'Save ${product.displayOfferPrice}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.green,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        // Discount Percentage
        if (product.hasOffer && !isOutOfStock) ...[
          const SizedBox(height: 2),
          Text(
            '${product.displayOfferPercentage} OFF',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Colors.green[700],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDiscountBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        product.displayOfferPercentage,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildQuantityControls(ThemeData theme) {
    if (currentQuantity == 0) {
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
            child: SizedBox(
              width: 32,
              height: 32,
              child: Icon(Icons.add, size: 18, color: theme.primaryColor),
            ),
          ),
        ),
      );
    }

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
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onDecrement,
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(8),
              ),
              child: SizedBox(
                width: 28,
                height: 32,
                child: Icon(Icons.remove, size: 16, color: theme.primaryColor),
              ),
            ),
          ),
          Container(
            width: 32,
            height: 32,
            color: theme.primaryColor.withOpacity(0.1),
            child: Center(
              child: Text(
                currentQuantity.toString(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: theme.primaryColor,
                ),
              ),
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onIncrement,
              borderRadius: const BorderRadius.horizontal(
                right: Radius.circular(8),
              ),
              child: SizedBox(
                width: 28,
                height: 32,
                child: Icon(Icons.add, size: 16, color: theme.primaryColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
