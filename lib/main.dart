
import 'package:cartify/app/core/index.dart';
import 'package:cartify/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize GetStorage
  await GetStorage.init();

  // Initialize services
  await initServices();

  LogService.info('Application starting...');

  runApp(
    GetMaterialApp(
      title: AppEnvironment.displayName,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      theme: AppTheme.lightTheme,
      // darkTheme: AppTheme.darkTheme,
      // themeMode: Get.find<ThemeService>().themeMode,
      debugShowCheckedModeBanner: false,
    ),
  );
}

Future<void> initServices() async {
  LogService.info('Initializing services...');

  // Initialize core services in order of dependency
  Get.put(ErrorService(), permanent: true);
  Get.put(ThemeService(), permanent: true);
  Get.put(CartService(), permanent: true);

  LogService.info('Services initialized successfully');
}
