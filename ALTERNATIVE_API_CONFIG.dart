class ApiEndpoints {
  ApiEndpoints._();

  // Alternative endpoints for testing
  static const String authBaseUrl =
      'http://192.168.1.100:3000'; // Use your actual IP

  // Or try these alternatives:
  // static const String authBaseUrl = 'http://127.0.0.1:3000';
  // static const String authBaseUrl = 'http://localhost:3000';

  // Authentication endpoints
  static const String requestOtp = '$authBaseUrl/auth/request-otp';
  static const String verifyOtp = '$authBaseUrl/auth/verify-otp';

  // Future endpoints can be added here
  // static const String refreshToken = '$authBaseUrl/auth/refresh-token';
  // static const String logout = '$authBaseUrl/auth/logout';
}
