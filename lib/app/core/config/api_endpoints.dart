/// Comprehensive API endpoints configuration for the Cartify e-commerce platform
///
/// This file contains all API endpoints organized by service areas,
/// following the complete backend API structure and ensuring consistency
/// across all network operations in the application.

class ApiEndpoints {
  ApiEndpoints._();

  // Base URL configurations
  // Note: Use localhost for development on actual devices
  // Use 10.0.2.2 for Android emulator to access host machine
  static const String baseUrl = 'http://10.0.2.2:3000';
  // static const String baseUrl = 'http://localhost:3000';

  // Static files base URL (for images and other assets)
  static const String staticUrl = baseUrl;

  // ========================================
  // AUTHENTICATION SERVICE ENDPOINTS
  // ========================================

  /// Request OTP for phone number authentication
  /// Method: POST
  /// Authentication: Public
  static const String requestOtp = '$baseUrl/auth/request-otp';

  /// Verify OTP and complete authentication
  /// Method: POST
  /// Authentication: Public
  /// Returns: Access and refresh tokens
  static const String verifyOtp = '$baseUrl/auth/verify-otp';

  /// Refresh authentication tokens
  /// Method: GET
  /// Authentication: JWT Refresh Token Required
  static const String refreshToken = '$baseUrl/auth/refresh';

  /// Logout and invalidate tokens
  /// Method: POST
  /// Authentication: JWT Access Token Required
  static const String logout = '$baseUrl/auth/logout';

  // ========================================
  // USER SERVICE ENDPOINTS
  // ========================================

  /// Get authenticated user's profile
  /// Method: GET
  /// Authentication: JWT Access Token Required
  static const String getUserProfile = '$baseUrl/user/profile';

  /// Update authenticated user's profile
  /// Method: PATCH
  /// Authentication: JWT Access Token Required
  static const String updateUserProfile = '$baseUrl/user/profile';

  /// Upload user profile picture
  /// Method: POST
  /// Authentication: JWT Access Token Required
  /// Content-Type: multipart/form-data
  static const String uploadProfilePicture = '$baseUrl/user/profile/picture';

  // ========================================
  // ADDRESS SERVICE ENDPOINTS
  // ========================================

  /// Get all addresses for authenticated user
  /// Method: GET
  /// Authentication: JWT Access Token Required
  static const String getAllAddresses = '$baseUrl/address';

  /// Add new address for authenticated user
  /// Method: POST
  /// Authentication: JWT Access Token Required
  static const String addAddress = '$baseUrl/address';

  /// Update specific address by ID
  /// Method: PATCH
  /// Authentication: JWT Access Token Required
  /// Parameter: addressId
  static String updateAddress(String addressId) =>
      '$baseUrl/address/$addressId';

  /// Delete specific address by ID
  /// Method: DELETE
  /// Authentication: JWT Access Token Required
  /// Parameter: addressId
  static String deleteAddress(String addressId) =>
      '$baseUrl/address/$addressId';

  // ========================================
  // DASHBOARD SERVICE ENDPOINTS
  // ========================================

  /// Get dashboard data for home screen
  /// Method: GET
  /// Authentication: Public
  /// Returns: Structured sections for dynamic home screen
  static const String getDashboard = '$baseUrl/dashboard';

  // ========================================
  // CATALOG SERVICE ENDPOINTS
  // ========================================

  /// Get all product categories
  /// Method: GET
  /// Authentication: Public
  static const String getAllCategories = '$baseUrl/categories';

  /// Get all products with optional filtering
  /// Method: GET
  /// Authentication: Public
  /// Query parameters: category, search, sort, limit, offset
  static const String getAllProducts = '$baseUrl/products';

  /// Get single product by ID
  /// Method: GET
  /// Authentication: Public
  /// Parameter: productId
  static String getProductById(String productId) =>
      '$baseUrl/products/$productId';

  /// Create new product (Seller/Admin only)
  /// Method: POST
  /// Authentication: JWT Access Token Required (Admin or Seller)
  static const String createProduct = '$baseUrl/products';

  /// Upload product images
  /// Method: POST
  /// Authentication: JWT Access Token Required (Admin or Seller)
  /// Content-Type: multipart/form-data
  /// Parameter: productId
  static String uploadProductImages(String productId) =>
      '$baseUrl/products/$productId/images';

  // ========================================
  // CART SERVICE ENDPOINTS
  // ========================================

  /// Get authenticated user's cart
  /// Method: GET
  /// Authentication: JWT Access Token Required
  static const String getCart = '$baseUrl/cart';

  /// Add item to cart
  /// Method: POST
  /// Authentication: JWT Access Token Required
  static const String addToCart = '$baseUrl/cart/items';

  /// Update cart item quantity
  /// Method: PATCH
  /// Authentication: JWT Access Token Required
  /// Parameter: cartItemId
  static String updateCartItem(String cartItemId) =>
      '$baseUrl/cart/items/$cartItemId';

  /// Remove item from cart
  /// Method: DELETE
  /// Authentication: JWT Access Token Required
  /// Parameter: cartItemId
  static String removeCartItem(String cartItemId) =>
      '$baseUrl/cart/items/$cartItemId';

  /// Clear entire cart
  /// Method: DELETE
  /// Authentication: JWT Access Token Required
  static const String clearCart = '$baseUrl/cart';

  // ========================================
  // REVIEW SERVICE ENDPOINTS
  // ========================================

  /// Get reviews for a specific product
  /// Method: GET
  /// Authentication: Public
  /// Parameter: productId
  /// Query parameters: page, limit, sort
  static String getProductReviews(String productId) =>
      '$baseUrl/reviews/product/$productId';

