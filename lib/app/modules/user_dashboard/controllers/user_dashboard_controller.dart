import 'package:bevco/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class UserDashboardController extends GetxController {
  final storage = GetStorage();

  void logOut() {
    storage.erase();
    // TODO:
    // storage.remove('isLoggedIn');
    // storage.remove('userRole');
    Get.offAllNamed(Routes.LOGIN);
  }
}
