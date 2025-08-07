import 'package:get/get.dart';

import '../../../../core/index.dart';

class SellerDashboardController extends GetxController {
   logout() async {
    final AuthenticationService authService = Get.find<AuthenticationService>();
    await authService.logout();
  }
}
