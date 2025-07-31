class ApiEndpoints {
  ApiEndpoints._();

  // Base URL for API
  // static const String baseUrl = 'http://localhost:3000';
  static const String baseUrl = 'http://10.0.2.2:3000';

  // Authentication endpoints
  static const String requestOtp = '$baseUrl/auth/request-otp';
  static const String verifyOtp = '$baseUrl/auth/verify-otp';

  // User endpoints
  static const String userProfile = '$baseUrl/user/profile';
}
