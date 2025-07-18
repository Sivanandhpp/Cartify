import 'package:cartify/app/core/index.dart';
import 'package:get_storage/get_storage.dart';

class OnboardingStorageService {
  // 💾 Storage Configuration - Using centralized AppConfig key
  final GetStorage _box;
  OnboardingStorageService(this._box);

  bool get isBoarded => _box.read(AppConfig.onboardingStatusKey) ?? false;
  Future<void> markBoarded() => _box.write(AppConfig.onboardingStatusKey, true);
}
