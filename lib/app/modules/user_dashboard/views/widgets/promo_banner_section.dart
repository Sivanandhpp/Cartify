import 'package:bevco/app/core/constants/app_images.dart';
import 'package:flutter/material.dart';

class PromoBannerSection extends StatelessWidget {
  const PromoBannerSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: const DecorationImage(
            // Using a placeholder gradient. Replace with your actual asset.
            image: AssetImage(AppImages.onboarding1),
            fit: BoxFit.cover,
          ),
        ),
        child: const Text(
          'LOWEST PRICES EVER!',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w900,
            letterSpacing: 2.0,
          ),
        ),
      ),
    );
  }
}
