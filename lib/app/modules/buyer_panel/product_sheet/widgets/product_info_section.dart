import 'package:cartify/app/core/index.dart';
import 'package:flutter/material.dart';

class ProductInfoSection extends StatelessWidget {
  final Product product;
  final VoidCallback onAddToCart;
  final VoidCallback onRemoveFromCart;

  const ProductInfoSection({
    super.key,
    required this.product,
    required this.onAddToCart,
    required this.onRemoveFromCart,
  });

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
    return const Text(
      'Delivery in 15-30 mins',
      style: TextStyle(
        color: Colors.grey,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildProductName() {
    return Text(
      product.name,
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildProductDescription() {
    return Text(
      product.description,
      style: const TextStyle(color: Colors.grey, fontSize: 14, height: 1.4),
    );
  }

  Widget _buildWeightAndDiscount() {
    return Row(
      children: [
        Text(
          product.volume,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
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
        Text(
          '₹${product.priceINR}',
          style: const TextStyle(
            decoration: TextDecoration.lineThrough,
            color: Colors.grey,
            fontSize: 16,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            '${product.offerPercentage}% OFF',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceAndAddButton() {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '₹${product.offerPrice}',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Text(
              'SHOP FOR ₹199',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
        const Spacer(),
        SizedBox(
          width: 120,
          height: 50,
          child: ElevatedButton(
            onPressed: onAddToCart,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'ADD',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
