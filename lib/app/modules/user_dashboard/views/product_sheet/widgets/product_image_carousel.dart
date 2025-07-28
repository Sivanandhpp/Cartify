import 'package:flutter/material.dart';

class ProductImageCarousel extends StatelessWidget {
  final List<String> images;
  final int currentImageIndex;
  final int totalImages;
  final PageController pageController;
  final Function(int) onPageChanged;

  const ProductImageCarousel({
    super.key,
    required this.images,
    required this.currentImageIndex,
    required this.totalImages,
    required this.pageController,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Stack(
        children: [
          // Main product image container
          SizedBox(
            height: 400,
            width: double.infinity,
            child: PageView.builder(
              controller: pageController,
              onPageChanged: onPageChanged,
              itemCount: totalImages,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    image: DecorationImage(
                      image: images[index].startsWith('http')
                          ? NetworkImage(images[index])
                          : AssetImage(images[index]) as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.1),
                          Colors.black.withOpacity(0.3),
                        ],
                      ),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Page indicators
          Positioned(
            bottom: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                '${currentImageIndex + 1}/$totalImages',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
