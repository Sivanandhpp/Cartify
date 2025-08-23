import 'package:get/get.dart';
import 'package:cartify/app/core/index.dart';

class BuyerProfileController extends GetxController {
  final AuthenticationService _authService = Get.find<AuthenticationService>();
  final UserService _userService = Get.find<UserService>();
  
  final Rx<UserModel?> user = Rx<UserModel?>(null);
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserProfile();
  }

  Future<void> loadUserProfile() async {
    isLoading.value = true;
    try {
      final userProfile = await _userService.getUserProfile();
      user.value = userProfile;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load profile');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
  }

  Future<void> refreshProfile() async {
    await loadUserProfile();
  }
}