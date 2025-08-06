/// Authentication related models for Cartify
/// These models handle all authentication-related data structures

/// Model for requesting OTP during login
class RequestOtpDto {
  final String phoneNumber;

  const RequestOtpDto({required this.phoneNumber});

  /// Convert to JSON for API requests
  Map<String, dynamic> toJson() {
    return {'phone_number': phoneNumber};
  }

  /// Create from JSON response
  factory RequestOtpDto.fromJson(Map<String, dynamic> json) {
    return RequestOtpDto(phoneNumber: json['phone_number'] ?? '');
  }
}

/// Model for verifying OTP and completing login
class VerifyOtpDto {
  final String phoneNumber;
  final String otpCode;

  const VerifyOtpDto({required this.phoneNumber, required this.otpCode});

  /// Convert to JSON for API requests
  Map<String, dynamic> toJson() {
    return {'phone_number': phoneNumber, 'otp_code': otpCode};
  }

  /// Create from JSON response
  factory VerifyOtpDto.fromJson(Map<String, dynamic> json) {
    return VerifyOtpDto(
      phoneNumber: json['phone_number'] ?? '',
      otpCode: json['otp_code'] ?? '',
    );
  }
}

/// Model for authentication tokens received after successful login
class AuthTokenResponse {
  final String accessToken;
  final String refreshToken;
  final String accessTokenExpires;
  final String refreshTokenExpires;

  const AuthTokenResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.accessTokenExpires,
    required this.refreshTokenExpires,
  });

  /// Create from JSON response
  factory AuthTokenResponse.fromJson(Map<String, dynamic> json) {
    return AuthTokenResponse(
      accessToken: json['accessToken'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
      accessTokenExpires: json['accessTokenExpires'] ?? '',
      refreshTokenExpires: json['refreshTokenExpires'] ?? '',
    );
  }

  /// Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'accessTokenExpires': accessTokenExpires,
      'refreshTokenExpires': refreshTokenExpires,
    };
  }

  /// Check if access token is expired
  bool get isAccessTokenExpired {
    try {
      // Extract expiry from token (basic implementation)
      final parts = accessToken.split('.');
      if (parts.length != 3) return true;

      // In a real app, you'd decode the JWT and check the exp claim
      // For now, we'll implement a simple check
      return false; // Implement proper JWT decoding
    } catch (e) {
      return true;
    }
  }
}
