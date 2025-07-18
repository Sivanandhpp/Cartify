import 'app_identity.dart';

/// Application environment and identity configuration
///
/// This class contains environment-specific configurations and app identity.
class AppEnvironment {
  AppEnvironment._();

  // App Identity (Auto-sourced from AppIdentity)
  static String get displayName => AppIdentity.displayName;
  static String get packageName => AppIdentity.bundleId;
  static const String appDescription = 'Your ultimate shopping companion';

  // Legal Information (Auto-sourced from AppIdentity)
  static String get companyName => AppIdentity.companyName;
  static String get supportEmail => AppIdentity.supportEmail;
  static String get privacyPolicyUrl => AppIdentity.privacyPolicyUrl;
  static String get termsOfServiceUrl => AppIdentity.termsOfServiceUrl;

  // Social Media (Auto-sourced from AppIdentity)
  static String get facebookUrl => AppIdentity.facebookUrl;
  static String get twitterUrl => AppIdentity.twitterUrl;
  static String get instagramUrl => AppIdentity.instagramUrl;

  // App Store Links (Auto-sourced from AppIdentity)
  static String get playStoreUrl => AppIdentity.playStoreUrl;
  static String get appStoreUrl => AppIdentity.appStoreUrl;

  // Deep Links (Auto-sourced from AppIdentity)
  static String get deepLinkScheme => AppIdentity.deepLinkScheme;
  static String get webBaseUrl => AppIdentity.webBaseUrl;

  // Analytics
  static const String mixpanelToken = 'your_mixpanel_token';
  static const String firebaseAnalyticsEnabled = 'true';

  // Push Notifications
  static const String fcmSenderId = '123456789';
  static const String fcmServerKey = 'your_fcm_server_key';

  // Payment Configuration
  static const String stripePublishableKey = 'pk_test_your_stripe_key';
  static const String razorpayKeyId = 'rzp_test_your_razorpay_key';

  // Map Configuration
  static const String googleMapsApiKey = 'your_google_maps_api_key';

  // Feature Flags
  static const bool enableBiometricAuth = true;
  static const bool enableSocialLogin = true;
  static const bool enablePushNotifications = true;
  static const bool enableLocationServices = true;
  static const bool enableCrashReporting = true;
}
