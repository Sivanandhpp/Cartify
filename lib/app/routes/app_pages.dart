import 'package:get/get.dart';

import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/otp_check/bindings/otp_check_binding.dart';
import '../modules/otp_check/views/otp_check_view.dart';
import '../modules/user_dashboard/bindings/user_dashboard_binding.dart';
import '../modules/user_dashboard/views/user_dashboard_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN;

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
  ];
}
