// Central configuration for app identity and naming
// This is the ONLY file you need to change for project renaming!

class AppIdentity {
  // 🎯 Primary Configuration (Change these for renaming)
  static const String packageName = 'cartify';
  static const String displayName = 'Cartify';
  static const String companyDomain = 'example';

  // 🏢 Company Information (Auto-generated from package name and domain)
  static String get companyName => '$displayName Inc.';
  static String get supportEmail => 'support@$packageName.com';
  static String get socialHandle =>
      packageName; // Used for @packageName on social media

  // 🔧 Auto-generated identifiers (Don't change these)
  static String get bundleId => 'com.$companyDomain.$packageName';
  static String get applicationId => bundleId;
  static String get namespace => bundleId;

  // 📱 App metadata
  static const String version = '1.0.0';
  static const String buildNumber = '1';
  static const String description =
      'A production-ready ecommerce Flutter application';

  // 🌐 URLs and endpoints (Auto-generated)
  static String get baseUrl => 'https://$packageName.$companyDomain.com';
  static String get apiUrl => '$baseUrl/api';
  static String get webBaseUrl => 'https://$packageName.com';
  static String get privacyPolicyUrl => '$webBaseUrl/privacy';
  static String get termsOfServiceUrl => '$webBaseUrl/terms';

  // 📱 App Store URLs (Auto-generated)
  static String get playStoreUrl =>
      'https://play.google.com/store/apps/details?id=$bundleId';
  static String get appStoreUrl =>
      'https://apps.apple.com/app/$packageName/id123456789';

  // 🔗 Social Media URLs (Auto-generated)
  static String get facebookUrl => 'https://facebook.com/$socialHandle';
  static String get twitterUrl => 'https://twitter.com/$socialHandle';
  static String get instagramUrl => 'https://instagram.com/$socialHandle';

  // 🔗 Deep Links (Auto-generated)
  static String get deepLinkScheme => packageName;

  // 🎨 Branding
  static const String slogan = 'Shop Smart, Shop Easy';
  static String get copyright => '© 2025 $displayName. All rights reserved.';

  // 🔍 Debug information
  static Map<String, String> get debugInfo => {
    'packageName': packageName,
    'displayName': displayName,
    'bundleId': bundleId,
    'version': version,
    'buildNumber': buildNumber,
    'companyName': companyName,
    'webBaseUrl': webBaseUrl,
  };
}


