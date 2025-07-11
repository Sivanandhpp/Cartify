import 'package:get/get.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/otp_check/bindings/otp_check_binding.dart';
import '../modules/otp_check/views/otp_check_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.OTP_CHECK,
      page: () => const OtpCheckView(),
      binding: OtpCheckBinding(),
    ),
  ];
}
