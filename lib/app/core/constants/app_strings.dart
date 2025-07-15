class AppStrings {
  // App Main Strings
  static const String appName = 'Bevco';

  // App Common Strings
  static const String error = 'Error!';

  // App On Boarding Strings
  static const String onBoardingSkip = 'Skip';
  static const String onBoardingButtonInitial = 'Next';
  static const String onBoardingButtonFinal = 'Get Started!';

  // App Login View Strings
  static const String loginWelcome = 'Welcome to $appName';
  static const String loginHelperTitle = 'Enter your phone number to continue';
  static const String loginEnterMobileNumber = 'Enter your mobile number';
  static const String loginCountryCode = '+91 ';
  static const String sendOtp = 'Send OTP';
  static const String loginTermsPolicy =
      'By continuing, you agree to our Terms of Service and Privacy Policy.';

  // App Login View Validation Error Strings
  static const loginErrNumberlength = 'Enter a valid 10-digit mobile number';
  static const String loginErrEmpty = 'Mobile number cannot be empty';

  // App Login View Snackbar Strings
  static const String otpSent = 'OTP Sent';
  static const String otpSentMessage = 'OTP sent to $loginCountryCode';
  static const String otpsendError = 'Error resending OTP, please try again';

  // App OTP Check View Strings
  static const String enterOtp = 'Enter your Verification Code';
  static const String otpHelperTitle =
      'We have sent a verification code to $loginCountryCode';
  // static const String resendOtp = 'Resend OTP';
  // static const String otpErrEmpty = 'OTP cannot be empty';
  // static const String otpErrInvalid = 'Invalid OTP';
  // static const String otpErrMismatch = 'OTP does not match';
  // static const String otpErrExpired =
  //     'OTP has expired, please request a new one';
  // static const String otpErrInvalidFormat = 'OTP must be a 6-digit number';
  // static const String otpErrMaxAttempts =
  //     'Maximum OTP attempts exceeded, please try again later';
  // static const String otpErrNetwork = 'Network error, please try again';
  // static const String otpErrTimeout = 'OTP request timed out, please try again';
  // static const String otpErrUnknown =
  //     'An unknown error occurred, please try again';
  // static const String otpSuccess = 'OTP verified successfully';
  // static const String otpResendSuccess = 'OTP resent successfully';
  // static const String otpResendError = 'Error resending OTP, please try again';
  // static const String otpResendLimitReached =
  //     'You have reached the limit for resending OTPs, please try again later';
}
