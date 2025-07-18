# Cartify E-commerce App

A modern, production-ready Flutter e-commerce application built with GetX architecture.

## 📱 Features

- **Onboarding Flow**: Smooth introduction to the app
- **Authentication**: Phone-based OTP login system
- **Product Catalog**: Browse products with hot deals and categories
- **Shopping Cart**: Add, remove, and manage cart items
- **User Dashboard**: Intuitive navigation and product discovery
- **Admin Dashboard**: Administrative features for product management
- **Responsive Design**: Works seamlessly across different screen sizes

## 🏗️ Architecture

This project follows clean architecture principles with GetX for state management:

```
lib/
├── app/
│   ├── core/                 # Core functionality
│   │   ├── config/          # App configuration
│   │   ├── constants/       # App constants and strings
│   │   ├── model/           # Data models
│   │   ├── services/        # Business logic services
│   │   ├── themes/          # UI themes and styles
│   │   └── widgets/         # Reusable widgets
│   ├── modules/             # Feature modules
│   │   ├── login/           # Login module
│   │   ├── onboarding/      # Onboarding module
│   │   ├── user_dashboard/  # User dashboard
│   │   └── ...              # Other modules
│   └── routes/              # App routing
└── main.dart                # App entry point
```

### Key Architecture Patterns:

- **GetX Architecture**: Controllers, Views, and Bindings
- **Service Layer**: Centralized business logic
- **Repository Pattern**: Data access abstraction
- **Dependency Injection**: GetX dependency management

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (≥3.8.1)
- Dart SDK
- Android Studio / VS Code
- Android SDK / Xcode (for iOS)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd ecommerce
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

## 📦 Dependencies

### Core Dependencies
- `get: ^4.7.2` - State management and dependency injection
- `get_storage: ^2.1.1` - Local storage solution

### Development Dependencies
- `flutter_test` - Testing framework

## 🏭 Production Readiness

### Code Quality
- ✅ Consistent naming conventions
- ✅ Proper error handling with centralized ErrorService
- ✅ Comprehensive logging with LogService
- ✅ Type safety with proper model classes
- ✅ Clean separation of concerns

### Performance
- ✅ Lazy loading with GetX
- ✅ Efficient state management
- ✅ Optimized widget rebuilds
- ✅ Memory management with proper disposal

### Scalability
- ✅ Modular architecture
- ✅ Service-oriented design
- ✅ Configurable environment settings
- ✅ Extensible routing system

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
