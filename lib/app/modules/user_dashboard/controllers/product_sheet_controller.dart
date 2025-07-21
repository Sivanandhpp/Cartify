import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductSheetController extends GetxController {
  /// Controls the DraggableScrollableSheet.
  final DraggableScrollableController sheetController =
      DraggableScrollableController();

  /// Tracks whether the "View product details" section is expanded.
  final isDetailsExpanded = false.obs;

  /// Defines the initial size of the sheet.
  static const double initialSheetSize = 0.7;

  /// Defines the minimum size (allows dragging lower to close).
  static const double minSheetSize = 0.69;

  /// Defines the fully expanded size of the sheet.
  static const double maxSheetSize = 1.0;

  /// Threshold below which the sheet will auto-close.
  static const double closeThreshold = 0.01;

  @override
  void onInit() {
    super.onInit();
    // Add a listener to detect when the sheet is dragged by the user.
    sheetController.addListener(() {
      final currentSize = sheetController.size;

      // If the sheet is dragged to its maximum size, update the expanded state.
      if (currentSize >= 0.95) {
        isDetailsExpanded.value = true;
      } else if (currentSize < 0.85) {
        // If dragged below 0.85, collapse the details
        isDetailsExpanded.value = false;
      }

      // If dragged below close threshold, close the sheet
      if (currentSize < closeThreshold) {
        _closeSheet();
      }
    });
  }

  /// Closes the sheet by popping the bottom sheet
  void _closeSheet() {
    if (Get.isBottomSheetOpen ?? false) {
      Get.back();
    }
  }

  /// Toggles the "View product details" section and animates the sheet.
  void toggleDetails() {
    isDetailsExpanded.value = !isDetailsExpanded.value;

    // Animate the sheet to the appropriate size.
    if (isDetailsExpanded.value) {
      // Animate to the maximum size.
      sheetController.animateTo(
        maxSheetSize,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Animate back to the initial size.
      sheetController.animateTo(
        initialSheetSize,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void onClose() {
    sheetController.dispose();
    super.onClose();
  }
}
