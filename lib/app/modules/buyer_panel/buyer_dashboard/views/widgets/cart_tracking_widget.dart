// Local imports (relative)
import 'package:cartify/app/modules/buyer_panel/buyer_cart/controllers/buyer_cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/index.dart';

BuyerCartController cartTrackingController = Get.find<BuyerCartController>();

Widget buildCartTrackingWidget() {
  return Obx(() {
    if (cartTrackingController.cartItems.isEmpty) {
      return const SizedBox.shrink();
    }
    return GestureDetector(
      onTap: () {
       
      },
      child: Container(
        height: 60,
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                children: [
                  const Center(
                    child: Icon(
                      Icons.shopping_bag_outlined,
                      color: Colors.orange,
                      size: 20,
                    ),
                  ),
                  // if (cartService.totalQuantity > 0)
                  Positioned(
                    right: 2,
                    top: 2,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),

                      child: Text(
                        cartTrackingController.cartItems.length > 9
                            ? '9+'
                            : cartTrackingController.cartItems.length
                                  .toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),

            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${cartTrackingController.cartItems.length.toString()} ${cartTrackingController.cartItems.length == 1 ? 'Item' : 'Items'}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'You save ₹${cartTrackingController.totalSavings.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const Icon(Icons.keyboard_arrow_up, size: 20, color: Colors.grey),

            const Spacer(),
            ElevatedButton(
              onPressed: () => Get.toNamed('/buyer-cart'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
              child: const Text(
                'View cart',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  });
}
