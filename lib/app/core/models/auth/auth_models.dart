/// Authentication models for handling OTP-based login and token management
///
/// This file contains all models related to the authentication flow including
/// OTP requests, verification, and token management with access/refresh token pairs.

/// Request model for initiating OTP-based authentication
///
/// Used when a user wants to log in or register using their phone number.
/// If the user doesn't exist, they will be automatically created with BUYER role.
class RequestOtpDto {
  /// The phone number in international format (e.g., +919876543210)
  final String phoneNumber;

  const RequestOtpDto({required this.phoneNumber});

  /// Convert the model to JSON for API requests
  Map<String, dynamic> toJson() => {'phone_number': phoneNumber};

  /// Create instance from JSON response
  factory RequestOtpDto.fromJson(Map<String, dynamic> json) =>
      RequestOtpDto(phoneNumber: json['phone_number'] as String);

  @override
  String toString() => 'RequestOtpDto(phoneNumber: $phoneNumber)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RequestOtpDto &&
          runtimeType == other.runtimeType &&
          phoneNumber == other.phoneNumber;

  @override
  int get hashCode => phoneNumber.hashCode;
}

/// Request model for verifying OTP and completing authentication
///
/// Used to verify the 4-digit OTP code sent to the user's phone number.
/// On successful verification, returns access and refresh tokens.
class VerifyOtpDto {
  /// The phone number that received the OTP
  final String phoneNumber;

  /// The 4-digit OTP code sent to the user
  final String otpCode;

  const VerifyOtpDto({required this.phoneNumber, required this.otpCode});

  /// Convert the model to JSON for API requests
  Map<String, dynamic> toJson() => {
    'phone_number': phoneNumber,
    'otp_code': otpCode,
  };

  /// Create instance from JSON response
  factory VerifyOtpDto.fromJson(Map<String, dynamic> json) => VerifyOtpDto(
    phoneNumber: json['phone_number'] as String,
    otpCode: json['otp_code'] as String,
  );

  @override
  String toString() =>
      'VerifyOtpDto(phoneNumber: $phoneNumber, otpCode: $otpCode)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VerifyOtpDto &&
          runtimeType == other.runtimeType &&
          phoneNumber == other.phoneNumber &&
          otpCode == other.otpCode;

  @override
  int get hashCode => Object.hash(phoneNumber, otpCode);
}

/// Response model containing authentication tokens and their validity periods
///
/// Returned after successful OTP verification or token refresh.
/// Contains both short-lived access token and long-lived refresh token.
class AuthTokensResponse {
  /// Short-lived token for accessing protected resources (typically 60 minutes)
  final String accessToken;

  /// Long-lived token for refreshing sessions (typically 30 days)
  final String refreshToken;

  /// Validity period of the access token (e.g., "60m")
  final String accessTokenExpires;

  /// Validity period of the refresh token (e.g., "30d")
  final String refreshTokenExpires;

  const AuthTokensResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.accessTokenExpires,
    required this.refreshTokenExpires,
  });

  /// Create instance from JSON response
  factory AuthTokensResponse.fromJson(Map<String, dynamic> json) =>
      AuthTokensResponse(
        accessToken: json['accessToken'] as String,
        refreshToken: json['refreshToken'] as String,
        accessTokenExpires: json['accessTokenExpires'] as String,
        refreshTokenExpires: json['refreshTokenExpires'] as String,
      );

  /// Convert the model to JSON for storage
  Map<String, dynamic> toJson() => {
    'accessToken': accessToken,
    'refreshToken': refreshToken,
    'accessTokenExpires': accessTokenExpires,
    'refreshTokenExpires': refreshTokenExpires,
  };

  @override
  String toString() =>
      'AuthTokensResponse('
      'accessToken: ${accessToken.substring(0, 20)}..., '
      'refreshToken: ${refreshToken.substring(0, 20)}..., '
      'accessTokenExpires: $accessTokenExpires, '
      'refreshTokenExpires: $refreshTokenExpires)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthTokensResponse &&
          runtimeType == other.runtimeType &&
          accessToken == other.accessToken &&
          refreshToken == other.refreshToken &&
          accessTokenExpires == other.accessTokenExpires &&
          refreshTokenExpires == other.refreshTokenExpires;

  @override
  int get hashCode => Object.hash(
    accessToken,
    refreshToken,
    accessTokenExpires,
    refreshTokenExpires,
  );
}

