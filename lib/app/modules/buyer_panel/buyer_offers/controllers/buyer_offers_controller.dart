// Core imports (absolute)
import 'package:cartify/app/core/index.dart';
import 'package:get/get.dart';

class BuyerOffersController extends GetxController {
  // Navigation bar visibility control
  final isNavBarVisible = true.obs;
  double _lastScrollOffset = 0.0;

  // Offers data - in production this would come from API
  final List<Map<String, dynamic>> offers = [
    {
      'title': 'First Order Offer',
      'subtitle': 'Get ₹150 off on your first order above ₹500',
      'code': 'FIRST150',
      'discount': '₹150 OFF',
      'validUntil': '31 Dec 2024',
      'minOrder': '₹500',
      'isActive': true,
      'color': AppColors.primary,
    },
    {
      'title': 'Weekend Special',
      'subtitle': 'Flat 20% off on all beverages',
      'code': 'WEEKEND20',
      'discount': '20% OFF',
      'validUntil': '28 Jan 2024',
      'minOrder': '₹200',
      'isActive': true,
      'color': AppColors.lightSecondary,
    },
    {
      'title': 'Free Delivery',
      'subtitle': 'Free delivery on orders above ₹300',
      'code': 'FREEDEL',
      'discount': 'Free Delivery',
      'validUntil': '15 Feb 2024',
      'minOrder': '₹300',
      'isActive': true,
      'color': AppColors.lightSuccess,
    },
    {
      'title': 'Mega Sale',
      'subtitle': 'Up to 50% off on selected items',
      'code': 'MEGA50',
      'discount': 'Up to 50% OFF',
      'validUntil': '10 Jan 2024',
      'minOrder': '₹100',
      'isActive': false,
      'color': AppColors.lightError,
    },
  ];

  // Method to handle scroll changes for nav bar visibility
  void handleScrollUpdate(double offset) {
    const double threshold =
        50.0; // Minimum scroll distance to trigger hide/show

    if (offset > _lastScrollOffset + threshold) {
      // Scrolling down - hide nav bar
      if (isNavBarVisible.value) {
        isNavBarVisible.value = false;
      }
    } else if (offset < _lastScrollOffset - threshold) {
      // Scrolling up - show nav bar
      if (!isNavBarVisible.value) {
        isNavBarVisible.value = true;
      }
    }

    _lastScrollOffset = offset;
  }

  // Copy offer code to clipboard
  void copyOfferCode(String code) {
    LogService.info('Copying offer code: $code');
    // TODO: Implement clipboard functionality
    NotificationService.showSuccess(
      title: 'Code Copied',
      message: 'Offer code $code copied to clipboard',
    );
  }

  // Apply offer
  void applyOffer(Map<String, dynamic> offer) {
    if (!offer['isActive']) {
      NotificationService.showError(
        title: 'Offer Expired',
        message: 'This offer has expired and cannot be used',
      );
      return;
    }

    LogService.info('Applying offer: ${offer['code']}');
    NotificationService.showSuccess(
      title: 'Offer Applied',
      message: 'Offer ${offer['code']} has been applied to your cart',
    );
    // TODO: Apply offer to cart
  }
}
