import 'package:cartify/app/core/models/product/product_model.dart';
import 'package:cartify/app/core/widgets/app_image.dart';
import 'package:cartify/app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class SellerProductCard extends StatefulWidget {
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
  State<SellerProductCard> createState() => _SellerProductCardState();
}

class _SellerProductCardState extends State<SellerProductCard>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isActive = widget.product.isActive ?? true;
    final isLowStock = widget.product.stockQuantity < 10;
    final isOutOfStock = widget.product.stockQuantity == 0;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isActive ? Colors.transparent : Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: Column(
          children: [
            // Header Section with Image and Basic Info (Always visible)
            InkWell(
              onTap: _toggleExpansion,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Image
                    _buildProductImage(),

                    const SizedBox(width: 16),

                    // Product Details
                    Expanded(child: _buildProductDetails()),

                    // Status and Actions
                    // _buildActionsColumn(isActive),

                    // Expand/Collapse Icon
                    const SizedBox(width: 8),
                    AnimatedRotation(
                      turns: _isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 300),
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey[600],
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Expandable Content
            SizeTransition(
              sizeFactor: _expandAnimation,
              child: Column(
                children: [
                  _buildActionsColumn(isActive),

                  // Additional Info Section
                  _buildAdditionalInfo(isLowStock, isOutOfStock),

                  // Tags Section (if available)
                  if (widget.product.tags?.isNotEmpty == true)
                    _buildTagsSection(),

                  // Discount Section (if available)
                  if (widget.product.discounts?.isNotEmpty == true)
                    _buildDiscountSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: AppImage.network(
          url: widget.product.images?.isNotEmpty == true
              ? widget.product.images!.first
              : '',
          width: 60,
          height: 60,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildProductDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product Name
        Text(
          widget.product.name,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),

        // Category
        if (widget.product.category != null)
          Text(
            widget.product.category!.name,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),

        // Price
        Row(
          children: [
            Text(
              '₹${widget.product.price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            // if (widget.product.discounts?.isNotEmpty == true)
            //   Container(
            //     margin: const EdgeInsets.only(left: 8),
            //     padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            //     decoration: BoxDecoration(
            //       color: Colors.red,
            //       borderRadius: BorderRadius.circular(4),
            //     ),
            //     child: Text(
            //       '${_getDiscountPercentage()}% OFF',
            //       style: const TextStyle(
            //         fontSize: 10,
            //         color: Colors.white,
            //         fontWeight: FontWeight.bold,
            //       ),
            //     ),
            //   ),
          ],
        ),

        // Product ID (for reference)
        Text(
          'ID: ${widget.product.id.substring(0, 8)}...',
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey[500],
            fontFamily: 'monospace',
          ),
        ),
      ],
    );
  }

  Widget _buildActionsColumn(bool isActive) {
    return
    // Action Buttons Row
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Product Options',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          Container(
            decoration: BoxDecoration(
              color: isActive ? Colors.green[50] : Colors.grey[100],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isActive ? Colors.green[300]! : Colors.grey[300]!,
              ),
            ),
            child: Switch(
              value: isActive,
              onChanged: widget.onToggleStatus != null
                  ? (_) => widget.onToggleStatus!()
                  : null,
              activeColor: Colors.green,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
          const SizedBox(width: 8),
          // Edit Button
          if (widget.onEdit != null)
            Container(
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                onPressed: widget.onEdit,
                icon: const Icon(Icons.edit_outlined),
                color: Colors.blue[700],
                iconSize: 20,
                padding: const EdgeInsets.all(8),
                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                tooltip: 'Edit Product',
              ),
            ),

          const SizedBox(width: 8),

          // Delete Button
          if (widget.onDelete != null)
            Container(
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                onPressed: widget.onDelete,
                icon: const Icon(Icons.delete_outline),
                color: Colors.red[700],
                iconSize: 20,
                padding: const EdgeInsets.all(8),
                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                tooltip: 'Delete Product',
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAdditionalInfo(bool isLowStock, bool isOutOfStock) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          // Stock Information
          Expanded(
            child: _buildInfoItem(
              icon: Icons.inventory_2_outlined,
              label: 'Stock',
              value: '${widget.product.stockQuantity}',
              valueColor: _getStockColor(),
              badge: isOutOfStock
                  ? 'OUT OF STOCK'
                  : isLowStock
                  ? 'LOW STOCK'
                  : null,
              badgeColor: isOutOfStock ? Colors.red : Colors.orange,
            ),
          ),

          // Measurements (if available)
          if (widget.product.measureAmount != null &&
              widget.product.measureUnitCode != null)
            Expanded(
              child: _buildInfoItem(
                icon: Icons.straighten,
                label: 'Measure',
                value:
                    '${widget.product.measureAmount} ${widget.product.measureUnitCode?.toUpperCase()}',
                valueColor: Colors.grey[700]!,
              ),
            ),

          // Status
          Expanded(
            child: _buildInfoItem(
              icon: widget.product.isActive == true
                  ? Icons.visibility
                  : Icons.visibility_off,
              label: 'Status',
              value: widget.product.isActive == true ? 'Active' : 'Inactive',
              valueColor: widget.product.isActive == true
                  ? Colors.green
                  : Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
    required Color valueColor,
    String? badge,
    Color? badgeColor,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: Colors.grey[600]),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
          textAlign: TextAlign.center,
        ),
        if (badge != null)
          Container(
            margin: const EdgeInsets.only(top: 4),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: badgeColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              badge,
              style: const TextStyle(
                fontSize: 8,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTagsSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.local_offer_outlined,
                size: 16,
                color: Colors.grey[600],
              ),
              const SizedBox(width: 4),
              Text(
                'Tags',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: widget.product.tags!.map((tag) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                ),
                child: Text(
                  tag.name,
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDiscountSection() {
    final discount = widget.product.discounts!.first;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.red[50],
        border: Border(top: BorderSide(color: Colors.red[100]!)),
      ),
      child: Row(
        children: [
          Icon(Icons.local_offer, size: 16, color: Colors.red[700]),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Active Discount',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.red[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (discount.discountAmount != null)
                  Text(
                    'Save ₹${discount.discountAmount!.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 11, color: Colors.red[600]),
                  ),
                if (discount.discountPercent != null)
                  Text(
                    '${discount.discountPercent!.toStringAsFixed(1)}% OFF',
                    style: TextStyle(fontSize: 11, color: Colors.red[600]),
                  ),
              ],
            ),
          ),
          if (discount.validUpto != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Valid Until',
                  style: TextStyle(fontSize: 10, color: Colors.red[600]),
                ),
                Text(
                  _formatDate(discount.validUpto!),
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.red[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  // Helper Methods
  Color _getStockColor() {
    final stock = widget.product.stockQuantity;
    if (stock == 0) return Colors.red;
    if (stock < 10) return Colors.orange;
    return Colors.green;
  }

  double _getDiscountPercentage() {
    if (widget.product.discounts?.isNotEmpty == true) {
      final discount = widget.product.discounts!.first;
      if (discount.discountPercent != null) {
        return discount.discountPercent!;
      }
      if (discount.discountAmount != null) {
        return (discount.discountAmount! / widget.product.price) * 100;
      }
    }
    return 0.0;
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
