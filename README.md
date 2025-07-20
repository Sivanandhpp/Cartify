# 🛒 Cartify - Modern Flutter E-commerce App

> A production-ready Flutter e-commerce application with clean architecture, modern UI, and comprehensive cart management system.

[![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.0+-blue.svg)](https://dart.dev/)
[![GetX](https://img.shields.io/badge/GetX-State%20Management-purple.svg)](https://pub.dev/packages/get)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## 📱 About

Cartify is a comprehensive e-commerce mobile application built with Flutter and GetX architecture. It features a complete shopping experience with user authentication, product browsing, cart management, and a clean, modern interface that follows Material Design principles.

## ✨ Key Features

### 🔐 Authentication System
- **Phone-based OTP Login** - Secure authentication with phone number verification
- **Smooth Onboarding** - User-friendly introduction flow
- **Session Management** - Persistent login state

### 🛍️ Shopping Experience
- **Product Catalog** - Browse products with categories and search
- **Hot Deals Section** - Featured products and promotions
- **Real-time Cart** - Add/remove items with live count updates
- **Cart Badge** - Visual cart item count in navigation
- **Product Details** - Comprehensive product information

### 🎨 User Interface
- **Modern Design** - Clean, Material Design 3 interface
- **Dark/Light Theme** - Complete theming system with user preference
- **Responsive Layout** - Works perfectly on all screen sizes
- **Smooth Animations** - Polished user experience
- **Bottom Navigation** - Intuitive app navigation

### 🏗️ Architecture
- **GetX Architecture** - Controllers, Views, and Bindings pattern
- **Centralized Core** - Reusable services and utilities
- **Clean Code** - Well-structured, maintainable codebase
- **Single Source Config** - Easy branding and customization

## 🚀 Quick Start

### Prerequisites
- Flutter SDK 3.0+
- Dart 3.0+
- Android Studio / VS Code
- iOS Simulator / Android Emulator

### Installation

```bash
# 1. Clone the repository
git clone https://github.com/sivanandhpp/cartify-ecommerce.git
cd cartify-ecommerce

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
├── main.dart                    # App entry point
├── app/
│   ├── core/                    # 🔧 Core functionality
│   │   ├── config/              # App configuration
│   │   ├── constants/           # App constants & spacing
│   │   ├── models/              # Data models
│   │   ├── services/            # Business logic services
│   │   ├── theme/               # Theming system
│   │   ├── utils/               # Utility functions
│   │   └── widgets/             # Reusable widgets
│   ├── modules/                 # 📱 Feature modules
│   │   ├── onboarding/          # App introduction
│   │   ├── login/               # Authentication
│   │   ├── otp_check/           # OTP verification
│   │   ├── user_dashboard/      # Main shopping interface
│   │   └── cart/                # Shopping cart
│   └── routes/                  # 🛣️ App routing
assets/
├── images/                      # Image assets
└── videos/                      # Video assets
```

## 🛠️ Core Features Breakdown

### 🔄 State Management (GetX)
- **Reactive Updates** - Automatic UI updates when data changes
- **Dependency Injection** - Clean service management
- **Route Management** - Type-safe navigation
- **Storage Management** - Persistent data storage

### 🛒 Cart Management
- **Real-time Updates** - Cart count updates instantly
- **Persistent Storage** - Cart items saved locally
- **Add/Remove Actions** - Smooth cart operations
- **Visual Feedback** - Cart badge shows item count

### 🎨 Theming System
- **Material Design 3** - Modern, consistent design language
- **Dark/Light Modes** - User-configurable theme preference
- **Custom Colors** - Brand-specific color scheme
- **Typography** - Consistent text styling throughout

## 🔧 Configuration

### App Identity (Easy Rebranding)
Update app name, package, and branding in one place:

```dart
// lib/app/core/config/app_identity.dart
class AppIdentity {
  static const String appName = 'Cartify';
  static const String packageName = 'com.example.cartify';
  static const String companyName = 'Your Company';
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

## � Screenshots

| Onboarding | Login | Products | Cart |
|------------|-------|----------|------|
| ![Onboarding](screenshots/onboarding.png) | ![Login](screenshots/login.png) | ![Products](screenshots/products.png) | ![Cart](screenshots/cart.png) |

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Widget tests
flutter test test/widget_test.dart
```

## 📦 Build for Production

```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS
flutter build ios --release
```

## 🤝 Contributing

1. **Fork the repository**
2. **Create your feature branch** (`git checkout -b feature/amazing-feature`)
3. **Commit your changes** (`git commit -m 'Add amazing feature'`)
4. **Push to the branch** (`git push origin feature/amazing-feature`)
5. **Open a Pull Request**

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Flutter Team** - For the amazing framework
- **GetX Community** - For the powerful state management solution
- **Material Design** - For the design system
- **Open Source Community** - For inspiration and contributions

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/sivanandhpp/cartify-ecommerce/issues)
- **Discussions**: [GitHub Discussions](https://github.com/sivanandhpp/cartify-ecommerce/discussions)
- **Email**: support@yourcompany.com

---

**⭐ If you found this project helpful, please give it a star!**

### Core System
- **AppIdentity**: Central configuration for app branding and identity
- **LogService**: Production-level logging with structured output
- **NotificationService**: Global notification system with consistent styling
- **CartService**: Complete shopping cart management with reactive updates
- **ThemeService**: Dynamic theme switching with persistence

### Production Ready
- ✅ Consistent naming conventions
- ✅ Comprehensive error handling
- ✅ Type safety with proper model classes
- ✅ Clean separation of concerns
- ✅ Efficient state management
- ✅ Memory management with proper disposal

## 📦 Tech Stack

- **Framework**: Flutter 3.8.1+
- **State Management**: GetX 4.7.2
- **Storage**: GetStorage 2.1.1
- **Architecture**: Clean Architecture with GetX pattern

### Security
- ✅ Input validation
- ✅ Secure storage implementation
- ✅ Error message sanitization

## 🔧 Configuration

### Environment Setup

Update `lib/app/core/config/app_config.dart` for different environments:

```dart
class AppConfig {
  static const String baseUrl = 'YOUR_API_BASE_URL';
  static const bool isDebug = false; // Set to false for production
  static const bool enableLogging = false; // Disable in production
}
```

**Built with ❤️ using Flutter and GetX**

---

**⭐ If you found this project helpful, please give it a star!**

<!--
GitHub Repository Setup:
Description: 🛒 Modern Flutter e-commerce app with GetX architecture, featuring cart management, authentication, and Material Design 3 theming
Topics: flutter, dart, ecommerce, getx, material-design, mobile-app, cart-management, authentication, otp-login, shopping-app, cross-platform, android, ios, state-management, reactive-programming
-->
