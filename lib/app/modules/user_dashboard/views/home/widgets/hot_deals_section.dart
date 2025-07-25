// Core imports (absolute)
import 'package:cartify/app/core/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Local widget imports (relative)
import '../../../controllers/hot_deals_controller.dart';
import 'horizontal_product_list_widget.dart';

/// The main widget that includes the title and the horizontal list.
class HotDealsSection extends StatelessWidget {
  const HotDealsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final HotDealsController hotDealsController =
        Get.find<HotDealsController>();

    return Obx(() {
      return HorizontalProductListWidget(
        title: 'Hot deals',
        products: hotDealsController.displayProducts,
        isLoading: hotDealsController.isLoading.value,
        hasError: hotDealsController.hasError.value,
        errorMessage: hotDealsController.errorMessage.value,
        onSeeAllPressed: () {
          LogService.info('See All button pressed in Hot Deals');
        },
        onRetryPressed: () => hotDealsController.refreshHotDeals(),
      );
    });
  }
}
