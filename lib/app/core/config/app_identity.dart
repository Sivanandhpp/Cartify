/// Central configuration for app identity and naming.
/// This is the ONLY place to change for future app renaming.
class AppIdentity {
  // === CORE IDENTITY (Change these for renaming) ===
  static const String packageName = 'cartify';
  static const String displayName = 'Cartify';
  static const String companyDomain = 'example';
  static const String description = 'A modern e-commerce shopping app';

  // === DERIVED VALUES (Auto-calculated, don't change) ===

  // Package and Bundle IDs
  static const String bundleId = 'com.$companyDomain.$packageName';
  static const String bundleIdTests = '$bundleId.RunnerTests';

  // Web and App Titles
  static const String webTitle = displayName;
  static const String webShortName = packageName;
  static const String appTitle = displayName;

  // API Configuration
  static const String apiBaseUrl = 'https://api.$packageName.com';

  // Platform-specific names
  static const String androidLabel = packageName;
  static const String iosDisplayName = displayName;
  static const String iosBundleName = packageName;

  // Development
  static const String testAppName = '$displayName App';

  // === HELPER METHODS ===

  /// Get package import prefix for absolute imports
  static String get packageImport => 'package:$packageName';

  /// Get bundle ID for specific platform
  static String getBundleId({String? suffix}) {
    if (suffix != null) {
      return '$bundleId.$suffix';
    }
    return bundleId;
  }

  /// Validate configuration (useful for build scripts)
  static bool validate() {
    return packageName.isNotEmpty &&
        displayName.isNotEmpty &&
        companyDomain.isNotEmpty &&
        !packageName.contains(' ') &&
        packageName.toLowerCase() == packageName;
  }
}
