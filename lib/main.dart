import 'package:cartify/app/core/config/app_initservices.dart';
import 'package:cartify/app/core/index.dart';
import 'package:cartify/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  // Initialize services
  await GetStorage.init();
  await initServices();

  runApp(
    GetMaterialApp(
      title: AppIdentity.displayName,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      theme: AppTheme.lightTheme,
      // darkTheme: AppTheme.darkTheme,
      // themeMode: Get.find<ThemeService>().themeMode,
      debugShowCheckedModeBanner: false,
    ),
  );
}

