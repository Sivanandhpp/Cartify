# API Services Refactoring - Migration Guide

## 📋 Summary of Changes

The API-related files have been completely reorganized into a clean, maintainable structure. This refactoring separates concerns, improves code organization, and makes the codebase more scalable.

## 🗂️ What Was Reorganized

### Before (Scattered Structure)
```
lib/app/
├── core/
│   ├── services/
│   │   ├── api_service.dart               # Mixed responsibilities
│   │   ├── cart_api_service.dart          # Standalone cart API
│   │   └── other_services.dart
│   └── config/
│       └── api_endpoints.dart             # Basic endpoints
└── modules/
    └── authentication/login/data/
        └── auth_service.dart              # Buried authentication logic
```

### After (Organized Structure)
```
lib/app/
├── core/
│   ├── services/
│   │   ├── api_service.dart               # Clean export file + legacy compatibility
│   │   ├── api_service_legacy.dart        # Backward compatibility layer
│   │   ├── api_services/                  # 🆕 Organized API services folder
│   │   │   ├── index.dart                 # Export file for clean imports
│   │   │   ├── base_api_service.dart      # Core HTTP functionality
│   │   │   ├── auth_api_service.dart      # Authentication operations
│   │   │   ├── cart_api_service.dart      # Cart management
│   │   │   ├── products_api_service.dart  # Product operations
│   │   │   └── README.md                  # Documentation
│   │   └── other_services.dart
│   └── config/
│       └── api_endpoints.dart             # 🔄 Enhanced with comprehensive endpoints
└── modules/
    └── authentication/login/data/
        └── auth_service.dart              # 🔄 Clean wrapper using centralized API
```

## 🆕 New API Services

### 1. BaseApiService
**Purpose:** Core HTTP client functionality
- Authenticated and unauthenticated requests
- Automatic header management
- Request/response logging
- Timeout configuration
- Custom header support for external APIs

### 2. AuthApiService  
**Purpose:** Authentication operations
- OTP sending and verification
- Token management
- User profile fetching
- Logout functionality
- Authentication status checking

### 3. CartApiService
**Purpose:** Cart management
- Get user's cart
- Add/remove items
- Update item quantities
- Clear entire cart

### 4. ProductsApiService
**Purpose:** Product operations
- Fetch from external/internal APIs
- Product search and filtering
- Category-based retrieval
- Hot deals and featured products

## 🔄 Migration Steps for Developers

### Step 1: Update Imports
**Old imports:**
```dart
import '../services/api_service.dart';
import '../services/cart_api_service.dart';
import '../modules/login/data/auth_service.dart';
```

**New imports:**
```dart
// Import all services at once
import 'package:cartify/app/core/services/api_services/index.dart';

// Or import specific services
import 'package:cartify/app/core/services/api_services/auth_api_service.dart';
import 'package:cartify/app/core/services/api_services/cart_api_service.dart';
import 'package:cartify/app/core/services/api_services/products_api_service.dart';
```

### Step 2: Update Method Calls

#### Authentication
**Before:**
```dart
final authService = AuthService();
final result = await authService.sendOtp(phone);
final verifyResult = await authService.verifyOtp(phone, otp);
```

**After:**
```dart
final result = await AuthApiService.sendOtp(phone);
final verifyResult = await AuthApiService.verifyOtp(phone, otp);
```

#### Cart Operations
**Before:**
```dart
final cartResult = await CartApiService.getCart();
final addResult = await CartApiService.addItemToCart(productId: id, quantity: qty);
```

**After (same interface, but now uses BaseApiService internally):**
```dart
final cartResult = await CartApiService.getCart();
final addResult = await CartApiService.addItemToCart(productId: id, quantity: qty);
```

#### Product Operations
**Before:**
```dart
final products = await ApiService.fetchProducts();
final hotDeals = await ApiService.fetchHotDealsProducts(limit: 10);
```

**After:**
```dart
final products = await ProductsApiService.fetchProducts();
final hotDeals = await ProductsApiService.fetchHotDealsProducts(limit: 10);
```

