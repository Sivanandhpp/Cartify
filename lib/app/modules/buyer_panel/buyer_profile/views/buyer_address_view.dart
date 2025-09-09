import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/index.dart';
import '../controllers/buyer_address_controller.dart';
import '../../widgets/address_card.dart';

class BuyerAddressView extends GetView<BuyerAddressController> {
  const BuyerAddressView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          AppStrings.myAddressesTitle,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: controller.refreshAddresses,
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (controller.addresses.isEmpty) {
            return _buildEmptyState();
          }

          return _buildAddressList();
        }),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: AppButton(
          text: AppStrings.addNewAddress,
          onPressed: controller.showAddAddressForm,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
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
            const SizedBox(height: 8),
            Text(
              AppStrings.addFirstAddressToGetStarted,
              style: AppTextStyles.bodyMedium(AppColors.secondaryBrand),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            AppButton(
              text: AppStrings.addFirstAddressAction,
              onPressed: controller.showAddAddressForm,
              width: 200,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressList() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: controller.addresses.map((address) {
                final isSelected =
                    controller.selectedAddress.value?.id == address.id;
                return AddressCard(
                  address: address,
                  controller: controller,
                  isSelected: isSelected,
                  showEditButton: true,
                  showDeleteButton: true,
                  showSelectionIndicator: true,
                  onTap: () {
                    controller.selectAddress(address);
                  },
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}
