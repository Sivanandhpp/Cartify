import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/api_product_model.dart';
import '../../modules/user_dashboard/views/product_sheet/product_sheet.dart';

/// Service for managing bottom sheets
class SheetService {
  /// Show product details sheet
  static void showProductSheet({ApiProduct? product}) {
    Get.bottomSheet(
      ProductSheetWidget(product: product),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: true,
      ignoreSafeArea: false,
    );
  }
}
