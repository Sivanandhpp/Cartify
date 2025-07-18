import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../config/app_config.dart';
import 'log_service.dart';

/// Theme management service for handling light/dark theme switching
///
/// This service manages the application's theme state, persists user preferences,
/// and provides methods to switch between light and dark themes.
class ThemeService extends GetxService {
  static ThemeService get instance => Get.find<ThemeService>();

  // Storage instance
  final GetStorage _storage = GetStorage();

  // Observable theme mode
  final Rx<ThemeMode> _themeMode = ThemeMode.system.obs;

  // Getters
  ThemeMode get themeMode => _themeMode.value;
  bool get isDarkMode => _themeMode.value == ThemeMode.dark;
  bool get isLightMode => _themeMode.value == ThemeMode.light;
  bool get isSystemMode => _themeMode.value == ThemeMode.system;

  @override
  void onInit() {
    super.onInit();
    LogService.info('ThemeService initialized');
    _loadThemeFromStorage();
  }

  /// Load saved theme from storage
  void _loadThemeFromStorage() {
    try {
      final savedTheme = _storage.read<String>(AppConfig.themeStorageKey);
      if (savedTheme != null) {
        _themeMode.value = _themeModeFromString(savedTheme);
        LogService.info('Theme loaded from storage: $savedTheme');
      } else {
        // Default to system theme
        _themeMode.value = ThemeMode.system;
        LogService.info('No saved theme found, using system default');
      }

      // Apply the theme to GetX
      Get.changeThemeMode(_themeMode.value);
    } catch (e) {
      LogService.error('Failed to load theme from storage', e);
      _themeMode.value = ThemeMode.system;
      Get.changeThemeMode(_themeMode.value);
    }
  }

  /// Save theme to storage
  Future<void> _saveThemeToStorage() async {
    try {
      await _storage.write(
        AppConfig.themeStorageKey,
        _themeMode.value.toString(),
      );
      LogService.debug('Theme saved to storage: ${_themeMode.value}');
    } catch (e) {
      LogService.error('Failed to save theme to storage', e);
    }
  }

  /// Switch to light theme
  Future<void> switchToLightTheme() async {
    _themeMode.value = ThemeMode.light;
    Get.changeThemeMode(ThemeMode.light);
    await _saveThemeToStorage();

    LogService.userAction('Theme changed to light');

    Get.snackbar(
      'Theme Changed',
      'Switched to Light Theme',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
      backgroundColor: Get.theme.colorScheme.primary,
      colorText: Get.theme.colorScheme.onPrimary,
    );
  }

  /// Switch to dark theme
  Future<void> switchToDarkTheme() async {
    _themeMode.value = ThemeMode.dark;
    Get.changeThemeMode(ThemeMode.dark);
    await _saveThemeToStorage();

    LogService.userAction('Theme changed to dark');

    Get.snackbar(
      'Theme Changed',
      'Switched to Dark Theme',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
      backgroundColor: Get.theme.colorScheme.primary,
      colorText: Get.theme.colorScheme.onPrimary,
    );
  }

  /// Switch to system theme
  Future<void> switchToSystemTheme() async {
    _themeMode.value = ThemeMode.system;
    Get.changeThemeMode(ThemeMode.system);
    await _saveThemeToStorage();

    LogService.userAction('Theme changed to system');

    Get.snackbar(
      'Theme Changed',
      'Switched to System Theme',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
      backgroundColor: Get.theme.colorScheme.primary,
      colorText: Get.theme.colorScheme.onPrimary,
    );
  }

  /// Toggle between light and dark theme
  Future<void> toggleTheme() async {
    if (_themeMode.value == ThemeMode.light) {
      await switchToDarkTheme();
    } else if (_themeMode.value == ThemeMode.dark) {
      await switchToLightTheme();
    } else {
      // If system mode, switch to opposite of current system preference
      final brightness =
          WidgetsBinding.instance.platformDispatcher.platformBrightness;
      if (brightness == Brightness.dark) {
        await switchToLightTheme();
      } else {
        await switchToDarkTheme();
      }
    }
  }

  /// Get theme mode display name
  String getThemeModeDisplayName() {
    switch (_themeMode.value) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }

  /// Get current effective brightness (considering system theme)
  Brightness getCurrentBrightness() {
    switch (_themeMode.value) {
      case ThemeMode.light:
        return Brightness.light;
      case ThemeMode.dark:
        return Brightness.dark;
      case ThemeMode.system:
        return WidgetsBinding.instance.platformDispatcher.platformBrightness;
    }
  }

  /// Check if current effective theme is dark
  bool isCurrentlyDark() {
    return getCurrentBrightness() == Brightness.dark;
  }

  /// Get theme icon based on current mode
  IconData getThemeIcon() {
    switch (_themeMode.value) {
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
      case ThemeMode.system:
        return Icons.brightness_auto;
    }
  }

  /// Convert string to ThemeMode
  ThemeMode _themeModeFromString(String themeString) {
    switch (themeString) {
      case 'ThemeMode.light':
        return ThemeMode.light;
      case 'ThemeMode.dark':
        return ThemeMode.dark;
      case 'ThemeMode.system':
        return ThemeMode.system;
      default:
        return ThemeMode.system;
    }
  }

  /// Get list of available theme options for settings UI
  List<ThemeOption> getThemeOptions() {
    return [
      ThemeOption(
        mode: ThemeMode.light,
        title: 'Light',
        description: 'Use light theme',
        icon: Icons.light_mode,
      ),
      ThemeOption(
        mode: ThemeMode.dark,
        title: 'Dark',
        description: 'Use dark theme',
        icon: Icons.dark_mode,
      ),
      ThemeOption(
        mode: ThemeMode.system,
        title: 'System',
        description: 'Use system theme',
        icon: Icons.brightness_auto,
      ),
    ];
  }

  /// Set specific theme mode
  Future<void> setThemeMode(ThemeMode mode) async {
    switch (mode) {
      case ThemeMode.light:
        await switchToLightTheme();
        break;
      case ThemeMode.dark:
        await switchToDarkTheme();
        break;
      case ThemeMode.system:
        await switchToSystemTheme();
        break;
    }
  }
}

/// Theme option model for settings UI
class ThemeOption {
  final ThemeMode mode;
  final String title;
  final String description;
  final IconData icon;

  ThemeOption({
    required this.mode,
    required this.title,
    required this.description,
    required this.icon,
  });
}
