import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/index.dart';

class BuyerOrderStatusController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> scaleAnimation;
  late Animation<double> circleAnimation;
  late Animation<double> checkmarkAnimation;
  late Animation<double> fadeAnimation;

  // Retrieve navigation arguments passed with Get.offNamed(...)
  final Map<String, dynamic> _routeArgs =
      (Get.arguments ?? {}) as Map<String, dynamic>;

  // Use the parsed arguments correctly
  late final bool isSuccess;
  late final OrderModel? order;

  @override
  void onInit() {
    super.onInit();

    // Initialize the values from route arguments
    isSuccess = _routeArgs['success'] == true;
    order = _routeArgs['order'] as OrderModel?;

    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Scale animation for the main icon
    scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.elasticOut),
      ),
    );

    // Circle animation for expanding circles
    circleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOut),
      ),
    );

    // Checkmark animation (for success)
    checkmarkAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeInOut),
      ),
    );

    // Fade animation for text content
    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.6, 1.0, curve: Curves.easeIn),
      ),
    );
  }

  void _startAnimations() {
    animationController.forward();
  }

  void goToOrderHistory() {
    Get.offAllNamed('/buyer-orders');
  }

  void backToShopping() {
    Get.offAllNamed('/buyer-dashboard');
  }

  String get statusTitle {
    return isSuccess ? 'Order Placed Successfully!' : 'Order Failed';
  }

  String get statusSubtitle {
    if (isSuccess && order != null) {
      return 'Your order #${order!.id.substring(0, 8)} has been placed successfully';
    }
    return 'We couldn\'t process your order. Please try again.';
  }

  Color get statusColor {
    return isSuccess ? Colors.green : Colors.red;
  }

  IconData get statusIcon {
    return isSuccess ? Icons.check : Icons.close;
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}
