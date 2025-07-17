import 'package:bevco/app/core/constants/app_images.dart';
import 'package:bevco/app/modules/product_sheet/views/product_sheet_view.dart';
import 'package:flutter/material.dart';

/// The main widget that includes the title and the horizontal list.
class HotDealsSection extends StatelessWidget {
  const HotDealsSection({super.key});

  @override
  Widget build(BuildContext context) {
    // A list of mock data to populate the cards.
    // In a real app, this would come from a model.
    final List<Map<String, dynamic>> mockProducts = [
      {
        'id': 'onion_01',
        'imageUrl': AppImages.product1,
        'name': 'Onion (Savala)',
        'weight': '1 kg',
        'offerPercentage': 20,
        'originalPrice': 35.0,
        'discountedPrice': 32.0,
      },
      {
        'id': 'lays_01',
        'imageUrl': AppImages.product2,
        'name': "Lay's Hot & Sweet Chilli Potato Chips",
        'weight': '67 g',
        'rating': 4.6,
        'reviewCount': '12.2k',
        'offerPercentage': 3,
        'originalPrice': 30.0,
        'discountedPrice': 29.0,
      },
      {
        'id': 'tomato_01',
        'imageUrl': AppImages.product3,
        'name': 'Indian Tomato (Nadan Thakkali)',
        'weight': '500 g',
        'offerPercentage': 20,
        'originalPrice': 29.0,
        'discountedPrice': 23.0,
      },
    ];

    return SliverToBoxAdapter(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Hot deals',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // TODO: Implement navigation to "See All" screen
                    },
                    child: const Row(
                      children: [
                        Text('See All', style: TextStyle(color: Colors.orange)),
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

            // Horizontal List
            SizedBox(
              height: 300, // Fixed height for the horizontal list container
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: mockProducts.length,
                padding: const EdgeInsets.only(left: 16.0),
                itemBuilder: (context, index) {
                  final product = mockProducts[index];
                  return ProductCard(product: product);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The individual product card UI, converted to a stateful widget.
class ProductCard extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductCard({super.key, required this.product});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  int _quantity = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showProductSheet(context),
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with Add Button
            Stack(
              children: [
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.grey.shade300, width: 1),
                    image: DecorationImage(
                      image: AssetImage(widget.product['imageUrl'] as String),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: _quantity == 0
                      ? _buildAddButton()
                      : _buildQuantitySelector(),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Product Details
            const Text(
              '13 MINS',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(
              widget.product['name'] as String,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 4),
            if (widget.product['rating'] != null)
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.green, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '${widget.product['rating']} (${widget.product['reviewCount']})',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            const SizedBox(height: 8),

            // Pricing
            Row(
              children: [
                Text(
                  '${widget.product['offerPercentage']}% OFF',
                  style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                Text(
                  '₹${(widget.product['originalPrice'] as double).toStringAsFixed(0)}',
                  style: const TextStyle(
                    decoration: TextDecoration.lineThrough,
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '₹${(widget.product['discountedPrice'] as double).toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // The green plus button.
  Widget _buildAddButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _quantity = 1;
        });
        // TODO: Add to cart logic
        print('Add ${widget.product['name']} to cart');
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // The [- 1 +] quantity selector widget.
  Widget _buildQuantitySelector() {
    return Container(
      height: 30,
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          IconButton(
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.remove, color: Colors.white, size: 16),
            onPressed: () {
              setState(() {
                if (_quantity > 0) {
                  _quantity--;
                }
              });
              // TODO: Update cart logic
            },
          ),
          Text(
            '$_quantity',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.add, color: Colors.white, size: 16),
            onPressed: () {
              setState(() {
                _quantity++;
              });
              // TODO: Update cart logic
            },
          ),
        ],
      ),
    );
  }
}
