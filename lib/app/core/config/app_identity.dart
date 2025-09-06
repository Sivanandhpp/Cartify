// Application Identity & Branding
//    This file contains all identity-related information for the Cartify application.
//    It includes app metadata, company information, legal links, social media URLs,
//    and other branding elements that define the app's identity. 

class AppIdentity {
  AppIdentity._();

  // ===== APPLICATION IDENTITY =====

  /// Application name
  static const String buildName = 'cartify';
  static const String displayName = 'Cartify';

  /// Application tagline
  static const String appTagline = 'Your Ultimate Shopping Companion';

  /// Application description
  static const String appDescription =
      'Discover, shop, and enjoy seamless e-commerce experience with Cartify. '
      'From electronics to fashion, find everything you need in one place.';

  /// Application version (should match pubspec.yaml)
  static const String appVersion = '1.0.0';

  /// Application build number
  static const String buildNumber = '1';

  /// Application package name/bundle identifier
  static const String packageName = 'com.cartify.app';

  // ===== COMPANY INFORMATION =====

  /// Company/Organization name
  static const String companyName = 'Cartify Technologies';

  /// Company short name
  static const String companyShortName = 'Cartify';

  /// Company description
  static const String companyDescription =
      'Cartify Technologies is dedicated to revolutionizing the e-commerce '
      'experience by providing innovative shopping solutions.';

  /// Company address
  static const String companyAddress =
      '123 Innovation Street, Tech City, TC 12345, India';

  /// Company phone number
  static const String companyPhone = '+91 98765 43210';

  /// Company email
  static const String companyEmail = 'support@cartify.com';

  /// Company website
  static const String companyWebsite = 'https://www.cartify.com';

  /// Company establishment year
  static const String establishedYear = '2024';

  // ===== SOCIAL MEDIA LINKS =====

  /// Facebook page URL
  static const String facebookUrl = 'https://facebook.com/cartify';

  /// Twitter profile URL
  static const String twitterUrl = 'https://twitter.com/cartify';

  /// Instagram profile URL
  static const String instagramUrl = 'https://instagram.com/cartify';

  /// LinkedIn company page URL
  static const String linkedinUrl = 'https://linkedin.com/company/cartify';

  /// YouTube channel URL
  static const String youtubeUrl = 'https://youtube.com/@cartify';

  /// WhatsApp business number
  static const String whatsappNumber = '+919876543210';

  /// Telegram channel URL
  static const String telegramUrl = 'https://t.me/cartify';

  // ===== LEGAL & SUPPORT LINKS =====

  /// Terms of Service URL
  static const String termsOfServiceUrl = 'https://www.cartify.com/terms';

  /// Privacy Policy URL
  static const String privacyPolicyUrl = 'https://www.cartify.com/privacy';

  /// Refund & Return Policy URL
  static const String refundPolicyUrl = 'https://www.cartify.com/refund-policy';

  /// Shipping Policy URL
  static const String shippingPolicyUrl =
      'https://www.cartify.com/shipping-policy';

  /// Cancellation Policy URL
  static const String cancellationPolicyUrl =
      'https://www.cartify.com/cancellation-policy';

  /// FAQ page URL
  static const String faqUrl = 'https://www.cartify.com/faq';

  /// Help & Support URL
  static const String helpUrl = 'https://www.cartify.com/help';

  /// Contact Us URL
  static const String contactUrl = 'https://www.cartify.com/contact';

  /// About Us URL
  static const String aboutUrl = 'https://www.cartify.com/about';

  // ===== APP STORE LINKS =====

  /// Google Play Store URL
  static const String playStoreUrl =
      'https://play.google.com/store/apps/details?id=$packageName';

  /// Apple App Store URL
  static const String appStoreUrl =
      'https://apps.apple.com/app/cartify/id123456789';

  /// App deep link scheme
  static const String appScheme = 'cartify';

  // ===== SUPPORT INFORMATION =====

  /// Customer support email
  static const String supportEmail = 'support@cartify.com';

  /// Customer support phone
  static const String supportPhone = '+91 98765 43210';

  // ===== DEVELOPER INFORMATION =====

  /// Developer name
  static const String developerName = 'Cartify Development Team';

  /// Developer email
  static const String developerEmail = 'dev@cartify.com';

  // ===== COPYRIGHT & LICENSING =====

  /// Copyright notice
  static String get copyrightNotice =>
      '© ${DateTime.now().year} $companyName. All rights reserved.';

  /// License type
  static const String licenseType = 'MIT License';

  /// License URL
  static const String licenseUrl = 'https://www.cartify.com/license';

  // ===== RATING & REVIEW =====

  /// Minimum app usage days before showing rating prompt
  static const int minUsageDaysForRating = 7;

  /// Minimum sessions before showing rating prompt
  static const int minSessionsForRating = 10;
  
}
