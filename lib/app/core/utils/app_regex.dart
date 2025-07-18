/// Regular expression patterns for validation
class AppRegex {
  AppRegex._();

  // Phone number patterns
  static final RegExp mobileNumber = RegExp(r'^[6-9]\d{9}$');
  static final RegExp phoneNumber = RegExp(r'^\+?[\d\s\-\(\)]+$');

  // Email pattern
  static final RegExp email = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  // Password patterns
  static final RegExp password = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
  );
  static final RegExp strongPassword = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{12,}$',
  );

  // Name patterns
  static final RegExp name = RegExp(r'^[a-zA-Z\s]+$');
  static final RegExp username = RegExp(r'^[a-zA-Z0-9_]+$');

  // Numeric patterns
  static final RegExp digits = RegExp(r'^\d+$');
  static final RegExp decimal = RegExp(r'^\d+\.?\d*$');
  static final RegExp currency = RegExp(r'^\d+\.?\d{0,2}$');

  // OTP pattern
  static final RegExp otp = RegExp(r'^\d{4,6}$');

  // Card patterns
  static final RegExp creditCard = RegExp(r'^\d{13,19}$');
  static final RegExp cvv = RegExp(r'^\d{3,4}$');

  // URL pattern
  static final RegExp url = RegExp(
    r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
  );

  // Special characters
  static final RegExp specialChars = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
  static final RegExp noSpecialChars = RegExp(r'^[a-zA-Z0-9\s]+$');

  // Indian specific patterns
  static final RegExp pincode = RegExp(r'^\d{6}$');
  static final RegExp gst = RegExp(
    r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$',
  );
  static final RegExp pan = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$');
  static final RegExp aadhar = RegExp(r'^\d{12}$');

  // Helper methods
  static bool isValidMobileNumber(String value) => mobileNumber.hasMatch(value);
  static bool isValidEmail(String value) => email.hasMatch(value);
  static bool isValidPassword(String value) => password.hasMatch(value);
  static bool isValidOTP(String value) => otp.hasMatch(value);
  static bool isValidPincode(String value) => pincode.hasMatch(value);
}

