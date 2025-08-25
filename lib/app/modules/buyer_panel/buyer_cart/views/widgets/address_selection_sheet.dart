import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/index.dart';
import '../../controllers/buyer_cart_controller.dart';

class AddressSelectionSheet extends StatelessWidget {
  const AddressSelectionSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BuyerCartController>();

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      child: Stack(children: [_buildContent(controller), _buildHeader()]),
    );
  }

  Widget _buildContent(BuyerCartController controller) {
    return Column(
      children: [
        const SizedBox(height: 80), // Space for floating header
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              Obx(() {
                if (controller.isLoadingAddresses.value) {
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
                    return _buildAddressCard(controller, address, isSelected);
                  }).toList(),
                );
              }),

              const SizedBox(height: 100),
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
            'Select Delivery Address',
            style: TextStyle(
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1.5,
              ),
            ),
            child: const Icon(
              Icons.keyboard_arrow_down,
              color: Colors.black,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuyerCartController controller) {
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
            'No Addresses Found',
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
            text: 'Add Your First Address',
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

  Widget _buildAddressCard(
    BuyerCartController controller,
    Address address,
    bool isSelected,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected
              ? AppColors.primary
              : AppColors.grey.withOpacity(0.3),
          width: isSelected ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          controller.selectAddress(address);
          Get.back();
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAddressHeader(controller, address, isSelected),
              const SizedBox(height: 6),
              _buildAddressDetails(address),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddressHeader(
    BuyerCartController controller,
    Address address,
    bool isSelected,
  ) {
    return Row(
      children: [
        // Address type
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                controller.getAddressTypeIcon(address.addressType),
                size: 16,
                color: AppColors.primary,
              ),
              const SizedBox(width: 6),
              Text(
                controller.getAddressTypeLabel(address.addressType),
                style: AppTextStyles.labelMedium(AppColors.primary),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),

        // Default badge
        if (address.isDefault)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.darkSuccess.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'DEFAULT',
              style: AppTextStyles.labelMedium(AppColors.darkSuccess),
            ),
          ),

        const Spacer(),

        // Edit button
        GestureDetector(
          onTap: () {
            Get.back();
            controller.showEditAddressForm(address);
          },
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.edit_outlined,
              color: AppColors.primary,
              size: 16,
            ),
          ),
        ),

        // Selection indicator
        if (isSelected) ...[
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.check, color: Colors.white, size: 16),
          ),
        ],
      ],
    );
  }

  Widget _buildAddressDetails(Address address) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          address.recipientName,
          style: AppTextStyles.titleMedium(AppColors.primary),
        ),
        Text(
          address.phone,
          style: AppTextStyles.bodyMedium(AppColors.secondaryBrand),
        ),
        const SizedBox(height: 6),
        Text(
          address.street,
          style: AppTextStyles.bodyMedium(AppColors.primary),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          '${address.city}, ${address.state} - ${address.pincode}',
          style: AppTextStyles.bodyMedium(AppColors.secondaryBrand),
        ),
        if (address.landmark != null) ...[
          Text(
            'Near ${address.landmark}',
            style: AppTextStyles.bodySmall(AppColors.secondaryBrand),
          ),
        ],
      ],
    );
  }
}
