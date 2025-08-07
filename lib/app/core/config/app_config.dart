import 'app_identity.dart';

// Application configuration that automatically updates based on AppIdentity
class AppConfig {
  // 🌐 API Configuration
  static String get baseUrl => AppIdentity.baseUrl;
  static String get apiUrl => AppIdentity.apiUrl;
  static const Duration apiTimeout = Duration(seconds: 30);

  // 💾 Storage Configuration
  static String get storageKey => '${AppIdentity.packageName}_storage';
  static String get cartStorageKey => '${AppIdentity.packageName}_cart_items';
  static String get themeStorageKey => '${AppIdentity.packageName}_theme_mode';
  static String get userSessionKey => '${AppIdentity.packageName}_user_session';
  static String get userProfileKey => '${AppIdentity.packageName}_user_profile';
  static String get loginStatusKey => '${AppIdentity.packageName}_login_status';
  static String get userRoleKey => '${AppIdentity.packageName}_user_role';
  static String get onboardingStatusKey => '${AppIdentity.packageName}_onboarding_status';
  static String get preferencesKey => '${AppIdentity.packageName}_preferences';
}



