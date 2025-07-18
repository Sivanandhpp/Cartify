import 'package:cartify/app/core/index.dart';
import 'package:cartify/app/routes/index.dart';
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
      title: AppIdentity.appTitle,
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
