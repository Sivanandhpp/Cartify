import 'package:cartify/app/core/index.dart';
import 'package:cartify/app/modules/buyer_panel/buyer_dashboard/controllers/buyer_dashboard_controller.dart';
import 'package:get/get.dart';

class BuyerProfileController extends GetxController {
  final BuyerDashboardController buyerDashboardController = Get.find<BuyerDashboardController>();

  logout() async {
    final AuthenticationService authService = Get.find<AuthenticationService>();
    buyerDashboardController.selectedNavIndex.value = 0;
    await authService.logout();
  }
}
