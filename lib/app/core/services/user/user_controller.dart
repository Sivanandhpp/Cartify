import 'package:cartify/app/core/models/user/user_model.dart';
import 'package:cartify/app/core/services/storage_service.dart';
import 'package:cartify/app/core/services/log_service.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  // .obs makes the variable reactive. We use Rx<UserModel?> to allow it to be null.
  final Rx<UserModel?> _user = Rx<UserModel?>(null);

  // Create a public getter to access the user data from the UI
  // The .value is crucial for accessing the data inside an Rx variable
  UserModel? get user => _user.value;

  void updateUser(UserModel user) {
    try {
      _user.value = user;
      StorageService().storeUserProfile(user);
    } catch (e) {
      LogService.error('Failed to update user in storage', e);
    }
  }

  Future<UserModel?> getUserFromStorage() async {
    try {
      _user.value = StorageService().getUserProfile();
      LogService.info(
        'User profile loaded from storage: ${_user.value?.name ?? 'Unknown'}',
      );
      
    } catch (e) {
      LogService.error('Failed to load user from storage', e);
      _user.value = null;
    }
  return _user.value;
  }

  // Method to clear user data on logout
  void clearUser() {
    _user.value = null;
    StorageService().clearUserProfile();
  }
}
