# 🛒 Cartify - Modern Flutter E-commerce App

> A production-ready Flutter e-commerce application with clean architecture, modern UI, comprehensive cart management, and order processing system.

[![Flutter](https://img.shields.io/badge/Flutter-3.8.1+-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.8.1+-blue.svg)](https://dart.dev/)
[![GetX](https://img.shields.io/badge/GetX-4.7.2-purple.svg)](https://pub.dev/packages/get)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## 📱 About

Cartify is a comprehensive e-commerce mobile application built with Flutter and GetX architecture. It features a complete shopping experience with user authentication, product browsing, cart management, order processing, and a clean, modern interface that follows Material Design 3 principles. The app includes advanced features like real-time cart updates, secure storage, theme management, and a complete order management system.

## ✨ Key Features

### 🔐 Authentication System
- **Phone-based OTP Login** - Secure authentication with phone number verification
- **Smooth Onboarding** - User-friendly introduction flow with multiple pages
- **Session Management** - Persistent login state with secure storage
- **User Profile Management** - Complete user data handling

### 🛍️ Shopping Experience
- **Product Catalog** - Browse products with categories and advanced search
- **Hot Deals Section** - Featured products and promotional banners
- **Real-time Cart** - Add/remove items with live count updates
- **Cart Badge** - Visual cart item count in navigation
- **Product Details** - Comprehensive product information with reviews
- **Order Management** - Complete order lifecycle from creation to tracking
- **Order History** - View past orders with detailed information

### 🛒 Advanced Cart Features
- **Persistent Storage** - Cart items saved locally with secure storage
- **Real-time Updates** - Instant UI updates when cart changes
- **Quantity Management** - Easy increase/decrease item quantities
- **Cart Calculations** - Automatic total, tax, and shipping calculations
- **Cart Validation** - Inventory checks and availability verification

### 📦 Order Processing
- **Order Creation** - Seamless order placement with multiple payment options
- **Order Tracking** - Real-time order status updates
- **Order Items Management** - Detailed order item tracking and updates
- **Order History** - Complete order management with status tracking

### 🎨 User Interface
- **Material Design 3** - Latest design system implementation
- **Dark/Light Theme** - Complete theming system with user preference
- **Responsive Layout** - Works perfectly on all screen sizes
- **Smooth Animations** - Polished user experience with fluid transitions
- **Bottom Navigation** - Intuitive app navigation structure
- **Clean Image Handling** - Optimized image loading with caching

### 🏗️ Architecture & Services
- **GetX Architecture** - Controllers, Views, and Bindings pattern
- **Clean Architecture** - Well-structured, maintainable codebase
- **Service Layer** - Comprehensive business logic separation
- **API Integration** - Complete REST API client with error handling
- **Centralized Configuration** - Easy branding and customization
- **Logging System** - Production-level logging with structured output
- **Error Handling** - Comprehensive error management system

### 🔒 Security & Storage
- **Secure Storage** - Flutter Secure Storage for sensitive data
- **Input Validation** - Comprehensive data validation
- **Error Sanitization** - Safe error message handling
- **Session Security** - Secure authentication token management

## 🚀 Quick Start

### Prerequisites
- Flutter SDK 3.8.1+
- Dart 3.8.1+
- Android Studio / VS Code
- iOS Simulator / Android Emulator

### Installation

```bash
# 1. Clone the repository
git clone https://github.com/sivanandhpp/cartify.git
cd Cartify

# 2. Install dependencies
flutter pub get

# 3. Run the app
flutter run
```

### Run on specific platform
```bash
# Android
flutter run -d android

# iOS
flutter run -d ios

# Web
flutter run -d chrome
```

## 📁 Project Structure

```
lib/
├── main.dart                           # App entry point with service initialization
├── app/
│   ├── core/                          # 🔧 Core functionality
│   │   ├── config/                    # App configuration
│   │   │   ├── app_identity.dart      # Centralized app branding
│   │   │   ├── app_initservices.dart  # Service initialization
│   │   │   └── app_environment.dart   # Environment settings
│   │   ├── constants/                 # App constants & spacing
│   │   ├── models/                    # Data models
│   │   │   ├── user/                  # User-related models
│   │   │   ├── product/               # Product models
│   │   │   ├── cart/                  # Cart models
│   │   │   ├── order/                 # Order models (NEW)
│   │   │   ├── dashboard/             # Dashboard models
│   │   │   └── onboarding/            # Onboarding models
│   │   ├── services/                  # Business logic services
│   │   │   ├── authentication/        # Auth services
│   │   │   ├── user/                  # User management
│   │   │   ├── product/               # Product services
│   │   │   ├── cart/                  # Cart management
│   │   │   ├── order/                 # Order processing (NEW)
│   │   │   ├── review/                # Review system
│   │   │   ├── dashboard/             # Dashboard services
│   │   │   ├── api_client.dart        # HTTP client
│   │   │   ├── api_clean_url.dart     # URL cleaning utility (NEW)
│   │   │   ├── log_service.dart       # Logging system
│   │   │   ├── error_service.dart     # Error handling
│   │   │   ├── notification_service.dart # Notifications
│   │   │   ├── theme_service.dart     # Theme management
│   │   │   └── storage_service.dart   # Secure storage
│   │   ├── theme/                     # Material Design 3 theming
│   │   ├── utils/                     # Utility functions
│   │   ├── widgets/                   # Reusable widgets
│   │   └── index.dart                 # Core exports
│   ├── modules/                       # 📱 Feature modules
│   │   ├── onboarding/                # App introduction
│   │   ├── login/                     # Authentication
│   │   ├── otp_check/                 # OTP verification
│   │   ├── user_dashboard/            # Main shopping interface
│   │   └── cart/                      # Shopping cart
│   └── routes/                        # 🛣️ App routing
├── scripts/                           # 🔧 Project utilities
│   ├── quick_rename.ps1              # Project renaming script
│   └── test_rename.ps1               # Rename testing script
assets/
├── images/                           # Image assets
└── videos/                           # Video assets
```

## 🛠️ Core Features Breakdown

### 🔄 State Management (GetX)
- **Reactive Updates** - Automatic UI updates when data changes
- **Dependency Injection** - Clean service management with Get.put()
- **Route Management** - Type-safe navigation with GetX routing
- **Storage Management** - Persistent data storage with GetStorage
- **Controller Pattern** - Organized state management with controllers

### 🛒 Cart Management
- **Real-time Updates** - Cart count updates instantly across the app
- **Persistent Storage** - Cart items saved locally with secure storage
- **Add/Remove Actions** - Smooth cart operations with quantity management
- **Visual Feedback** - Cart badge shows item count in bottom navigation
- **Cart Calculations** - Automatic total calculations with tax and shipping

### 📦 Order Processing System
- **Order Creation** - Complete order placement workflow
- **Order Tracking** - Real-time status updates and tracking
- **Order Items** - Detailed item management within orders
- **Order History** - Complete order history with filtering options
- **Status Management** - Order lifecycle management from placed to delivered

### 🎨 Theming System
- **Material Design 3** - Modern, consistent design language
- **Dark/Light Modes** - User-configurable theme preference with persistence
- **Custom Colors** - Brand-specific color scheme throughout the app
- **Typography** - Consistent text styling with Material 3 typography
- **Component Theming** - Consistent styling for all UI components

### 🔌 API Integration
- **RESTful API Client** - Complete HTTP client with Dio integration
- **Error Handling** - Comprehensive API error management
- **URL Cleaning** - Automatic URL sanitization for images and endpoints
- **Request/Response Logging** - Detailed API interaction logging
- **Authentication Headers** - Automatic token management for secured endpoints

### 🗄️ Data Management
- **Model Classes** - Type-safe data models for all entities
- **JSON Serialization** - Automatic JSON parsing and serialization
- **Data Validation** - Input validation and sanitization
- **Cache Management** - Efficient data caching with GetStorage
- **Secure Storage** - Sensitive data protection with Flutter Secure Storage

## 🔧 Configuration

### App Identity (Easy Rebranding)
Update app name, package, and branding in one place:

```dart
// lib/app/core/config/app_identity.dart
class AppIdentity {
  static const String appName = 'Cartify';
  static const String packageName = 'cartify';
  static const String displayName = 'Cartify - Smart Shopping';
  static const String companyName = 'Cartify Development Team';
  static const String developerEmail = 'dev@cartify.com';
  static const String supportEmail = 'support@cartify.com';
  static const String supportPhone = '+91 98765 43210';
}
```

### Environment Settings
```dart
// lib/app/core/config/app_environment.dart
class AppEnvironment {
  static const bool isProduction = false;
  static const bool enableLogging = true;
  static const String apiBaseUrl = 'https://api.example.com';
}
```

### Quick Project Renaming
Use the provided PowerShell scripts for easy project renaming:

```bash
# Test rename functionality (dry run)
.\scripts\test_rename.ps1

# Perform actual rename
.\scripts\quick_rename.ps1 -NewPackageName "myapp" -NewDisplayName "My App"
```

## 📦 Dependencies

### Core Dependencies
```yaml
dependencies:
  flutter: sdk
  cupertino_icons: ^1.0.8
  get: ^4.7.2                    # State management & routing
  get_storage: ^2.1.1           # Local storage
  http: ^1.4.0                  # HTTP client
  dio: ^5.8.0+1                 # Advanced HTTP client
  flutter_secure_storage: ^9.2.4 # Secure storage

UI & UX:
  cached_network_image: ^3.4.1  # Image caching
  shimmer: ^3.0.0               # Loading animations
  fl_chart: ^0.68.0             # Charts and graphs

Utilities:
  intl: ^0.20.2                 # Internationalization
  url_launcher: ^6.3.2          # URL launching
  image_picker: ^1.2.0          # Image selection
  permission_handler: ^12.0.1   # Permissions
  mime: ^2.0.0                  # MIME type detection
```

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Widget tests
flutter test test/widget_test.dart

# Test rename functionality
.\scripts\test_rename.ps1
```

## 📦 Build for Production

```bash
# Android APK
flutter build apk --release

# Android App Bundle (recommended for Play Store)
flutter build appbundle --release

# iOS
flutter build ios --release

# Web
flutter build web --release
```

## 🚀 Development Workflow

### Service Initialization
The app follows a structured service initialization pattern:

```dart
// Services are initialized in dependency order
await initServices(); // in main.dart

// Order: Core → Network → Dependent services
// 1. UserController, LogService, ErrorService
// 2. ApiClient, StorageService, ThemeService  
// 3. AuthService, CartService, ProductService, etc.
```

### Adding New Features
1. **Create Model** - Add data models in `lib/app/core/models/`
2. **Create Service** - Add business logic in `lib/app/core/services/`
3. **Create Controller** - Add state management in feature modules
4. **Create Views** - Add UI components in feature modules
5. **Update Routes** - Register new routes in `app_pages.dart`
6. **Export Components** - Add exports to `lib/app/core/index.dart`

## 🤝 Contributing

1. **Fork the repository**
2. **Create your feature branch** (`git checkout -b feature/amazing-feature`)
3. **Commit your changes** (`git commit -m 'Add amazing feature'`)
4. **Push to the branch** (`git push origin feature/amazing-feature`)
5. **Open a Pull Request**

### Code Style
- Follow Dart conventions and linting rules
- Use meaningful variable and function names
- Add documentation for public APIs
- Maintain consistent file organization
- Write tests for new features

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/sivanandhpp/cartify/issues)
- **Discussions**: [GitHub Discussions](https://github.com/sivanandhpp/cartify/discussions)
- **Email**: dev@cartify.com

## 🙏 Acknowledgments

- **Flutter Team** - For the amazing framework
- **GetX Community** - For the powerful state management solution
- **Material Design** - For the comprehensive design system
- **Open Source Community** - For inspiration and contributions

## 🏆 Project Highlights

### Production Ready Features
- ✅ Clean Architecture with GetX pattern
- ✅ Comprehensive error handling and logging
- ✅ Secure data storage implementation
- ✅ Type safety with proper model classes
- ✅ Efficient state management with reactive updates
- ✅ Memory management with proper disposal
- ✅ Complete order processing system
- ✅ Advanced cart management with persistence
- ✅ Professional theming with Material Design 3
- ✅ Easy project rebranding and configuration

### Core System Components
- **AppIdentity**: Central configuration for app branding and identity
- **LogService**: Production-level logging with structured output
- **NotificationService**: Global notification system with consistent styling
- **CartService**: Complete shopping cart management with reactive updates
- **OrderService**: Comprehensive order processing and tracking
- **ThemeService**: Dynamic theme switching with persistence
- **ApiClient**: Robust HTTP client with error handling and logging

---

**Built with ❤️ using Flutter and GetX**

**⭐ If you found this project helpful, please give it a star!**

<!--
GitHub Repository Setup:
Description: 🛒 Modern Flutter e-commerce app with GetX architecture, featuring complete cart management, order processing, authentication, and Material Design 3 theming
Topics: flutter, dart, ecommerce, getx, material-design, mobile-app, cart-management, order-processing, authentication, otp-login, shopping-app, cross-platform, android, ios, state-management, reactive-programming, secure-storage, api-integration
-->
