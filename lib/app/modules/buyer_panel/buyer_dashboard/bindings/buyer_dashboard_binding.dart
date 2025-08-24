import 'package:cartify/app/modules/buyer_panel/buyer_cart/controllers/buyer_cart_controller.dart';
import 'package:cartify/app/modules/buyer_panel/buyer_categories/controllers/buyer_categories_controller.dart';
import 'package:cartify/app/modules/buyer_panel/buyer_dashboard/controllers/product_sheet_controller.dart';
import 'package:cartify/app/modules/buyer_panel/buyer_home/controllers/buyer_home_controller.dart';
import 'package:cartify/app/modules/buyer_panel/buyer_offers/controllers/buyer_offers_controller.dart';
import 'package:cartify/app/modules/buyer_panel/buyer_profile/controllers/buyer_address_controller.dart';
import 'package:cartify/app/modules/buyer_panel/buyer_profile/controllers/buyer_profile_controller.dart';
import 'package:cartify/app/modules/buyer_panel/buyer_wishlist/controllers/buyer_wishlist_controller.dart';
import 'package:get/get.dart';
import '../controllers/buyer_dashboard_controller.dart';

class BuyerDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BuyerDashboardController>(
      () => BuyerDashboardController(),
      fenix: true,
    );
    Get.lazyPut<BuyerHomeController>(() => BuyerHomeController());
    Get.lazyPut<ProductSheetController>(() => ProductSheetController());
    Get.lazyPut<BuyerCartController>(() => BuyerCartController());
    Get.lazyPut<BuyerCategoriesController>(() => BuyerCategoriesController());
    Get.lazyPut<BuyerOffersController>(() => BuyerOffersController());
    Get.lazyPut<BuyerWishlistController>(() => BuyerWishlistController());
    Get.lazyPut<BuyerProfileController>(() => BuyerProfileController());
    Get.lazyPut<BuyerAddressController>(() => BuyerAddressController());
  }
}
