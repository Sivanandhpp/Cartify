import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/index.dart';
import '../../controllers/buyer_cart_controller.dart';

class AddressSelectionWidget extends StatelessWidget {
  const AddressSelectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BuyerCartController>();

    return Obx(() {
      if (controller.isLoadingAddresses.value) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: const Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(width: 12),
              Text(
                'Loading addresses...',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        );
      }

      final hasAddresses = controller.addresses.isNotEmpty;
      final selectedAddress = controller.selectedAddress.value;

      return GestureDetector(
        onTap: controller.showAddressSelectionSheet,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (hasAddresses && selectedAddress != null) ...[
                      const Text(
                        'Delivery Address',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Container(
                            height: 40,
                            width: 40,
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              controller.getAddressTypeIcon(
                                selectedAddress.addressType,
                              ),

                              color: AppColors.primary,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                selectedAddress.recipientName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                '${selectedAddress.street}, ${selectedAddress.city}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.grey800,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ] else ...[
                      const Text(
                        'Add delivery address',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'Tap to select address',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.secondaryBrand,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.keyboard_arrow_down, color: AppColors.black, size: 20),
            ],
          ),
        ),
      );
    });
  }
}
