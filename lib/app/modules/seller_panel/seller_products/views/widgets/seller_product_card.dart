import 'package:cartify/app/core/models/product/product_model.dart';
import 'package:flutter/material.dart';

class SellerProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onToggleStatus;

  const SellerProductCard({
    Key? key,
    required this.product,
    this.onEdit,
    this.onDelete,
    this.onToggleStatus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Name
            Text(
              product.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            // Price
            Text(
              '₹${product.price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 8),
            // Stock - Fixed: Use stockQuantity
            Text(
              'Stock: ${product.stockQuantity}',
              style: TextStyle(
                fontSize: 14,
                color: _getStockColor(),
              ),
            ),
            const SizedBox(height: 16),
            // Action Buttons
            Row(
              children: [
                if (onEdit != null)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onEdit,
                      child: const Text('Edit'),
                    ),
                  ),
                const SizedBox(width: 8),
                if (onToggleStatus != null)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onToggleStatus,
                      child: Text(product.isActive ? 'Deactivate' : 'Activate'),  // Fixed: Use isActive
                    ),
                  ),
                const SizedBox(width: 8),
                if (onDelete != null)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onDelete,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text('Delete'),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStockColor() {
    final stock = product.stockQuantity;  // Fixed: Use stockQuantity
    if (stock == 0) return Colors.red;
    if (stock < 10) return Colors.orange;
    return Colors.green;
  }
}