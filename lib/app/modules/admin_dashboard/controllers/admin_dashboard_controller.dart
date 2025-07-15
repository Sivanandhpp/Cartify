import 'package:bevco/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AdminDashboardController extends GetxController {
  final storage = GetStorage();

  void logOut() {
    storage.erase(); // or storage.remove('isLoggedIn');
    Get.offAllNamed(Routes.LOGIN);
  }
}
