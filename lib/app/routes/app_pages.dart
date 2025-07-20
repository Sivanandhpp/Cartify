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
import '../modules/user_panel/cart/bindings/user_panel_cart_binding.dart';
import '../modules/user_panel/cart/views/user_panel_cart_view.dart';
import '../modules/user_panel/categories/bindings/user_panel_categories_binding.dart';
import '../modules/user_panel/categories/views/user_panel_categories_view.dart';
import '../modules/user_panel/dashboard/bindings/user_panel_dashboard_binding.dart';
import '../modules/user_panel/dashboard/views/user_panel_dashboard_view.dart';
import '../modules/user_panel/home/bindings/user_panel_home_binding.dart';
import '../modules/user_panel/home/views/user_panel_home_view.dart';
import '../modules/user_panel/offers/bindings/user_panel_offers_binding.dart';
import '../modules/user_panel/offers/views/user_panel_offers_view.dart';
import '../modules/user_panel/profile/bindings/user_panel_profile_binding.dart';
import '../modules/user_panel/profile/views/user_panel_profile_view.dart';
import '../modules/user_panel/wishlist/bindings/user_panel_wishlist_binding.dart';
import '../modules/user_panel/wishlist/views/user_panel_wishlist_view.dart';

// Routes barrel export file
// Usage: import 'package:cartify/app/routes/app_pages.dart';

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
      children: [
        GetPage(
          name: _Paths.USER_PANEL_CART,
          page: () => const UserPanelCartView(),
          binding: UserPanelCartBinding(),
        ),
      ],
    ),
    GetPage(
      name: _Paths.USER_PANEL_DASHBOARD,
      page: () => const UserPanelDashboardView(),
      binding: UserPanelDashboardBinding(),
    ),
    GetPage(
      name: _Paths.USER_PANEL_PROFILE,
      page: () => const UserPanelProfileView(),
      binding: UserPanelProfileBinding(),
    ),
    GetPage(
      name: _Paths.USER_PANEL_OFFERS,
      page: () => const UserPanelOffersView(),
      binding: UserPanelOffersBinding(),
    ),
    GetPage(
      name: _Paths.USER_PANEL_WISHLIST,
      page: () => const UserPanelWishlistView(),
      binding: UserPanelWishlistBinding(),
    ),
    GetPage(
      name: _Paths.USER_PANEL_CATEGORIES,
      page: () => const UserPanelCategoriesView(),
      binding: UserPanelCategoriesBinding(),
    ),
    GetPage(
      name: _Paths.USER_PANEL_HOME,
      page: () => const UserPanelHomeView(),
      binding: UserPanelHomeBinding(),
    ),
  ];
}
