# API Services Architecture

This directory contains all API-related services organized by functionality for better maintainability and separation of concerns.

## 📁 Structure

```
api_services/
├── index.dart                    # Export file for clean imports
├── base_api_service.dart        # Core HTTP client functionality
├── auth_api_service.dart        # Authentication operations
├── cart_api_service.dart        # Cart management operations
└── products_api_service.dart    # Product-related operations
```

## 🛠️ Services Overview

### BaseApiService
**File:** `base_api_service.dart`

Core HTTP service providing authenticated and unauthenticated request methods:
- `get()`, `post()`, `put()`, `delete()` - Authenticated requests
- `publicGet()`, `publicPost()` - Unauthenticated requests
- Automatic authentication header injection
- Comprehensive request/response logging
- Configurable timeouts
- Custom header support for external APIs

**Usage:**
```dart
// Authenticated request
final response = await BaseApiService.get('/api/user/profile');

// Unauthenticated request
final response = await BaseApiService.publicPost('/api/auth/login', loginData);

// Custom headers (for external APIs)
final headers = BaseApiService.getCustomHeaders({'X-API-Key': 'key'});
```

### AuthApiService
**File:** `auth_api_service.dart`

Handles all authentication-related operations:
- OTP sending and verification
- Token management
- User profile fetching
- Logout functionality
- Authentication status checking

**Methods:**
```dart
AuthApiService.sendOtp(phone)           // Send OTP to phone number
AuthApiService.verifyOtp(phone, otp)    // Verify OTP and authenticate
AuthApiService.logout()                 // Logout and clear data
AuthApiService.isAuthenticated         // Check auth status
AuthApiService.accessToken            // Get current token
AuthApiService.authorizationHeader    // Get auth header
```

### CartApiService
**File:** `cart_api_service.dart`

Manages cart operations with the backend:
- Get user's cart
- Add/remove items
- Update item quantities
- Clear entire cart

**Methods:**
```dart
CartApiService.getCart()                                    // Get cart
CartApiService.addItemToCart(productId: id, quantity: qty) // Add item
CartApiService.updateCartItemQuantity(itemId: id, qty: qty) // Update quantity
CartApiService.removeCartItem(itemId)                      // Remove item
CartApiService.clearCart()                                 // Clear all items
```

### ProductsApiService
**File:** `products_api_service.dart`

Handles product-related API operations:
- Fetch products from external and internal APIs
- Product search and filtering
- Category-based product retrieval
- Hot deals and featured products

**Methods:**
```dart
ProductsApiService.fetchProducts()                    // Get all products (external)
ProductsApiService.fetchProductsFromInternalApi()    // Get products (internal)
ProductsApiService.fetchHotDealsProducts(limit: 10)  // Get hot deals
ProductsApiService.getProductById(id)               // Get specific product
ProductsApiService.searchProducts(query)            // Search products
ProductsApiService.getProductsByCategory(category)  // Get by category
```

## 🔧 Usage Examples

### Import the services
```dart
// Import all services
import 'package:cartify/app/core/services/api_services/index.dart';

// Or import specific services
import 'package:cartify/app/core/services/api_services/auth_api_service.dart';
import 'package:cartify/app/core/services/api_services/cart_api_service.dart';
```

### Authentication flow
```dart
// Send OTP
final otpResult = await AuthApiService.sendOtp(phoneNumber);
if (otpResult['success']) {
  // OTP sent successfully
}

// Verify OTP
final verifyResult = await AuthApiService.verifyOtp(phoneNumber, otpCode);
if (verifyResult['success']) {
  // User authenticated, token stored automatically
}

// Check authentication status
if (AuthApiService.isAuthenticated) {
  // User is logged in
}
```

### Cart operations
```dart
// Get current cart
final cartResult = await CartApiService.getCart();
if (cartResult['success']) {
  final cartData = cartResult['data'];
}

// Add item to cart
final addResult = await CartApiService.addItemToCart(
  productId: 'prod_123',
  quantity: 2,
);
```

### Product operations
```dart
// Get all products
final products = await ProductsApiService.fetchProducts();

// Search products
final searchResults = await ProductsApiService.searchProducts('coffee');

// Get hot deals
final hotDeals = await ProductsApiService.fetchHotDealsProducts(limit: 5);
```

## 🔄 Migration from Old Structure

### Before (scattered approach)
```dart
// Old scattered imports
import '../services/api_service.dart';
import '../services/cart_api_service.dart';
import '../modules/login/data/auth_service.dart';

// Mixed responsibilities
ApiService.authenticatedGet(url);
ApiService.fetchProducts();
CartApiService.getCart();
AuthService().sendOtp(phone);
```

### After (organized approach)
```dart
// Clean imports
import 'package:cartify/app/core/services/api_services/index.dart';

// Clear responsibilities
BaseApiService.get(url);           // Generic HTTP
ProductsApiService.fetchProducts(); // Products
CartApiService.getCart();          // Cart
AuthApiService.sendOtp(phone);     // Authentication
```

## 🎯 Benefits of This Structure

1. **Separation of Concerns**: Each service handles one specific domain
2. **Maintainability**: Easy to find and modify specific functionality
3. **Reusability**: Services can be used across different modules
4. **Testing**: Each service can be tested independently
5. **Scalability**: Easy to add new API services
6. **Clean Imports**: Single import point for all API services
7. **Consistent Patterns**: All services follow the same structure

## 📋 API Endpoints Configuration

All API endpoints are centrally configured in:
`lib/app/core/config/api_endpoints.dart`

This includes endpoints for:
- Authentication (OTP, login, logout)
- User management (profile, preferences)
- Products (CRUD, search, categories)
- Cart operations
- Orders and payments
- External API configurations

## 🔒 Security & Authentication

- All authenticated requests automatically include authorization headers
- Tokens are managed securely through `SecureStorageService`
- Public endpoints use unauthenticated methods
- Request/response logging excludes sensitive data in production

## 🚀 Future Enhancements

The structure supports easy addition of new services:
- `OrderApiService` for order management
- `PaymentApiService` for payment processing
- `NotificationApiService` for push notifications
- `AddressApiService` for address management

Each new service should follow the same pattern and extend the base functionality as needed.
