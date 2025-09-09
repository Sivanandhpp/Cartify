import '../config/app_identity.dart';

/// String constants used throughout the application
///
/// This class contains all the static text strings to ensure consistency
/// and make localization easier in the future.
///
/// Organization:
/// - App Related: General app strings
/// - Authentication: Login, OTP, signup
/// - Common Actions: Generic buttons/actions
/// - Navigation: Bottom nav, menus
/// - Shopping: Cart, checkout, payments
/// - Products: Product details, stock
/// - User Interface: Themes, settings
/// - Error Messages: All error notifications
/// - Success Messages: All success notifications
/// - Empty States: No data scenarios
/// - Placeholders: Input field hints
/// - Buyer Panel Specific: Buyer-side features
/// - Seller Panel Specific: Seller-side features
class AppStrings {
  AppStrings._();

  // =================================================================================================
  //                                        APP RELATED
  // =================================================================================================
  // General app information and branding
  static String get appName => AppIdentity.displayName;
  static String get welcomeMessage => 'Welcome to $appName';
  static const String tagline = 'Your ultimate shopping companion';

  // =================================================================================================
  //                                        AUTHENTICATION
  // =================================================================================================
  // Login, signup, OTP verification
  static const String login = 'Login';
  static const String logout = 'Logout';
  static const String signUp = 'Sign Up';
  static const String otpVerification = 'OTP Verification';
  static const String enterOtp = 'Enter OTP';
  static const String resendOtp = 'Resend OTP';
  static const String verify = 'Verify';
  static const String sendOtp = 'Send OTP';

  // Login specific
  static const String loginWelcome = 'Welcome Back!';
  static const String loginHelperTitle = 'Enter your Phone Number to continue';
  static const String loginCountryCode = '+91';
  static const String loginEnterMobileNumber = 'Enter Phone Number';
  static const String loginErrEmpty = 'Mobile number cannot be empty';
  static const String loginErrNumber = 'Mobile number must be valid 10 digits';
  static const String loginTermsPolicy =
      'By continuing, you agree to our Terms & Privacy Policy';

  // OTP Check
  static const String otpCheckViewTitle = 'OTP Verification';
  static const String otpCheckEnterOtp = 'Enter verification code';
  static const String otpCheckHelperTitle =
      'We have sent a verification code to';
  static const String otpCheckEditMobile = 'Edit';
  static const String otpCheckVerifyButton = 'Verify';
  static const String otpCheckResendText = "Didn't receive code?";
  static const String otpCheckResendButton = 'Resend';
  static const String otpsendError = 'Failed to send OTP. Please try again.';

  // Onboarding
  static const String onBoardingSkip = 'Skip';
  static const String onBoardingButtonInitial = 'Next';
  static const String onBoardingButtonFinal = 'Get Started';

  // =================================================================================================
  //                                        COMMON ACTIONS
  // =================================================================================================
  // Generic buttons and actions used across the app
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

  // =================================================================================================
  //                                        NAVIGATION
  // =================================================================================================
  // Bottom navigation and menu items
  static const String home = 'Home';
  static const String categories = 'Categories';
  static const String cart = 'Cart';
  static const String profile = 'Profile';
  static const String search = 'Search';
  static const String wishlist = 'Wishlist';
  static const String orders = 'Orders';
  static const String settings = 'Settings';
  static const String notifications = 'Notifications';

  // =================================================================================================
  //                                        SHOPPING
  // =================================================================================================
  // Cart, checkout, payments
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

  // =================================================================================================
  //                                        PRODUCTS
  // =================================================================================================
  // Product details, stock, reviews
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

  // =================================================================================================
  //                                        USER INTERFACE
  // =================================================================================================
  // Themes, settings, about
  static const String darkMode = 'Dark Mode';
  static const String lightMode = 'Light Mode';
  static const String language = 'Language';
  static const String theme = 'Theme';
  static const String aboutUs = 'About Us';
  static const String contactUs = 'Contact Us';
  static const String helpSupport = 'Help & Support';
  static const String privacyPolicy = 'Privacy Policy';
  static const String termsConditions = 'Terms & Conditions';

  // =================================================================================================
  //                                        ERROR MESSAGES
  // =================================================================================================
  // All error notifications and validation messages
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

