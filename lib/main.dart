import 'package:bevco/app/core/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'app/core/services/cart_service.dart';
import 'app/core/services/error_service.dart';
import 'app/core/services/log_service.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize GetStorage
  await GetStorage.init();

  // Initialize services
  await initServices();

  LogService.info('Application starting...');

  runApp(
    GetMaterialApp(
      title: 'Bevco',
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
    ),
  );
}

Future<void> initServices() async {
  LogService.info('Initializing services...');

  // Put the services into memory, making them available globally
  Get.put(ErrorService(), permanent: true);
  Get.put(CartService(), permanent: true);

  LogService.info('Services initialized successfully');
}
