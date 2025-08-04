import 'package:get/get.dart';

import '../controllers/buyer_dashboard_controller.dart';
import '../../buyer_home/bindings/buyer_home_binding.dart';
import '../../buyer_categories/bindings/buyer_categories_binding.dart';
import '../../buyer_wishlist/bindings/buyer_wishlist_binding.dart';
import '../../buyer_offers/bindings/buyer_offers_binding.dart';
import '../../buyer_profile/bindings/buyer_profile_binding.dart';
import '../controllers/cart_tracking_controller.dart';

class BuyerDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BuyerDashboardController>(() => BuyerDashboardController());
    Get.lazyPut<CartTrackingController>(() => CartTrackingController());

    // Initialize all page dependencies
    BuyerHomeBinding().dependencies();
    BuyerCategoriesBinding().dependencies();
    BuyerWishlistBinding().dependencies();
    BuyerOffersBinding().dependencies();
    BuyerProfileBinding().dependencies();
  }
}
