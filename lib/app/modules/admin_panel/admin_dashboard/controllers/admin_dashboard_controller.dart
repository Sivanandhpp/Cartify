import 'package:cartify/app/core/index.dart';
import 'package:get/get.dart';

class AdminDashboardController extends GetxController {
   logout() async {
    final AuthenticationService authService = Get.find<AuthenticationService>();
    await authService.logout();
  }
}
