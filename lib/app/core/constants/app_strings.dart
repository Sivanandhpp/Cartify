class AppStrings {
  // App Main Strings
  static const String appName = 'Cartify';

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
  static const String otpCheckViewTitle = 'Verify Account';
  static const String otpCheckEnterOtp = 'Enter your Verification Code';
  static const String otpCheckHelperTitle =
      'We have sent a verification code to';
  static const String otpCheckEditMobile = 'Edit?';
  static const String otpCheckResend = 'Resend again';
  static const String otpCheckVerifyButton = 'Verify OTP';
  static const String otpCheckResendText = "Didn't receive code? ";
  static const String otpCheckResendButton = 'Resend again!';
}
