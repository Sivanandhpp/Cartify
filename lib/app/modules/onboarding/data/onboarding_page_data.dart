class OnboardingPageData {
  final String image;
  final String title;
  final String subtitle;
  const OnboardingPageData({
    required this.image,
    required this.title,
    required this.subtitle,
  });
}

// Hard‑coded sample pages.
const List<OnboardingPageData> kOnboardingPages = [
  OnboardingPageData(
    image: 'assets/images/onboarding1.jpg',
    title: 'Shop Your Favorites',
    subtitle:
        'Discover trending products, curated collections,\nand best deals—all in one place.',
  ),
  OnboardingPageData(
    image: 'assets/images/onboarding1.jpg',
    title: 'Safe & Easy Checkout',
    subtitle:
        'Enjoy secure payments with cards, UPI, or COD.\nYour data stays safe with us.',
  ),
  OnboardingPageData(
    image: 'assets/images/onboarding1.jpg',
    title: 'Fast Delivery, Easy Returns',
    subtitle:
        'Track orders live, get doorstep delivery,\nand return items hassle-free.',
  ),
];




