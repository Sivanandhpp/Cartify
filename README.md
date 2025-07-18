# Cartify E-commerce App

A modern, production-ready Flutter e-commerce application built with GetX architecture.

> � **For complete documentation, architecture details, and development guide, see [COMPLETE_PROJECT_GUIDE.md](COMPLETE_PROJECT_GUIDE.md)**

## 📱 Quick Overview

- **Onboarding Flow**: Smooth introduction to the app
- **Authentication**: Phone-based OTP login system
- **Product Catalog**: Browse products with hot deals and categories
- **Shopping Cart**: Add, remove, and manage cart items with reactive updates
- **User Dashboard**: Intuitive navigation and product discovery
- **Admin Dashboard**: Administrative features for product management
- **Responsive Design**: Works seamlessly across different screen sizes
- **Dark/Light Theme**: Complete theming system with persistence

## 🚀 Quick Start

```bash
# Clone and setup
git clone <repository-url>
cd ecommerce
flutter pub get

# Run the app
flutter run
```

## 🏗️ Architecture Highlights

- **GetX Architecture**: Controllers, Views, and Bindings
- **Centralized Core System**: Production-ready services and utilities
- **Single Source Configuration**: Easy project renaming and branding
- **Professional Theming**: Material Design 3 with dark mode support
- **Enterprise-Level Logging**: Structured logging with multiple levels
- **Reactive Cart System**: Real-time cart management with persistence

## 📚 Documentation

- **[Complete Project Guide](COMPLETE_PROJECT_GUIDE.md)** - Comprehensive documentation covering:
  - Core architecture and features
  - Service implementations
  - Theming system
  - Project renaming guide
  - Import guidelines
  - Production readiness
  - Best practices

## 🎯 Key Features

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

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
