import 'package:cartify/app/modules/onboarding/data/onboarding_storage_service.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OnboardingStorageService(GetStorage()));
    Get.lazyPut(() => OnboardingController(Get.find()));
  }
}
