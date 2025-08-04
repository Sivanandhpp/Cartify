import 'package:get/get.dart';

import '../modules/admin_dashboard/bindings/admin_dashboard_binding.dart';
import '../modules/admin_dashboard/views/admin_dashboard_view.dart';
import '../modules/authentication/login/bindings/login_binding.dart';
import '../modules/authentication/login/views/login_view.dart';
import '../modules/authentication/otp_check/bindings/otp_check_binding.dart';
import '../modules/authentication/otp_check/views/otp_check_view.dart';
import '../modules/buyer_panel/buyer_cart/bindings/buyer_cart_binding.dart';
import '../modules/buyer_panel/buyer_cart/views/buyer_cart_view.dart';
import '../modules/buyer_panel/buyer_categories/bindings/buyer_categories_binding.dart';
import '../modules/buyer_panel/buyer_categories/views/buyer_categories_view.dart';
import '../modules/buyer_panel/buyer_dashboard/bindings/buyer_dashboard_binding.dart';
import '../modules/buyer_panel/buyer_dashboard/views/buyer_dashboard_view.dart';
import '../modules/buyer_panel/buyer_home/bindings/buyer_home_binding.dart';
import '../modules/buyer_panel/buyer_home/views/buyer_home_view.dart';
import '../modules/buyer_panel/buyer_offers/bindings/buyer_offers_binding.dart';
import '../modules/buyer_panel/buyer_offers/views/buyer_offers_view.dart';
import '../modules/buyer_panel/buyer_profile/bindings/buyer_profile_binding.dart';
import '../modules/buyer_panel/buyer_profile/views/buyer_profile_view.dart';
import '../modules/buyer_panel/buyer_wishlist/bindings/buyer_wishlist_binding.dart';
import '../modules/buyer_panel/buyer_wishlist/views/buyer_wishlist_view.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_view.dart';
import '../modules/seller_panel/seller_dashboard/bindings/seller_dashboard_binding.dart';
import '../modules/seller_panel/seller_dashboard/views/seller_dashboard_view.dart';
import '../modules/seller_panel/tab_bar/bindings/tab_bar_binding.dart';
import '../modules/seller_panel/tab_bar/views/tab_bar_view.dart';
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
      name: _Paths.ADMIN_DASHBOARD,
      page: () => const AdminDashboardView(),
      binding: AdminDashboardBinding(),
    ),
    GetPage(
      name: _Paths.CART,
      page: () => const BuyerCartView(),
      binding: BuyerCartBinding(),
    ),
    GetPage(
      name: _Paths.BUYER_DASHBOARD,
      page: () => BuyerDashboardView(),
      binding: BuyerDashboardBinding(),
    ),
    GetPage(
      name: _Paths.BUYER_HOME,
      page: () => const BuyerHomeView(),
      binding: BuyerHomeBinding(),
    ),
    GetPage(
      name: _Paths.BUYER_CATEGORIES,
      page: () => const BuyerCategoriesView(),
      binding: BuyerCategoriesBinding(),
    ),
    GetPage(
      name: _Paths.BUYER_OFFERS,
      page: () => const BuyerOffersView(),
      binding: BuyerOffersBinding(),
    ),
    GetPage(
      name: _Paths.BUYER_PROFILE,
      page: () => const BuyerProfileView(),
      binding: BuyerProfileBinding(),
    ),
    GetPage(
      name: _Paths.BUYER_WISHLIST,
      page: () => const BuyerWishlistView(),
      binding: BuyerWishlistBinding(),
    ),
    GetPage(
      name: _Paths.SELLER_DASHBOARD,
      page: () => const SellerDashboardView(),
      binding: SellerDashboardBinding(),
    ),
    GetPage(
      name: _Paths.TAB_BAR,
      page: () => const TabBarView(),
      binding: TabBarBinding(),
    ),
  ];
}
