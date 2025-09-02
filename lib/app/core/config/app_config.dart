// Application Configuration
// This file contains all the configurable settings for the Cartify application.
// It includes API endpoints, feature flags, pagination settings, and other
// app-wide configuration values that might change between environments or builds.

import 'package:cartify/app/core/index.dart';

class AppConfig {
  AppConfig._();

  // ===== API CONFIGURATION =====

  /// Base URL for the API server
  /// Change this based on your environment (development, staging, production)
  // API URL for local
  // static const String baseUrl = 'http://192.168.137.1:3000';
  // API URL for emulators
  // static const String baseUrl = 'http://10.0.2.2:3000';
  // API URL for public
  static const String baseUrl = 'http://192.168.185.91:3000';

  /// API request timeout duration in milliseconds
  static const int requestTimeout = 60000; // 60 seconds

  /// API connection timeout duration in milliseconds
  static const int connectionTimeout = 30000; // 30 seconds

  /// Maximum number of retry attempts for failed requests
  static const int maxRetryAttempts = 3;

  // ===== FEATURE FLAGS =====

  /// Enable/disable dark mode support
  static const bool enableDarkMode = true;

  /// Enable/disable push notifications
  static const bool enablePushNotifications = true;

  /// Enable/disable biometric authentication
  static const bool enableBiometricAuth = true;

  /// Enable/disable analytics tracking
  static const bool enableAnalytics = false;

  /// Enable/disable crash reporting
  static const bool enableCrashReporting = false;

  /// Enable/disable debug logs in production
  static const bool enableDebugLogs = true;

  // ===== PAGINATION & LIMITS =====

  /// Default number of items per page for lists
  static const int defaultPageSize = 20;

  /// Maximum number of items that can be loaded per page
  static const int maxPageSize = 100;

  /// Maximum number of items allowed in cart
  static const int maxCartItems = 50;

  /// Maximum number of addresses per user
  static const int maxAddressesPerUser = 5;

  /// Maximum number of wishlist items per user
  static const int maxWishlistItems = 100;

  // ===== FILE UPLOAD CONFIGURATION =====

  /// Maximum file size for profile images (in MB)
  static const int maxProfileImageSize = 5;

  /// Maximum file size for product images (in MB)
  static const int maxProductImageSize = 10;

  /// Allowed image formats for upload
  static const List<String> allowedImageFormats = [
    'jpg',
    'jpeg',
    'png',
    'webp',
  ];

  // ===== SEARCH CONFIGURATION =====

  /// Minimum characters required for search
  static const int minSearchLength = 2;

  /// Maximum number of search suggestions
  static const int maxSearchSuggestions = 10;

  /// Search debounce delay (in milliseconds)
  static const int searchDebounceDelay = 500;

  // ===== OTP CONFIGURATION =====

  /// OTP expiry time (in minutes)
  static const int otpExpiryMinutes = 5;

  /// Maximum OTP resend attempts
  static const int maxOtpResendAttempts = 3;

  /// OTP resend cooldown (in seconds)
  static const int otpResendCooldown = 60;

  // ===== VALIDATION RULES =====

  /// Minimum password length
  static const int minPasswordLength = 6;

  /// Maximum password length
  static const int maxPasswordLength = 50;

  /// Minimum username length
  static const int minUsernameLength = 3;

  /// Maximum username length
  static const int maxUsernameLength = 20;

  /// Phone number length (Indian format)
  static const int phoneNumberLength = 10;

  // ===== UI CONFIGURATION =====

  /// Default animation duration (in milliseconds)
  static const int defaultAnimationDuration = 300;

  /// Maximum number of banner images in carousel
  static const int maxBannerImages = 10;

  // ===== CURRENCY & PRICING =====

  /// Default currency symbol
  static const String currencySymbol = '₹';

  /// Currency code (ISO 4217)
  static const String currencyCode = 'INR';

  /// Minimum order amount for free delivery
  static const double freeDeliveryThreshold = 500.0;

  /// Default delivery charges
  static const double defaultDeliveryCharges = 50.0;

  // ===== ENVIRONMENT HELPERS =====

  /// Check if app is running in debug mode
  static bool get isDebugMode {
    bool inDebugMode = false;
    assert(inDebugMode = true);
    return inDebugMode;
  }

  /// Check if app is running in release mode
  static bool get isReleaseMode => !isDebugMode;

  /// Get API base URL with version
  static String get apiBaseUrl => '$baseUrl/v1';

  /// Get complete image upload endpoint
  static String get imageUploadUrl => '$apiBaseUrl/upload/image';

  /// Get complete file upload endpoint
  static String get fileUploadUrl => '$apiBaseUrl/upload/file';

  // 💾 Storage Configuration
  static String get storageKey => '${AppIdentity.packageName}_storage';
  static String get themeStorageKey => '${AppIdentity.packageName}_theme_mode';
  static String get userProfileKey => '${AppIdentity.packageName}_user_profile';
  static String get loginStatusKey => '${AppIdentity.packageName}_login_status';
  static String get onboardingStatusKey =>
      '${AppIdentity.packageName}_onboarding_status';
}
