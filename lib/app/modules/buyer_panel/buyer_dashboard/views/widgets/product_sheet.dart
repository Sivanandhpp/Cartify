import 'dart:ui';
import 'package:cartify/app/core/index.dart';
import 'package:cartify/app/modules/buyer_panel/buyer_dashboard/controllers/product_sheet_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductBottomSheet extends StatelessWidget {
  final ProductModel product;
  final ProductSheetController controller = Get.put(ProductSheetController());

  ProductBottomSheet({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.75,
      maxChildSize: 1.0,
      expand: false,
      builder: (context, scrollController) {
        _setupScrollListener(scrollController);
        return _buildSheetContainer(scrollController);
      },
    );
  }

  void _setupScrollListener(ScrollController scrollController) {
    scrollController.addListener(() {
      controller.onScrollUpdate(scrollController.offset);
    });
  }

  Widget _buildSheetContainer(ScrollController scrollController) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      child: Stack(children: [_buildContent(scrollController), _buildHeader()]),
    );
  }

  Widget _buildContent(ScrollController scrollController) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            controller: scrollController,
            children: [
              _buildImageCarousel(),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProductInfo(),
                    if (controller.hasDescription(product)) _buildDescription(),
                    if (controller.hasAttributes(product))
                      _buildSpecifications(),
                    _buildStockInfo(),
                    _buildReviewsSection(),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
        ),
        _buildActionButtons(),
      ],
    );
  }

  Widget _buildHeader() {
    return Obx(
      () => Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(
          vertical: controller.isExpanded.value ? 40 : 12,
          horizontal: 12,
        ),
        child: Row(
          children: [
            _buildGlassButton(
              icon: Icons.keyboard_arrow_down,
              iconColor: Colors.black,
              onTap: controller.closeSheet,
            ),
            const Spacer(),
            _buildGlassButton(
              icon: Icons.favorite_border,
              iconColor: Colors.red,
              onTap: () => controller.onToggleWishlist(product),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGlassButton({
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1.5,
              ),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
        ),
      ),
    );
  }

  Widget _buildImageCarousel() {
    return Column(
      children: [
        Container(
          height: 400,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: _buildPageView(),
        ),
        if (controller.hasMultipleImages(product)) ...[
          const SizedBox(height: 12),
          _buildImageIndicators(),
        ],
      ],
    );
  }

  Widget _buildPageView() {
    return PageView.builder(
      controller: controller.pageController,
      onPageChanged: controller.onPageChanged,
      itemCount: product.images.length,
      itemBuilder: (context, index) => AppImage.network(
        url: product.images[index],
        width: double.infinity,
        height: 400,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildImageIndicators() {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          product.images.length,
          (index) => Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: controller.currentImageIndex.value == index
                  ? Colors.blue
                  : Colors.grey[300],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.name,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        if (controller.hasBrandOrCategory(product)) _buildBrandCategory(),
        const SizedBox(height: 12),
        _buildPricing(),
        if (product.displayMeasure.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            product.displayMeasure,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ],
        if (controller.hasRating(product)) _buildRating(),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildBrandCategory() {
    final brand = product.brand?.isNotEmpty == true
        ? 'Brand: ${product.brand}'
        : null;
    final category = product.category?.name?.isNotEmpty == true
        ? 'Category: ${product.category!.name}'
        : null;

    return Row(
      children: [
        if (brand != null)
          Text(brand, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
        if (brand != null && category != null)
          Text(' • ', style: TextStyle(color: Colors.grey[600])),
        if (category != null)
          Text(
            category,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
      ],
    );
  }

  Widget _buildPricing() {
    if (controller.hasOffer(product)) {
      return Row(
        children: [
          Text(
            product.displayEffectivePrice,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.green,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            product.displayOriginalPrice,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
              decoration: TextDecoration.lineThrough,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '${product.discountPercentage.toStringAsFixed(0)}% OFF',
              style: TextStyle(
                fontSize: 12,
                color: Colors.green[700],
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      );
    }
    return Text(
      product.displayPrice,
      style: const TextStyle(
        fontSize: 20,
        color: Colors.green,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildRating() {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Row(
            children: List.generate(
              5,
              (index) => Icon(
                Icons.star,
                size: 16,
                color: index < product.averageRating.floor()
                    ? Colors.amber
                    : Colors.grey[300],
              ),
            ),
          ),
          const SizedBox(width: 4),
          Text(
            '${product.averageRating.toStringAsFixed(1)}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Description',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Text(
          product.description!,
          style: TextStyle(fontSize: 16, color: Colors.grey[600], height: 1.5),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildSpecifications() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Specifications',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Text(
          '• Alcohol Content: ${product.alcoholContent}%',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildStockInfo() {
    final isInStock = controller.isInStock(product);
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: (isInStock ? Colors.green : Colors.red).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            isInStock ? Icons.check_circle_outline : Icons.cancel_outlined,
            color: isInStock ? Colors.green[700] : Colors.red[700],
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            isInStock
                ? 'In Stock (${product.stockQuantity} available)'
                : 'Out of Stock',
            style: TextStyle(
              fontSize: 14,
              color: isInStock ? Colors.green[700] : Colors.red[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsSection() {
    const sampleReviews = [
      {
        'user': 'User 1',
        'rating': 4,
        'comment': 'Great product! Really satisfied with the quality.',
      },
      {
        'user': 'User 2',
        'rating': 5,
        'comment': 'Excellent value for money. Highly recommended!',
      },
      {
        'user': 'User 3',
        'rating': 4,
        'comment': 'Good quality product. Fast delivery.',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Reviews',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        ...sampleReviews.map(
          (review) => _buildReviewCard(
            user: review['user'] as String,
            rating: review['rating'] as int,
            comment: review['comment'] as String,
          ),
        ),
      ],
    );
  }

  Widget _buildReviewCard({
    required String user,
    required int rating,
    required String comment,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(user, style: const TextStyle(fontWeight: FontWeight.w600)),
                const Spacer(),
                Row(
                  children: List.generate(
                    5,
                    (starIndex) => Icon(
                      Icons.star,
                      size: 16,
                      color: starIndex < rating
                          ? Colors.amber
                          : Colors.grey[300],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(comment, style: TextStyle(color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    final isInStock = controller.isInStock(product);

    if (!isInStock) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: const Center(
          child: Text(
            'Out of Stock',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      height: 90,
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 24, top: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => controller.onAddToCart(product),

              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Text(
                'Add to cart',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: AppButton(
              height: 50,
              text: 'Buy Now',
              onPressed: () => controller.onBuyNow(product),
            ),
          ),
          // Expanded(
          //   child: ElevatedButton(
          //     onPressed: () => controller.onBuyNow(product),
          //     style: ElevatedButton.styleFrom(
          //       padding: const EdgeInsets.symmetric(vertical: 16),
          //     ),
          //     child: const Text('Buy Now'),
          //   ),
          // ),
        ],
      ),
    );
  }
}
