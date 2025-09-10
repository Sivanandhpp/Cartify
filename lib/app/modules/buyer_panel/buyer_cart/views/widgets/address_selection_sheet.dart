import 'dart:ui';
import 'package:cartify/app/modules/buyer_panel/buyer_profile/controllers/buyer_address_controller.dart';
import 'package:cartify/app/modules/buyer_panel/widgets/address_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/index.dart';

class AddressSelectionSheet extends StatelessWidget {
  const AddressSelectionSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BuyerAddressController>();

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      child: Stack(children: [_buildContent(controller), _buildHeader()]),
    );
  }

  Widget _buildContent(BuyerAddressController controller) {
    return Column(
      children: [
        const SizedBox(height: 80), // Space for floating header
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              Obx(() {
                if (controller.isLoading.value) {
                  return const Padding(
                    padding: EdgeInsets.all(40),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ),
                  );
                }

                if (controller.addresses.isEmpty) {
                  return _buildEmptyState(controller);
                }

                return Column(
                  children: controller.addresses.map((address) {
                    final isSelected =
                        controller.selectedAddress.value?.id == address.id;
                    return AddressCard(
                      address: address,
                      controller: controller,
                      isSelected: isSelected,
                      showEditButton: true,
                      showDeleteButton: false,
                      showSelectionIndicator: true,
                      onTap: () {
                        controller.selectAddress(address);
                        Get.back();
                      },
                    );
                  }).toList(),
                );
              }),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: AppButton(
            text: 'Add New Address',
            onPressed: () {
              Get.back();
              controller.showAddAddressForm();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: 16),
          const Text(
            AppStrings.selectDeliveryAddress,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),
          const Spacer(),
          _buildCloseButton(),
        ],
      ),
    );
  }

  Widget _buildCloseButton() {
    return GestureDetector(
      onTap: () => Get.back(),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(
          Icons.keyboard_arrow_down,
          color: AppColors.primary,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuyerAddressController controller) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.location_off_outlined,
            size: 80,
            color: AppColors.secondaryBrand.withOpacity(0.5),
          ),
          const SizedBox(height: 24),
          Text(
            AppStrings.noAddressesFound,
            style: AppTextStyles.headlineSmall(AppColors.primary),
          ),
          const SizedBox(height: 12),
          Text(
            'Add your first address to continue with delivery',
            style: AppTextStyles.bodyMedium(AppColors.secondaryBrand),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          AppButton(
            text: 'Add Address',
            onPressed: () {
              Get.back();
              controller.showAddAddressForm();
            },
            width: 200,
          ),
        ],
      ),
    );
  }
}
