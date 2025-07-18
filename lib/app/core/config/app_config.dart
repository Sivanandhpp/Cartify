/// Application environment configuration
class AppConfig {
  static const String appName = 'Bevco';
  static const String version = '1.0.0';

  // Environment settings
  static const bool isDebug = true; // Set to false in release
  static const bool enableLogging = true;

  // API Configuration
  static const String baseUrl =
      'https://api.bevco.com'; // Replace with actual API URL
  static const Duration apiTimeout = Duration(seconds: 30);

  // Storage keys
  static const String isLoggedInKey = 'isLoggedIn';
  static const String userRoleKey = 'userRole';
  static const String isOnboardedKey = 'isBoarded';
  static const String userTokenKey = 'userToken';

  // User roles
  static const String adminRole = 'admin';
  static const String userRole = 'user';

  // Default values
  static const int otpLength = 4;
  static const String defaultCountryCode = '+91';

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // UI Configuration
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;

  // Animation durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // Validation patterns
  static const String phonePattern = r'^[6-9]\d{9}$';
  static const String emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';

  // Error messages
  static const String networkErrorMessage =
      'Network error occurred. Please check your connection.';
  static const String serverErrorMessage =
      'Server error occurred. Please try again later.';
  static const String unknownErrorMessage = 'An unexpected error occurred.';
}
