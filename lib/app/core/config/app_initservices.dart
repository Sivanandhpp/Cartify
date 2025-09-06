import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:cartify/app/core/index.dart';
import 'package:get/get.dart';

/// Service Initialization
/// 
/// This file handles the initialization of all core services required by the
/// Cartify application. Services are initialized in dependency order to ensure
/// proper functionality throughout the app lifecycle.

/// Initialize all application services
/// 
/// This function sets up all the core services that the app depends on.
/// Services are initialized in a specific order to handle dependencies correctly.
/// 
/// **Initialization Order:**
/// 1. Core services (Error, Storage, Theme, User)
/// 2. Network service (ApiClient)
/// 3. Dependent services (Auth, Cart, Product, etc.)
Future<void> initServices() async {
  LogService.info('🚀 Starting service initialization...');

  try {
    // ===== STEP 1: Initialize Core Independent Services =====
    LogService.info('📦 Initializing core services...');
    
    // User controller for global user state management
    Get.put(UserController(), permanent: true);
    LogService.info('✅ UserController initialized');
    
    // Error handling service
    Get.put(ErrorService(), permanent: true);
    LogService.info('✅ ErrorService initialized');
    
    // Local storage service
    Get.put(StorageService(), permanent: true);
    LogService.info('✅ StorageService initialized');
    
    // Theme management service
    Get.put(ThemeService(), permanent: true);
    LogService.info('✅ ThemeService initialized');

    // ===== STEP 2: Initialize Secure Storage =====
    LogService.info('🔐 Initializing secure storage...');
    
    // Secure storage for sensitive data (tokens, user credentials)
    const secureStorage = FlutterSecureStorage(
      aOptions: AndroidOptions(
        encryptedSharedPreferences: true, // Use encrypted shared preferences
      ),
      iOptions: IOSOptions(
        accessibility: KeychainAccessibility.first_unlock_this_device,
      ),
    );
    LogService.info('✅ Secure storage configured');

    // ===== STEP 3: Initialize Network Service =====
    LogService.info('🌐 Initializing network services...');
    
    // API client with secure storage for token management
    Get.put(ApiClient(secureStorage), permanent: true);
    LogService.info('✅ ApiClient initialized');

    // ===== STEP 4: Initialize Dependent Services =====
    LogService.info('🔧 Initializing dependent services...');
    
    // Authentication service (depends on ApiClient and SecureStorage)
    Get.put(
      AuthenticationService(Get.find<ApiClient>(), secureStorage),
      permanent: true,
    );
    LogService.info('✅ AuthenticationService initialized');
    
    // Shopping cart service
    Get.put(CartService(Get.find<ApiClient>()), permanent: true);
    LogService.info('✅ CartService initialized');
    
    // Product catalog service
    Get.put(ProductService(Get.find<ApiClient>()), permanent: true);
    LogService.info('✅ ProductService initialized');
    
    // Order management service
    Get.put(OrderService(Get.find<ApiClient>()), permanent: true);
    LogService.info('✅ OrderService initialized');
    
    // User profile and address service
    Get.put(UserService(Get.find<ApiClient>()), permanent: true);
    LogService.info('✅ UserService initialized');
    
    // Product review service
    Get.put(ReviewService(Get.find<ApiClient>()), permanent: true);
    LogService.info('✅ ReviewService initialized');
    
    // Dashboard service
    Get.put(DashboardService(Get.find<ApiClient>()), permanent: true);
    LogService.info('✅ DashboardService initialized');

    // ===== SERVICE INITIALIZATION COMPLETE =====
    LogService.info('🎉 All services initialized successfully!');
    LogService.info('📊 Total services initialized: 10');
    
  } catch (e, stackTrace) {
    // ===== HANDLE INITIALIZATION ERRORS =====
    LogService.error('❌ Service initialization failed', {
      'error': e.toString(),
      'stackTrace': stackTrace.toString(),
    });
    
    // Re-throw the error to prevent app from starting with incomplete services
    throw Exception('Failed to initialize app services: $e');
  }
}

/// Check if all critical services are properly initialized
/// 
/// This function verifies that all essential services are available
/// and properly initialized before the app starts.
bool areServicesInitialized() {
  final criticalServices = [
    () => Get.isRegistered<UserController>(),
    () => Get.isRegistered<ErrorService>(),
    () => Get.isRegistered<StorageService>(),
    () => Get.isRegistered<ThemeService>(),
    () => Get.isRegistered<ApiClient>(),
    () => Get.isRegistered<AuthenticationService>(),
    () => Get.isRegistered<CartService>(),
    () => Get.isRegistered<ProductService>(),
    () => Get.isRegistered<OrderService>(),
    () => Get.isRegistered<UserService>(),
  ];

  for (final serviceCheck in criticalServices) {
    if (!serviceCheck()) {
      LogService.error('❌ Critical service not initialized');
      return false;
    }
  }

  LogService.info('✅ All critical services are properly initialized');
  return true;
}

/// Clean up all services (useful for testing or app restart)
/// 
/// This function properly disposes of all services and clears
/// the GetX service registry.
Future<void> cleanupServices() async {
  LogService.info('🧹 Cleaning up services...');
  try {
    // Reset GetX completely
    Get.reset();
    LogService.info('✅ Services cleanup completed');
  } catch (e) {
    LogService.error('❌ Error during services cleanup', e);
  }
}