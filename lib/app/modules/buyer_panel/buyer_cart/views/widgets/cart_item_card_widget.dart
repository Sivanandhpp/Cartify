import 'package:flutter/material.dart';
import '../../../../../core/index.dart';

/// Reusable cart item card widget
class CartItemCardWidget extends StatelessWidget {
  final CartItem item;
  final VoidCallback? onIncrementQuantity;
  final VoidCallback? onDecrementQuantity;
  final int currentQuantity;

  const CartItemCardWidget({
    super.key,
    required this.item,
    this.onIncrementQuantity,
    this.onDecrementQuantity,
    this.currentQuantity = 0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProductImage(),
          _buildProductDetails(theme),
          _buildQuantityControls(theme),
          _buildPriceDetails(theme),
        ],
      ),
    );
  }

  Widget _buildProductImage() {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: item.product.images.isNotEmpty
              ? AppImage.network(
                  url: item.product.images.first,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  borderRadius: BorderRadius.circular(8),
                  errorWidget: Icon(
                    Icons.image_outlined,
                    color: Colors.grey[400],
                    size: 30,
                  ),
                )
              : Icon(Icons.image_outlined, color: Colors.grey[400], size: 30),
        ),
      ),
    );
  }

  Widget _buildProductDetails(ThemeData theme) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            // Ensures wrapping and ellipsis for long names
            width: 120,
            child: Text(
              item.product.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            item.product.displayMeasure,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceDetails(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          item.product.displayEffectivePrice,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        if (item.product.hasOffer)
          Text(
            item.product.displayPrice,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[600],
              decoration: TextDecoration.lineThrough,
            ),
          ),
      ],
    );
  }

  Widget _buildQuantityControls(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
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
      child: currentQuantity == 0
          ? Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onIncrementQuantity,
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 32,
                  height: 32,
                  child: Icon(Icons.add, size: 18, color: theme.primaryColor),
                ),
              ),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onDecrementQuantity,
                    borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(8),
                    ),
                    child: SizedBox(
                      width: 28,
                      height: 32,
                      child: Icon(
                        Icons.remove,
                        size: 16,
                        color: theme.primaryColor,
                      ),
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
                    onTap: onIncrementQuantity,
                    borderRadius: const BorderRadius.horizontal(
                      right: Radius.circular(8),
                    ),
                    child: SizedBox(
                      width: 28,
                      height: 32,
                      child: Icon(
                        Icons.add,
                        size: 16,
                        color: theme.primaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
