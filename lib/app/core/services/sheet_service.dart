import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/product_model.dart';
import '../../modules/user_dashboard/views/product_sheet/product_sheet.dart';

/// Service for managing bottom sheets
class SheetService {
  /// Show product details sheet
  static void showProductSheet({Product? product}) {
    Get.bottomSheet(
      ProductSheetWidget(product: product),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: true,
      ignoreSafeArea: false,
    );
  }
}
