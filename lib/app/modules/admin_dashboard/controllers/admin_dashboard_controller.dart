// Core imports (absolute)
import 'package:cartify/app/core/index.dart';
import 'package:cartify/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AdminDashboardController extends GetxController {
  final storage = GetStorage();

  void logOut() {
    // 💾 Storage Configuration - Clear centralized login data
    storage.remove(AppConfig.loginStatusKey);
    storage.remove(AppConfig.userRoleKey);
    Get.offAllNamed(Routes.LOGIN);
  }
}



