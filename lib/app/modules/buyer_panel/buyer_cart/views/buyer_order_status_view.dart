import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/index.dart';
import '../controllers/buyer_order_status_controller.dart';

class BuyerOrderStatusView extends GetView<BuyerOrderStatusController> {
  const BuyerOrderStatusView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Animated Status Icon with Circles
                    AnimatedBuilder(
                      animation: controller.animationController,
                      builder: (context, child) {
                        return SizedBox(
                          height: 200,
                          width: 200,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Outer expanding circle
                              Transform.scale(
                                scale: controller.circleAnimation.value * 2,
                                child: Container(
                                  height: 150,
                                  width: 150,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: controller.statusColor.withOpacity(
                                      0.1,
                                    ),
                                  ),
                                ),
                              ),
                              // Middle expanding circle
                              Transform.scale(
                                scale: controller.circleAnimation.value * 1.5,
                                child: Container(
                                  height: 120,
                                  width: 120,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: controller.statusColor.withOpacity(
                                      0.2,
                                    ),
                                  ),
                                ),
                              ),
                              // Inner expanding circle
                              Transform.scale(
                                scale: controller.circleAnimation.value,
                                child: Container(
                                  height: 90,
                                  width: 90,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: controller.statusColor.withOpacity(
                                      0.3,
                                    ),
                                  ),
                                ),
                              ),
                              // Main status circle (without icon for success)
                              Transform.scale(
                                scale: controller.scaleAnimation.value,
                                child: Container(
                                  height: 80,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: controller.statusColor,
                                    boxShadow: [
                                      BoxShadow(
                                        color: controller.statusColor
                                            .withOpacity(0.3),
                                        blurRadius: 20,
                                        spreadRadius: 5,
                                      ),
                                    ],
                                  ),
                                  child: controller.isSuccess
                                      ? null // No icon for success, we'll use the animated checkmark
                                      : Icon(
                                          controller.statusIcon,
                                          color: Colors.white,
                                          size: 40,
                                        ),
                                ),
                              ),
                              // Animated checkmark for success ONLY
                              if (controller.isSuccess)
                                CustomPaint(
                                  size: const Size(80, 80),
                                  painter: CheckmarkPainter(
                                    progress:
                                        controller.checkmarkAnimation.value,
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 40),

                    // Status Text with Fade Animation
                    AnimatedBuilder(
                      animation: controller.fadeAnimation,
                      builder: (context, child) {
                        return Opacity(
                          opacity: controller.fadeAnimation.value,
                          child: Column(
                            children: [
                              Text(
                                controller.statusTitle,
                                style: TextStyle(
                                  fontSize: 24,
                                  color: controller.statusColor,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                controller.statusSubtitle,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 40),

                    // Order Details (if success and order exists)
                    if (controller.isSuccess && controller.order != null)
                      AnimatedBuilder(
                        animation: controller.fadeAnimation,
                        builder: (context, child) {
                          return Opacity(
                            opacity: controller.fadeAnimation.value,
                            child: _buildOrderDetails(),
                          );
                        },
                      ),
                  ],
                ),
              ),

              // Action Buttons
              AnimatedBuilder(
                animation: controller.fadeAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: controller.fadeAnimation.value,
                    child: Column(
                      children: [
                        if (controller.isSuccess)
                          AppButton(
                            text: 'Track Order',
                            onPressed: controller.goToOrderHistory,
                            width: double.infinity,
                          )
                        else
                          AppButton(
                            text: 'Try Again',
                            onPressed: () => Get.back(),
                            width: double.infinity,
                          ),
                        const SizedBox(height: 12),
                        if(controller.isSuccess)AppButton(
                          text: 'Continue Shopping',
                          onPressed: controller.backToShopping,
                          width: double.infinity,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderDetails() {
    final order = controller.order!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Order ID', style: TextStyle(color: Colors.grey[600])),
              Text(
                '#${order.id.substring(0, 8)}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total Amount', style: TextStyle(color: Colors.grey[600])),
              Text(
                '₹${order.totalAmount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Items', style: TextStyle(color: Colors.grey[600])),
              Text(
                '${order.items.length} items',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Delivery Address',
                style: TextStyle(color: Colors.grey[600]),
              ),
              Expanded(
                child: Text(
                  order.shippingAddress.formattedAddress,
                  style: TextStyle(fontWeight: FontWeight.w500),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Custom painter for animated checkmark
class CheckmarkPainter extends CustomPainter {
  final double progress;

  CheckmarkPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress == 0) return;

    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path();

    // Define checkmark path
    final p1 = Offset(size.width * 0.25, size.height * 0.5);
    final p2 = Offset(size.width * 0.45, size.height * 0.7);
    final p3 = Offset(size.width * 0.75, size.height * 0.3);

    path.moveTo(p1.dx, p1.dy);
    path.lineTo(p2.dx, p2.dy);
    path.lineTo(p3.dx, p3.dy);

    // Create a path metric to draw partial path based on progress
    final pathMetric = path.computeMetrics().first;
    final extractedPath = pathMetric.extractPath(
      0,
      pathMetric.length * progress,
    );

    canvas.drawPath(extractedPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