/// Enumeration of possible authentication states
///
/// Used to track the current authentication status of the user
/// throughout the application lifecycle.
enum AuthenticationState {
  /// User is not authenticated
  unauthenticated,

  /// OTP has been sent, waiting for verification
  otpSent,

  /// User is fully authenticated with valid tokens
  authenticated,

  /// Access token has expired, refresh token is still valid
  expired,

  /// Both tokens are invalid, user needs to re-authenticate
  invalid,
}

/// Authentication state data containing current status and tokens
///
/// Comprehensive model that tracks the user's authentication state
/// and associated token information for session management.
class AuthState {
  /// Current authentication state
  final AuthenticationState state;

  /// Authentication tokens (null if not authenticated)
  final AuthTokensResponse? tokens;

  /// Phone number of the authenticated user (null if not authenticated)
  final String? phoneNumber;

  /// Timestamp when the state was last updated
  final DateTime lastUpdated;

  const AuthState({
    required this.state,
    this.tokens,
    this.phoneNumber,
    required this.lastUpdated,
  });

  /// Create an unauthenticated state
  factory AuthState.unauthenticated() => AuthState(
    state: AuthenticationState.unauthenticated,
    lastUpdated: DateTime.now(),
  );

  /// Create an OTP sent state
  factory AuthState.otpSent(String phoneNumber) => AuthState(
    state: AuthenticationState.otpSent,
    phoneNumber: phoneNumber,
    lastUpdated: DateTime.now(),
  );

  /// Create an authenticated state with tokens
  factory AuthState.authenticated({
    required AuthTokensResponse tokens,
    required String phoneNumber,
  }) => AuthState(
    state: AuthenticationState.authenticated,
    tokens: tokens,
    phoneNumber: phoneNumber,
    lastUpdated: DateTime.now(),
  );

  /// Create an expired state (access token expired)
  factory AuthState.expired({
    required AuthTokensResponse tokens,
    required String phoneNumber,
  }) => AuthState(
    state: AuthenticationState.expired,
    tokens: tokens,
    phoneNumber: phoneNumber,
    lastUpdated: DateTime.now(),
  );

  /// Create an invalid state (all tokens invalid)
  factory AuthState.invalid() => AuthState(
    state: AuthenticationState.invalid,
    lastUpdated: DateTime.now(),
  );

  /// Check if the user is currently authenticated
  bool get isAuthenticated => state == AuthenticationState.authenticated;

  /// Check if tokens need to be refreshed
  bool get needsRefresh => state == AuthenticationState.expired;

  /// Check if the user needs to re-authenticate completely
  bool get needsReauthentication =>
      state == AuthenticationState.unauthenticated ||
      state == AuthenticationState.invalid;

  /// Create a copy with updated values
  AuthState copyWith({
    AuthenticationState? state,
    AuthTokensResponse? tokens,
    String? phoneNumber,
    DateTime? lastUpdated,
  }) => AuthState(
    state: state ?? this.state,
    tokens: tokens ?? this.tokens,
    phoneNumber: phoneNumber ?? this.phoneNumber,
    lastUpdated: lastUpdated ?? DateTime.now(),
  );

  /// Convert to JSON for storage
  Map<String, dynamic> toJson() => {
    'state': state.name,
    'tokens': tokens?.toJson(),
    'phoneNumber': phoneNumber,
    'lastUpdated': lastUpdated.toIso8601String(),
  };

  /// Create instance from JSON storage
  factory AuthState.fromJson(Map<String, dynamic> json) => AuthState(
    state: AuthenticationState.values.firstWhere(
      (state) => state.name == json['state'],
      orElse: () => AuthenticationState.unauthenticated,
    ),
    tokens: json['tokens'] != null
        ? AuthTokensResponse.fromJson(json['tokens'] as Map<String, dynamic>)
        : null,
    phoneNumber: json['phoneNumber'] as String?,
    lastUpdated: DateTime.parse(json['lastUpdated'] as String),
  );

  @override
  String toString() =>
      'AuthState('
      'state: $state, '
      'hasTokens: ${tokens != null}, '
      'phoneNumber: $phoneNumber, '
      'lastUpdated: $lastUpdated)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthState &&
          runtimeType == other.runtimeType &&
          state == other.state &&
          tokens == other.tokens &&
          phoneNumber == other.phoneNumber &&
          lastUpdated == other.lastUpdated;

  @override
  int get hashCode => Object.hash(state, tokens, phoneNumber, lastUpdated);
}
