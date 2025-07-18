import 'app_identity.dart';

// Application configuration that automatically updates based on AppIdentity
class AppConfig {
  // 🎯 Identity (Auto-sourced from AppIdentity)
  static String get packageName => AppIdentity.packageName;
  static String get displayName => AppIdentity.displayName;
  static String get bundleId => AppIdentity.bundleId;
  static String get version => AppIdentity.version;

  // 🌐 API Configuration
  static String get baseUrl => AppIdentity.baseUrl;
  static String get apiUrl => AppIdentity.apiUrl;
  static const Duration apiTimeout = Duration(seconds: 30);

  // 💾 Storage Configuration
  static String get storageKey => '${AppIdentity.packageName}_storage';
  static String get cartStorageKey => '${AppIdentity.packageName}_cart_items';
  static String get themeStorageKey => '${AppIdentity.packageName}_theme_mode';
  static String get userSessionKey => '${AppIdentity.packageName}_user_session';
  static String get loginStatusKey => '${AppIdentity.packageName}_login_status';
  static String get userRoleKey => '${AppIdentity.packageName}_user_role';
  static String get onboardingStatusKey =>
      '${AppIdentity.packageName}_onboarding_status';
  static String get preferencesKey => '${AppIdentity.packageName}_preferences';

  // 🎨 UI Configuration
  static const bool enableDarkMode = true;
  static const bool enableAnimations = true;
  static const Duration animationDuration = Duration(milliseconds: 300);

  // 🔧 Feature Flags
  static const bool enableLogging = true;
  static const bool enableCrashReporting = false;
  static const bool enableAnalytics = false;

  // 🔍 Debug Configuration
  static const bool isDebugMode = true; // Will be false in release
  static Map<String, dynamic> get debugInfo => {
    ...AppIdentity.debugInfo,
    'storageKey': storageKey,
    'apiUrl': apiUrl,
    'features': {
      'darkMode': enableDarkMode,
      'animations': enableAnimations,
      'logging': enableLogging,
    },
  };
}
