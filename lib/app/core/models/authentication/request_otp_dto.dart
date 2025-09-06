// lib/app/core/models/authentication/request_otp_dto.dart

/// Data Transfer Object for requesting an OTP.
///
/// This class encapsulates the data required to initiate the OTP login process.
/// It is used to serialize the request body for the POST /auth/request-otp endpoint.
class RequestOtpDto {
  /// The user's phone number in international format (e.g., with country code).
  final String phoneNumber;

  /// Creates a new instance of [RequestOtpDto].
  ///
  /// [phoneNumber] is a required field.
  RequestOtpDto({required this.phoneNumber});

  /// Converts the [RequestOtpDto] instance to a JSON map.
  ///
  /// This is used for serializing the object to be sent in the request body.
  Map<String, dynamic> toJson() {
    return {'phone_number': phoneNumber};
  }
}