  // Buyer-specific errors (moved here for organization)
  static const String emptyCartTitle = 'Empty Cart';
  static const String addItemsToCartMessage =
      'Please add items to your cart before proceeding';
  static const String noAddressSelectedTitle = 'No Address Selected';
  static const String selectDeliveryAddressMessage =
      'Please select a delivery address';
  static const String invalidAddressTitle = 'Invalid Address';
  static const String addressIncompleteMessage =
      'The selected address is incomplete. Please update it.';
  static const String itemOutOfStockTitle = 'Item Out of Stock';
  static const String itemOutOfStockMessage =
      'is currently out of stock'; // Placeholder for dynamic name
  static const String failedToUpdateCart = 'Failed to update cart';
  static const String failedToRemoveItemFromCart =
      'Failed to remove item from cart';
  static const String failedToClearCart = 'Failed to clear cart';
  static const String orderFailedTitle = 'Order Failed';
  static const String orderFailedMessage =
      'An error occurred while placing your order. Please try again.';
  static const String errorLoadingDashboard = 'Error Loading Dashboard';

  // Seller-specific errors (new additions)
  static const String invalidInputTitle = 'Invalid Input';
  static const String attributeKeyValueRequired =
      'Both key and value are required';
  static const String duplicateAttributeKey = 'Duplicate Key';
  static const String attributeKeyExists = 'This attribute key already exists';
  static const String imageLimitReached = 'Limit Reached';
  static const String maxImagesExceeded = 'You can only add up to 5 images';
  static const String failedToSaveProduct =
      'Failed to save product. Please try again.';

  // =================================================================================================
  //                                        SUCCESS MESSAGES
  // =================================================================================================
  // All success notifications
  static const String success = 'Success';
  static const String savedSuccessfully = 'Saved successfully';
  static const String updatedSuccessfully = 'Updated successfully';
  static const String deletedSuccessfully = 'Deleted successfully';
  static const String loginSuccessful = 'Login successful';
  static const String registrationSuccessful = 'Registration successful';
  static const String passwordChanged = 'Password changed successfully';
  static const String otpSent = 'OTP sent successfully';
  static const String otpVerified = 'OTP verified successfully';
  static const String otpSentMessage =
      'OTP sent successfully to your mobile number';

  // Buyer-specific success (moved here)
  static const String profileUpdatedSuccess = 'Profile updated successfully';

  // Seller-specific success (new additions)
  static const String attributeAddedSuccess = 'Attribute Added';
  static const String attributeAddedMessage =
      'Product attribute added successfully';
  static const String imageAddedSuccess = 'Image Added';
  static const String imageAddedMessage = 'Product image added successfully';
  static const String productSavedSuccess = 'Success!';
  static const String productSavedMessage = 'Product saved successfully';

  // =================================================================================================
  //                                        EMPTY STATES
  // =================================================================================================
  // No data scenarios
  static const String noItemsFound = 'No items found';
  static const String cartEmpty = 'Your cart is empty';
  static const String wishlistEmpty = 'Your wishlist is empty';
  static const String noOrdersFound = 'No orders found';
  static const String noNotifications = 'No notifications';
  static const String noSearchResults = 'No search results found';

  // =================================================================================================
  //                                        PLACEHOLDERS
  // =================================================================================================
  // Input field hints
  static const String searchPlaceholder = 'Search products...';
  static const String enterYourName = 'Enter your name';
  static const String enterYourMessage = 'Enter your message';
  static const String enterYourNamePlaceholder =
      'Enter your name'; // Duplicate removed in cleanup
  static const String enterYourMessagePlaceholder =
      'Enter your message'; // Duplicate removed in cleanup

  // =================================================================================================
  //                                        BUYER PANEL SPECIFIC
  // =================================================================================================
  // Strings unique to buyer-side features

