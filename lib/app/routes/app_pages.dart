import 'package:get/get.dart';

import '../modules/admin_panel/admin_dashboard/bindings/admin_dashboard_binding.dart';
import '../modules/admin_panel/admin_dashboard/views/admin_dashboard_view.dart';
import '../modules/authentication/login/bindings/login_binding.dart';
import '../modules/authentication/login/views/login_view.dart';
import '../modules/authentication/otp_check/bindings/otp_check_binding.dart';
import '../modules/authentication/otp_check/views/otp_check_view.dart';
import '../modules/buyer_panel/buyer_dashboard/bindings/buyer_dashboard_binding.dart';
import '../modules/buyer_panel/buyer_dashboard/views/buyer_dashboard_view.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_view.dart';
import '../modules/seller_panel/seller_dashboard/bindings/seller_dashboard_binding.dart';
import '../modules/seller_panel/seller_dashboard/views/seller_dashboard_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';

// Routes barrel export file
// Usage: import 'package:cartify/app/routes/app_pages.dart';

// ignore_for_file: constant_identifier_names

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.ONBOARDING,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.OTP_CHECK,
      page: () => const OtpCheckView(),
      binding: OtpCheckBinding(),
    ),
    GetPage(
      name: _Paths.SELLER_DASHBOARD,
      page: () => const SellerDashboardView(),
      binding: SellerDashboardBinding(),
    ),
    GetPage(
      name: _Paths.ADMIN_DASHBOARD,
      page: () => const AdminDashboardView(),
      binding: AdminDashboardBinding(),
    ),
    GetPage(
      name: _Paths.BUYER_DASHBOARD,
      page: () => const BuyerDashboardView(),
      binding: BuyerDashboardBinding(),
    ),
  ];
}
