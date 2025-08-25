import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/index.dart';
import '../controllers/buyer_address_controller.dart';

class BuyerAddressView extends GetView<BuyerAddressController> {
  const BuyerAddressView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text(
          'My Addresses',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
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
          text: 'Add New Address',
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
              'No Addresses Found',
              style: AppTextStyles.headlineSmall(AppColors.primary),
            ),
            const SizedBox(height: 8),
            Text(
              'Add your first address to get started with deliveries',
              style: AppTextStyles.bodyMedium(AppColors.secondaryBrand),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            AppButton(
              text: 'Add Address',
              onPressed: controller.showAddAddressForm,
              width: 200,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressList() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        const SizedBox(height: 16),
        ...controller.addresses.map((address) => _buildAddressCard(address)),
        const SizedBox(height: 100),
      ],
    );
  }

  Widget _buildAddressCard(Address address) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: address.isDefault
              ? AppColors.primary
              : AppColors.grey.withOpacity(0.3),
          width: address.isDefault ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAddressHeader(address),
            const SizedBox(height: 6),
            _buildAddressDetails(address),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressHeader(Address address) {
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
          onTap: () => controller.showEditAddressForm(address),
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

        const SizedBox(width: 8),

        // Delete button
        GestureDetector(
          onTap: () => controller.showDeleteConfirmation(address),
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.lightError.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.delete_outline,
              color: AppColors.lightError,
              size: 16,
            ),
          ),
        ),
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
