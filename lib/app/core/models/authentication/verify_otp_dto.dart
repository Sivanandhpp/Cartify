// lib/app/core/models/authentication/verify_otp_dto.dart

/// Data Transfer Object for verifying a submitted OTP.
///
/// This class encapsulates the data needed to verify the OTP and complete the login process.
/// It is used to serialize the request body for the POST /auth/verify-otp endpoint.
class VerifyOtpDto {
  /// The user's phone number, used to identify the user.
  final String phoneNumber;

  /// The 4-digit code sent to the user's phone.
  final String otpCode;

  /// Creates a new instance of [VerifyOtpDto].
  ///
  /// Both [phoneNumber] and [otpCode] are required.
  VerifyOtpDto({required this.phoneNumber, required this.otpCode});

  /// Converts the [VerifyOtpDto] instance to a JSON map.
  ///
  /// This is used for serializing the object to be sent in the request body.
  Map<String, dynamic> toJson() {
    return {'phone_number': phoneNumber, 'otp_code': otpCode};
  }
}
