import 'package:bevco/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SplashController extends GetxController {

  SplashController() {
    print('SplashController constructor called');
  }
  @override
  void onInit() {
    
print('SplashController initialized');
    super.onInit();
  }

  @override
  void onReady() {
    print('SplashController initialized');
    final storage = GetStorage();
    final isLoggedIn = storage.read('isLoggedIn') ?? false;
    final userRole = storage.read('userRole') ?? 'user';
    print('isLoggedIn: $isLoggedIn, userRole: $userRole');                                    
    if (isLoggedIn) {
      if (userRole == 'admin') {
        Get.offAllNamed(Routes.ADMIN_DASHBOARD);
      } else {
        Get.offAllNamed(Routes.USER_DASHBOARD);
      }
    } else {
      Get.offAllNamed(Routes.LOGIN);
    }
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
