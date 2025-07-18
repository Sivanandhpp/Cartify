import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductSheetController extends GetxController {
  /// Controls the DraggableScrollableSheet.
  final DraggableScrollableController sheetController =
      DraggableScrollableController();

  /// Tracks whether the "View product details" section is expanded.
  final isDetailsExpanded = false.obs;

  /// Defines the initial, smaller size of the sheet.
  static const double minSheetSize = 0.9;

  /// Defines the fully expanded size of the sheet.
  static const double maxSheetSize = 1;

  @override
  void onInit() {
    super.onInit();
    // Add a listener to detect when the sheet is dragged by the user.
    sheetController.addListener(() {
      // If the sheet is dragged to its maximum size, update the expanded state.
      if (sheetController.size >= maxSheetSize) {
        isDetailsExpanded.value = true;
      }
    });
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
      // Animate back to the minimum size.
      sheetController.animateTo(
        minSheetSize,
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

