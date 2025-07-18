import '../config/app_identity.dart';

/// String constants used throughout the application
///
/// This class contains all the static text strings to ensure consistency
/// and make localization easier in the future.
class AppStrings {
  AppStrings._();

  // App Related (Auto-sourced from AppIdentity)
  static String get appName => AppIdentity.displayName;
  static String get welcomeMessage => 'Welcome to ${AppIdentity.displayName}';
  static const String tagline = 'Your ultimate shopping companion';

  // Authentication
  static const String login = 'Login';
  static const String logout = 'Logout';
  static const String signUp = 'Sign Up';
  static const String forgotPassword = 'Forgot Password?';
  static const String resetPassword = 'Reset Password';
  static const String changePassword = 'Change Password';
  static const String enterPassword = 'Enter Password';
  static const String confirmPassword = 'Confirm Password';
  static const String email = 'Email';
  static const String emailAddress = 'Email Address';
  static const String phoneNumber = 'Phone Number';
  static const String enterPhoneNumber = 'Enter Phone Number';
  static const String enterEmail = 'Enter Email';
  static const String otpVerification = 'OTP Verification';
  static const String enterOtp = 'Enter OTP';
  static const String resendOtp = 'Resend OTP';
  static const String verify = 'Verify';
  static const String sendOtp = 'Send OTP';

  // Login specific strings
  static const String loginWelcome = 'Welcome Back!';
  static const String loginHelperTitle = 'Sign in to continue';
  static const String loginCountryCode = '+91';
  static const String loginEnterMobileNumber = 'Enter mobile number';
  static const String loginTermsPolicy =
      'By continuing, you agree to our Terms & Privacy Policy';
  static const String loginErrEmpty = 'Mobile number cannot be empty';
  static const String loginErrNumberlength = 'Mobile number must be 10 digits';

  // OTP Check strings
  static const String otpCheckViewTitle = 'OTP Verification';
  static const String otpCheckEnterOtp = 'Enter verification code';
  static const String otpCheckHelperTitle =
      'We have sent a verification code to';
  static const String otpCheckEditMobile = 'Edit Mobile Number';
  static const String otpCheckVerifyButton = 'Verify';
  static const String otpCheckResendText = "Didn't receive code?";
  static const String otpCheckResendButton = 'Resend';
  static const String otpsendError = 'Failed to send OTP. Please try again.';

  // Onboarding strings
  static const String onBoardingSkip = 'Skip';
  static const String onBoardingButtonInitial = 'Next';
  static const String onBoardingButtonFinal = 'Get Started';

  // Success messages
  static const String otpSentMessage =
      'OTP sent successfully to your mobile number';

  // Navigation
  static const String home = 'Home';
  static const String categories = 'Categories';
  static const String cart = 'Cart';
  static const String profile = 'Profile';
  static const String search = 'Search';
  static const String wishlist = 'Wishlist';
  static const String orders = 'Orders';
  static const String settings = 'Settings';
  static const String notifications = 'Notifications';

  // Common Actions
  static const String add = 'Add';
  static const String remove = 'Remove';
  static const String delete = 'Delete';
  static const String edit = 'Edit';
  static const String update = 'Update';
  static const String save = 'Save';
  static const String cancel = 'Cancel';
  static const String confirm = 'Confirm';
  static const String submit = 'Submit';
  static const String send = 'Send';
  static const String done = 'Done';
  static const String next = 'Next';
  static const String previous = 'Previous';
  static const String skip = 'Skip';
  static const String retry = 'Retry';
  static const String refresh = 'Refresh';
  static const String loading = 'Loading...';
  static const String pleaseWait = 'Please wait...';

  // Shopping
  static const String addToCart = 'Add to Cart';
  static const String removeFromCart = 'Remove from Cart';
  static const String buyNow = 'Buy Now';
  static const String checkout = 'Checkout';
  static const String proceedToPayment = 'Proceed to Payment';
  static const String payment = 'Payment';
  static const String orderPlaced = 'Order Placed';
  static const String orderConfirmed = 'Order Confirmed';
  static const String price = 'Price';
  static const String quantity = 'Quantity';
  static const String total = 'Total';
  static const String subtotal = 'Subtotal';
  static const String shipping = 'Shipping';
  static const String tax = 'Tax';
  static const String discount = 'Discount';
  static const String coupon = 'Coupon';
  static const String applyCoupon = 'Apply Coupon';

  // Products
  static const String products = 'Products';
  static const String product = 'Product';
  static const String productDetails = 'Product Details';
  static const String description = 'Description';
  static const String specifications = 'Specifications';
  static const String reviews = 'Reviews';
  static const String rating = 'Rating';
  static const String outOfStock = 'Out of Stock';
  static const String inStock = 'In Stock';
  static const String limitedStock = 'Limited Stock';

  // User Interface
  static const String darkMode = 'Dark Mode';
  static const String lightMode = 'Light Mode';
  static const String language = 'Language';
  static const String theme = 'Theme';
  static const String aboutUs = 'About Us';
  static const String contactUs = 'Contact Us';
  static const String helpSupport = 'Help & Support';
  static const String privacyPolicy = 'Privacy Policy';
  static const String termsConditions = 'Terms & Conditions';

  // Error Messages
  static const String errorOccurred = 'An error occurred';
  static const String networkError =
      'Network error. Please check your connection.';
  static const String serverError = 'Server error. Please try again later.';
  static const String invalidInput = 'Invalid input';
  static const String fieldRequired = 'This field is required';
  static const String invalidEmail = 'Please enter a valid email address';
  static const String invalidPhoneNumber = 'Please enter a valid phone number';
  static const String passwordTooShort =
      'Password must be at least 8 characters';
  static const String passwordsDoNotMatch = 'Passwords do not match';
  static const String somethingWentWrong = 'Something went wrong';

  // Success Messages
  static const String success = 'Success';
  static const String savedSuccessfully = 'Saved successfully';
  static const String updatedSuccessfully = 'Updated successfully';
  static const String deletedSuccessfully = 'Deleted successfully';
  static const String loginSuccessful = 'Login successful';
  static const String registrationSuccessful = 'Registration successful';
  static const String passwordChanged = 'Password changed successfully';
  static const String otpSent = 'OTP sent successfully';
  static const String otpVerified = 'OTP verified successfully';

  // Empty States
  static const String noItemsFound = 'No items found';
  static const String cartEmpty = 'Your cart is empty';
  static const String wishlistEmpty = 'Your wishlist is empty';
  static const String noOrdersFound = 'No orders found';
  static const String noNotifications = 'No notifications';
  static const String noSearchResults = 'No search results found';

  // Placeholders
  static const String searchPlaceholder = 'Search products...';
  static const String enterYourName = 'Enter your name';
  static const String enterYourMessage = 'Enter your message';
}
