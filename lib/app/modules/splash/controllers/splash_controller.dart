// Core imports (absolute)
import 'package:cartify/app/core/index.dart';
import 'package:cartify/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SplashController extends GetxController {
  // Storage services
  final GetStorage _storage = GetStorage();

  // Authentication services
  final AuthApiService _authApiService = Get.find<AuthApiService>();
  final AuthStorageService _authStorageService = Get.find<AuthStorageService>();
  final UserApiService _userApiService = Get.find<UserApiService>();

  // Observable state
  final RxBool isInitializing = true.obs;
  final RxString currentStep = 'Initializing...'.obs;
  final RxDouble progress = 0.0.obs;

  @override
  Future<void> onReady() async {
    super.onReady();
    await _initializeApp();
  }

  /// Initialize the app with proper state management
  Future<void> _initializeApp() async {
    try {
      LogService.info('Starting app initialization');

      // Step 1: Initialize core services
      await _initializeCoreServices();

      // Step 2: Check onboarding status
      final isBoarded = await _checkOnboardingStatus();

      if (!isBoarded) {
        await Future.delayed(const Duration(milliseconds: 500));
        Get.offAllNamed(Routes.ONBOARDING);
        return;
      }

      // Step 3: Check authentication status
      final isAuthenticated = await _checkAuthenticationStatus();

      if (!isAuthenticated) {
        await Future.delayed(const Duration(milliseconds: 500));
        Get.offAllNamed(Routes.LOGIN);
        return;
      }

      // Step 4: Validate and refresh tokens if needed
      final isValidSession = await _validateSession();

      if (!isValidSession) {
        await Future.delayed(const Duration(milliseconds: 500));
        Get.offAllNamed(Routes.LOGIN);
        return;
      }

      // Step 5: Navigate to appropriate dashboard
      await Future.delayed(const Duration(milliseconds: 500));
      _navigateBasedOnRole();
    } catch (e) {
      LogService.error('Error during app initialization: $e');
      ErrorService.showError(
        'Failed to initialize app. Please restart the application.',
      );

      // Fallback to login on error
      await Future.delayed(const Duration(seconds: 2));
      Get.offAllNamed(Routes.LOGIN);
    } finally {
      isInitializing.value = false;
    }
  }

  /// Initialize core application services
  Future<void> _initializeCoreServices() async {
    try {
      // Initialize GetStorage if not already initialized
      await GetStorage.init();

      // Initialize authentication storage service
      await _authStorageService.onInit();

      LogService.info('Core services initialized successfully');
    } catch (e) {
      LogService.error('Failed to initialize core services: $e');
      throw Exception('Core services initialization failed');
    }
  }

  /// Check if user has completed onboarding
  Future<bool> _checkOnboardingStatus() async {
    try {
      final isBoarded = _storage.read(AppConfig.onboardingStatusKey) ?? false;
      LogService.info(
        'Onboarding status: ${isBoarded ? 'completed' : 'pending'}',
      );
      return isBoarded;
    } catch (e) {
      LogService.error('Error checking onboarding status: $e');
      return false;
    }
  }

  /// Check if user is authenticated
  Future<bool> _checkAuthenticationStatus() async {
    try {
      final isLoggedIn = _authStorageService.isLoggedIn;
      final hasTokens = _authStorageService.currentTokens != null;

      LogService.info(
        'Authentication status: logged in = $isLoggedIn, has tokens = $hasTokens',
      );
      return isLoggedIn && hasTokens;
    } catch (e) {
      LogService.error('Error checking authentication status: $e');
      return false;
    }
  }

  /// Validate current session and refresh tokens if needed
  Future<bool> _validateSession() async {
    try {
      final currentTokens = _authStorageService.currentTokens;
      if (currentTokens == null) {
        LogService.warning('No authentication tokens found');
        return false;
      }

      // Try to refresh tokens to validate session
      final newTokens = await _authApiService.refreshTokens();

      if (newTokens != null) {
        // Update stored tokens
        await _authStorageService.saveAuthTokens(newTokens);

        // Refresh user profile
        final userProfile = await _userApiService.getUserProfile();
        if (userProfile != null) {
          await _authStorageService.saveUserProfile(userProfile);
        }

        LogService.info('Session validated and refreshed successfully');
        return true;
      } else {
        LogService.warning('Failed to refresh tokens - session invalid');
        await _authStorageService.clearAuthData();
        return false;
      }
    } catch (e) {
      LogService.error('Error validating session: $e');
      await _authStorageService.clearAuthData();
      return false;
    }
  }

  /// Navigate user based on their role
  void _navigateBasedOnRole() {
    final user = _authStorageService.currentUser;
    final userRole = user?.role ?? 'BUYER';

    LogService.info('Navigating user based on role: $userRole');

    switch (userRole.toUpperCase()) {
      case 'ADMIN':
        Get.offAllNamed(Routes.ADMIN_DASHBOARD);
        break;
      case 'SELLER':
        Get.offAllNamed(Routes.SELLER_DASHBOARD);
        break;
      case 'BUYER':
      default:
        Get.offAllNamed(Routes.BUYER_DASHBOARD);
        break;
    }
  }

  /// Force logout and redirect to login
  Future<void> forceLogout() async {
    try {
      LogService.info('Force logout initiated');
      await _authStorageService.clearAuthData();
      Get.offAllNamed(Routes.LOGIN);
    } catch (e) {
      LogService.error('Error during force logout: $e');
      Get.offAllNamed(Routes.LOGIN);
    }
  }

  /// Retry initialization (for error recovery)
  Future<void> retryInitialization() async {
    isInitializing.value = true;
    progress.value = 0.0;
    currentStep.value = 'Retrying initialization...';

    await _initializeApp();
  }
}