  // Cart and Checkout
  static const String missedSomethingPrompt = 'Missed Something?';
  static const String addMoreItemsAction = 'Add more items';
  static const String billDetailsTitle = 'Bill Details';
  static const String lastTenDaysPerformance = 'Last 10 days performance';
  static const String featuredProductsTitle = 'Featured Products';
  static const String addFirstAddressPrompt =
      'Add your first address to continue with delivery';
  static const String addFirstAddressAction = 'Add Address';
  static const String addFirstAddressToGetStarted =
      'Add your first address to get started with deliveries';
  static const String shoppingCartTitle = 'Shopping Cart';
  static const String addItemsToGetStarted = 'Add some items to get started';
  static const String startShopping = 'Start Shopping';
  static const String reviewYourOrder = 'Review your Order';
  static const String payUsing = 'Pay using';
  static const String wallet = 'Wallet';
  static const String pay = 'Pay';
  static const String items = 'items';
  static const String noItemsInCart = 'No items in cart';
  static const String clearCart = 'Clear Cart';
  static const String itemTotal = 'Item Total';
  static const String handlingFee = 'Handling Fee';
  static const String deliveryPartnerFee = 'Delivery Partner Fee';
  static const String gst = 'GST';
  static const String deliveryTip = 'Delivery Tip';
  static const String toPay = 'To Pay';
  static const String selectDeliveryAddress = 'Select Delivery Address';
  static const String noAddressesFound = 'No Addresses Found';
  static const String trackOrder = 'Track Order';
  static const String continueShopping = 'Continue Shopping';
  static const String orderId = 'Order ID';
  static const String deliveryAddress = 'Delivery Address';

  // Address Management
  static const String nearLandmarkPrefix = 'Near';
  static const String addressFormTitle = 'Add New Address';
  static const String addressFormSaveButton = 'Save Address';
  static const String addressFormCancelButton = 'Cancel';

  // Additional
  static const String myAddressesTitle = 'My Addresses';
  static const String addNewAddress = 'Add New Address';

  // Profile and Orders
  static const String buyerOrdersTitle = 'My Orders';
  static const String buyerProfileTitle = 'My Profile';
  static const String editProfileTitle = 'Edit Profile';
  static const String buyerWishlistTitle = 'My Wishlist';

  // Profile sections
  static const String accountSection = 'Account';
  static const String preferencesSection = 'Preferences';
  static const String supportSection = 'Support';

  // Orders
  static const String noOrdersYet = 'No Orders Yet';
  static const String orderHistoryMessage =
      'Your order history will appear here';
  static const String orderPrefix = 'Order #';
  static const String billTotalPrefix = 'Bill Total ₹';
  static const String orderedOnPrefix = 'Ordered on ';

  // Edit Profile
  static const String updateProfile = 'Update Profile';
  static const String tapToChangeProfilePicture =
      'Tap to change profile picture';
  static const String fullNameLabel = 'Full Name';
  static const String enterYourFullName = 'Enter your full name';
  static const String emailAddressLabel = 'Email Address';
  static const String enterYourEmailAddress = 'Enter your email address';
  static const String phoneNumberLabel = 'Phone Number';
  static const String yourPhoneNumber = 'Your phone number';

  // Categories and Offers
  static const String buyerCategoriesTitle = 'Categories';
  static const String buyerOffersTitle = 'Offers';
  static const String allSubCategory = 'All';

  // Categories and Offers
  static const String noCategoriesAvailable = 'No categories available';
  static const String pullToRefreshOrTryAgain = 'Pull to refresh or try again';
  static const String subcategories = 'subcategories';
  static const String loadingProducts = 'Loading products...';
  static const String noProductsFoundInCategory =
      'No products found in this category';

  // Dashboard and Home
  static const String buyerDashboardTitle = 'Dashboard';
  static const String buyerHomeTitle = 'Home';
  static const String searchProductsPlaceholder =
      'Search products...'; // Duplicate with searchPlaceholder, kept for specificity

  // =================================================================================================
  //                                        SELLER PANEL SPECIFIC
  // =================================================================================================
  // Strings unique to seller-side features

  // Product Creation and Management
  static const String selectedTagsLabel = 'Selected Tags';
  static const String attributeLabel = 'Attribute';
  static const String valueLabel = 'Value';
  static const String productBasicsStep = 'Product Basics';
  static const String categorizationDetailsStep = 'Categorization & Details';
  static const String discountsAvailabilityStep = 'Discounts & Availability';
  static const String productBasicsDescription =
      'Give your product a name, price, and first look';
  static const String categorizationDescription =
      'Organize your product and define key details';
  static const String discountsDescription =
      'Set special offers and time period';
  static const String addNewProductNavigation = 'Navigating to add new product';

  // Filters and Status
  static const String activeStatus = 'active';
  static const String inactiveStatus = 'inactive';
  static const String lowStockStatus = 'low_stock';
  static const String allFilter = 'All';

  // Analytics and Dashboard
  static const String sellerAnalyticsTitle = 'Analytics';
  static const String sellerOrdersTitle = 'Orders';
  static const String sellerProductsTitle = 'Products';
  static const String sellerProfileTitle = 'Profile';
  static const String sellerDashboardTitle = 'Dashboard';
}
