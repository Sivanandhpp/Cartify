import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:cartify/app/core/index.dart';
import 'package:get/get.dart';

Future<void> initServices() async {
  LogService.info('Initializing services...');

  Get.put(UserController(), permanent: true);

  // Initialize core services in order of dependency
  Get.put(ErrorService(), permanent: true);
  Get.put(StorageService(), permanent: true);
  Get.put(ThemeService(), permanent: true);

  // Initialize FlutterSecureStorage for ApiClient
  final secureStorage = const FlutterSecureStorage();

  // Initialize ApiClient with FlutterSecureStorage
  Get.put(ApiClient(secureStorage), permanent: true);

  // Initialize services that depend on ApiClient
  Get.put(
    AuthenticationService(Get.find<ApiClient>(), secureStorage),
    permanent: true,
  );
  Get.put(CartService(Get.find<ApiClient>()), permanent: true);
  Get.put(ProductService(Get.find<ApiClient>()), permanent: true);
  Get.put(OrderService(Get.find<ApiClient>()), permanent: true);
  Get.put(UserService(Get.find<ApiClient>()), permanent: true);
  Get.put(ReviewService(Get.find<ApiClient>()), permanent: true);
  Get.put(DashboardService(Get.find<ApiClient>()), permanent: true);

  LogService.info('Services initialized successfully');
}
