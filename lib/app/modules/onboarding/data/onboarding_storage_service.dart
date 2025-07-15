import 'package:get_storage/get_storage.dart';

class OnboardingStorageService {
  static const _kBoardedKey = 'isBoarded';
  final GetStorage _box;
  OnboardingStorageService(this._box);

  bool get isBoarded => _box.read(_kBoardedKey) ?? false;
  Future<void> markBoarded() => _box.write(_kBoardedKey, true);
}
