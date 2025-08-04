/// API endpoints configuration
///
/// Centralized configuration for all API endpoints used throughout the app.
/// Includes authentication, user management, products, cart, and other services.
class ApiEndpoints {
  ApiEndpoints._();

  // Base URL for API
  // static const String baseUrl = 'http://localhost:3000';
  static const String baseUrl = 'http://10.0.2.2:3000';

  // ============================================================================
  // AUTHENTICATION ENDPOINTS
  // ============================================================================

  /// Send OTP to phone number
  static const String requestOtp = '$baseUrl/auth/request-otp';

  /// Verify OTP and authenticate user
  static const String verifyOtp = '$baseUrl/auth/verify-otp';

  /// Refresh access token
  static const String refreshToken = '$baseUrl/auth/refresh-token';

  /// Logout user
  static const String logout = '$baseUrl/auth/logout';

  // ============================================================================
  // USER ENDPOINTS
  // ============================================================================

  /// Get user profile information
  static const String userProfile = '$baseUrl/user/profile';

  /// Update user profile
  static const String updateProfile = '$baseUrl/user/profile';

  /// Get user preferences
  static const String userPreferences = '$baseUrl/user/preferences';

  // ============================================================================
  // PRODUCT ENDPOINTS
  // ============================================================================

  /// Get all products
  static const String products = '$baseUrl/products';

  /// Get product by ID
  static String productById(String id) => '$baseUrl/products/$id';

  /// Search products
  static const String searchProducts = '$baseUrl/products/search';

  /// Get products by category
  static String productsByCategory(String category) =>
      '$baseUrl/products/category/$category';

  /// Get featured/hot deal products
  static const String featuredProducts = '$baseUrl/products/featured';

  // ============================================================================
  // CART ENDPOINTS
  // ============================================================================

  /// Get user's cart
  static const String cart = '$baseUrl/cart';

  /// Cart items operations
  static const String cartItems = '$baseUrl/cart/items';

  /// Specific cart item operations
  static String cartItem(String itemId) => '$baseUrl/cart/items/$itemId';

  // ============================================================================
  // ORDER ENDPOINTS
  // ============================================================================

  /// Get user's orders
  static const String orders = '$baseUrl/orders';

  /// Create new order
  static const String createOrder = '$baseUrl/orders';

  /// Get order by ID
  static String orderById(String id) => '$baseUrl/orders/$id';

  /// Cancel order
  static String cancelOrder(String id) => '$baseUrl/orders/$id/cancel';

  // ============================================================================
  // PAYMENT ENDPOINTS
  // ============================================================================

  /// Initiate payment
  static const String initiatePayment = '$baseUrl/payment/initiate';

  /// Verify payment
  static const String verifyPayment = '$baseUrl/payment/verify';

  /// Payment methods
  static const String paymentMethods = '$baseUrl/payment/methods';

  // ============================================================================
  // ADDRESS ENDPOINTS
  // ============================================================================

  /// Get user addresses
  static const String addresses = '$baseUrl/user/addresses';

  /// Add new address
  static const String addAddress = '$baseUrl/user/addresses';

  /// Update/delete specific address
  static String addressById(String id) => '$baseUrl/user/addresses/$id';

  // ============================================================================
  // NOTIFICATION ENDPOINTS
  // ============================================================================

  /// Get user notifications
  static const String notifications = '$baseUrl/notifications';

  /// Mark notification as read
  static String markNotificationRead(String id) =>
      '$baseUrl/notifications/$id/read';

  // ============================================================================
  // EXTERNAL API ENDPOINTS
  // ============================================================================

  /// External products API (JSONBin)
  static const String externalProducts =
      'https://api.jsonbin.io/v3/b/6881d8637b4b8670d8a6726c/latest';
}
