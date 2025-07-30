class ApiEndpoints {
  ApiEndpoints._();

  // Base URL for authentication API
  static const String authBaseUrl = 'http://10.0.2.2:3000';

  // Authentication endpoints
  static const String requestOtp = '$authBaseUrl/auth/request-otp';
  static const String verifyOtp =
      '$authBaseUrl/auth/verify-otp'; // Future endpoints can be added here
  // static const String refreshToken = '$authBaseUrl/auth/refresh-token';
  // static const String logout = '$authBaseUrl/auth/logout';
}