  /// Create a new review for a product
  /// Method: POST
  /// Authentication: JWT Access Token Required
  static const String createReview = '$baseUrl/reviews';

  // ========================================
  // ORDER SERVICE ENDPOINTS
  // ========================================

  /// Place a new order from cart
  /// Method: POST
  /// Authentication: JWT Access Token Required
  static const String placeOrder = '$baseUrl/orders';

  /// Get authenticated user's order history
  /// Method: GET
  /// Authentication: JWT Access Token Required
  /// Query parameters: page, limit, status
  static const String getOrderHistory = '$baseUrl/orders';

  /// Get specific order by ID
  /// Method: GET
  /// Authentication: JWT Access Token Required
  /// Parameter: orderId
  static String getOrderById(String orderId) => '$baseUrl/orders/$orderId';

  // ========================================
  // UTILITY METHODS
  // ========================================

  /// Convert relative image URLs to absolute URLs
  /// This method ensures all image URLs returned from the API
  /// are properly formatted with the base URL for display
  static String getFullImageUrl(String? relativeUrl) {
    if (relativeUrl == null || relativeUrl.isEmpty) return '';

    // If already absolute URL, return as is
    if (relativeUrl.startsWith('http://') ||
        relativeUrl.startsWith('https://')) {
      return relativeUrl;
    }

    // Remove leading slash if present and prepend base URL
    final cleanUrl = relativeUrl.startsWith('/')
        ? relativeUrl.substring(1)
        : relativeUrl;
    return '$staticUrl/$cleanUrl';
  }

  /// Build query parameters for API requests
  /// Converts a map of parameters to a properly formatted query string
  static String buildQueryParams(Map<String, dynamic> params) {
    if (params.isEmpty) return '';

    final queryParams = params.entries
        .where((entry) => entry.value != null)
        .map(
          (entry) =>
              '${entry.key}=${Uri.encodeComponent(entry.value.toString())}',
        )
        .join('&');

    return queryParams.isNotEmpty ? '?$queryParams' : '';
  }

  /// Build URL with query parameters
  /// Combines a base URL with query parameters
  static String buildUrlWithParams(
    String baseUrl,
    Map<String, dynamic> params,
  ) {
    return baseUrl + buildQueryParams(params);
  }

  // ========================================
  // SEARCH AND FILTERING ENDPOINTS
  // ========================================

  /// Search products with advanced filtering
  /// Method: GET
  /// Authentication: Public
  static String searchProducts({
    String? query,
    String? categoryId,
    double? minPrice,
    double? maxPrice,
    String? sortBy,
    int? page,
    int? limit,
  }) {
    final params = <String, dynamic>{};
    if (query != null && query.isNotEmpty) params['search'] = query;
    if (categoryId != null && categoryId.isNotEmpty)
      params['category'] = categoryId;
    if (minPrice != null) params['min_price'] = minPrice;
    if (maxPrice != null) params['max_price'] = maxPrice;
    if (sortBy != null && sortBy.isNotEmpty) params['sort'] = sortBy;
    if (page != null) params['page'] = page;
    if (limit != null) params['limit'] = limit;

    return buildUrlWithParams(getAllProducts, params);
  }

  /// Get products by category with pagination
  /// Method: GET
  /// Authentication: Public
  static String getProductsByCategory(
    String categoryId, {
    int? page,
    int? limit,
  }) {
    final params = <String, dynamic>{'category': categoryId};
    if (page != null) params['page'] = page;
    if (limit != null) params['limit'] = limit;

    return buildUrlWithParams(getAllProducts, params);
  }

  /// Get featured products
  /// Method: GET
  /// Authentication: Public
  static String getFeaturedProducts({int? limit}) {
    final params = <String, dynamic>{'featured': 'true'};
    if (limit != null) params['limit'] = limit;

    return buildUrlWithParams(getAllProducts, params);
  }

  // ========================================
  // VALIDATION HELPERS
  // ========================================

  /// Validate if a URL is a valid API endpoint
  static bool isValidApiUrl(String url) {
    return url.startsWith(baseUrl) && Uri.tryParse(url) != null;
  }

  /// Get the service name from an endpoint URL
  static String getServiceName(String endpoint) {
    if (endpoint.startsWith('$baseUrl/auth')) return 'Authentication';
    if (endpoint.startsWith('$baseUrl/user')) return 'User';
    if (endpoint.startsWith('$baseUrl/address')) return 'Address';
    if (endpoint.startsWith('$baseUrl/dashboard')) return 'Dashboard';
    if (endpoint.startsWith('$baseUrl/categories')) return 'Categories';
    if (endpoint.startsWith('$baseUrl/products')) return 'Products';
    if (endpoint.startsWith('$baseUrl/cart')) return 'Cart';
    if (endpoint.startsWith('$baseUrl/reviews')) return 'Reviews';
    if (endpoint.startsWith('$baseUrl/orders')) return 'Orders';
    return 'Unknown';
  }

  /// Check if an endpoint requires authentication
  static bool requiresAuthentication(String endpoint) {
    // Public endpoints that don't require authentication
    final publicEndpoints = [
      requestOtp,
      verifyOtp,
      getDashboard,
      getAllCategories,
      getAllProducts,
    ];

    // Check if it's a public endpoint or starts with a public pattern
    if (publicEndpoints.contains(endpoint)) return false;
    if (endpoint.startsWith('$baseUrl/products/') &&
        !endpoint.contains('/images'))
      return false;
    if (endpoint.startsWith('$baseUrl/reviews/product/')) return false;

    // Special case for refresh token endpoint (uses refresh token)
    if (endpoint == refreshToken) return true;

    // All other endpoints require authentication
    return true;
  }
}