#### Generic HTTP Requests
**Before:**
```dart
final response = await ApiService.authenticatedGet(url);
final postResponse = await ApiService.authenticatedPost(url, body);
```

**After:**
```dart
final response = await BaseApiService.get(url);
final postResponse = await BaseApiService.post(url, body);
```

## ✅ Backward Compatibility

**No breaking changes!** The old `ApiService` class still works through the legacy compatibility layer:

```dart
// This still works (but is deprecated)
import '../services/api_service.dart';
final products = await ApiService.fetchProducts(); // ✅ Works
```

## 🎯 Benefits of New Structure

1. **Separation of Concerns**: Each service handles one specific domain
2. **Better Organization**: Easy to find and modify specific functionality  
3. **Improved Maintainability**: Clean, focused code files
4. **Enhanced Reusability**: Services can be used across different modules
5. **Better Testing**: Each service can be tested independently
6. **Scalability**: Easy to add new API services
7. **Clean Imports**: Single import point for all API services
8. **Consistent Patterns**: All services follow the same structure

## 🔧 Configuration Updates

### Enhanced API Endpoints
The `api_endpoints.dart` file has been enhanced with comprehensive endpoint definitions:

```dart
// Authentication endpoints
ApiEndpoints.requestOtp
ApiEndpoints.verifyOtp
ApiEndpoints.refreshToken
ApiEndpoints.logout

// User endpoints  
ApiEndpoints.userProfile
ApiEndpoints.updateProfile
ApiEndpoints.userPreferences

// Product endpoints
ApiEndpoints.products
ApiEndpoints.productById(id)
ApiEndpoints.searchProducts
ApiEndpoints.productsByCategory(category)

// Cart endpoints
ApiEndpoints.cart
ApiEndpoints.cartItems
ApiEndpoints.cartItem(itemId)

// And more...
```

## 🚀 Future Development

### Adding New API Services
To add a new API service (e.g., `OrderApiService`):

1. Create `order_api_service.dart` in the `api_services` folder
2. Follow the same pattern as existing services
3. Use `BaseApiService` for HTTP operations
4. Add exports to `index.dart`
5. Update documentation

### Example New Service Structure:
```dart
// order_api_service.dart
import 'base_api_service.dart';
import '../../config/api_endpoints.dart';

class OrderApiService {
  static Future<Map<String, dynamic>> createOrder(Map<String, dynamic> orderData) async {
    final response = await BaseApiService.post(ApiEndpoints.createOrder, orderData);
    // Handle response...
  }
  
  static Future<List<Order>> getUserOrders() async {
    final response = await BaseApiService.get(ApiEndpoints.orders);
    // Handle response...
  }
}
```

## 🔍 Files Modified/Created

### Created:
- `lib/app/core/services/api_services/base_api_service.dart`
- `lib/app/core/services/api_services/auth_api_service.dart`
- `lib/app/core/services/api_services/cart_api_service.dart`
- `lib/app/core/services/api_services/products_api_service.dart`
- `lib/app/core/services/api_services/index.dart`
- `lib/app/core/services/api_services/README.md`
- `lib/app/core/services/api_service_legacy.dart`

### Modified:
- `lib/app/core/services/api_service.dart` (now exports organized services)
- `lib/app/core/config/api_endpoints.dart` (enhanced with comprehensive endpoints)
- `lib/app/modules/authentication/login/data/auth_service.dart` (simplified wrapper)

### Removed:
- `lib/app/core/services/cart_api_service.dart` (moved to api_services folder)

## 🧪 Testing the Changes

1. **Existing functionality should work unchanged** due to backward compatibility
2. **New imports should resolve correctly** through the index.dart exports
3. **All HTTP requests should still log properly** through BaseApiService
4. **Authentication flow should work seamlessly** through AuthApiService

## 📚 Documentation

Complete documentation is available in:
- `lib/app/core/services/api_services/README.md` - Detailed service documentation
- This migration guide - Overview of changes and migration steps

The new structure provides a solid foundation for scaling the API layer as the application grows!
