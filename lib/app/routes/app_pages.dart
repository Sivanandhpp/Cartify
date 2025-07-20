// Routes barrel export file
// Usage: import 'package:cartify/app/routes/app_pages.dart';

import 'package:get/get.dart';

import '../modules/admin_dashboard/bindings/admin_dashboard_binding.dart';
import '../modules/admin_dashboard/views/admin_dashboard_view.dart';
import '../modules/cart/bindings/cart_binding.dart';
import '../modules/cart/views/cart_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_view.dart';
import '../modules/otp_check/bindings/otp_check_binding.dart';
import '../modules/otp_check/views/otp_check_view.dart';
import '../modules/product_sheet/bindings/product_sheet_binding.dart';
import '../modules/product_sheet/views/product_sheet_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/user_dashboard/bindings/user_dashboard_binding.dart';
import '../modules/user_dashboard/views/user_dashboard_view.dart';

// ignore_for_file: constant_identifier_names

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.OTP_CHECK,
      page: () => const OtpCheckView(),
      binding: OtpCheckBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.USER_DASHBOARD,
      page: () => const UserDashboardView(),
      binding: UserDashboardBinding(),
    ),
    GetPage(
      name: _Paths.ADMIN_DASHBOARD,
      page: () => const AdminDashboardView(),
      binding: AdminDashboardBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.ONBOARDING,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: _Paths.PRODUCT_SHEET,
      page: () => const ProductSheetView(),
      binding: ProductSheetBinding(),
    ),
    GetPage(
      name: _Paths.CART,
      page: () => const CartView(),
      binding: CartBinding(),
    ),
  ];
}



