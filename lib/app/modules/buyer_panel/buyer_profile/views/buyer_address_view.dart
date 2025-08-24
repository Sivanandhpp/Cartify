import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/index.dart';
import '../controllers/buyer_address_controller.dart';
import 'widgets/address_form.dart';

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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: controller.showAddAddressForm,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add Address'),
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
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      itemCount: controller.addresses.length,
      itemBuilder: (context, index) {
        final address = controller.addresses[index];
        return _buildAddressCard(address);
      },
    );
  }

  Widget _buildAddressCard(Address address) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: address.isDefault ? AppColors.primary : AppColors.grey,
          width: address.isDefault ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with type and default badge
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      controller.getAddressTypeIcon(address.addressType),
                      size: 16,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      controller.getAddressTypeLabel(address.addressType),
                      style: AppTextStyles.labelSmall(AppColors.primary),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (address.isDefault)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.darkSuccess.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'DEFAULT',
                    style: AppTextStyles.labelSmall(AppColors.darkSuccess),
                  ),
                ),
              const Spacer(),
              // Action buttons
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => controller.showEditAddressForm(address),
                    icon: const Icon(Icons.edit_outlined),
                    color: AppColors.primary,
                    iconSize: 20,
                  ),
                  IconButton(
                    onPressed: () => controller.showDeleteConfirmation(address),
                    icon: const Icon(Icons.delete_outline),
                    color: AppColors.lightError,
                    iconSize: 20,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Recipient info
          Text(
            address.recipientName,
            style: AppTextStyles.titleMedium(AppColors.primary),
          ),
          const SizedBox(height: 4),
          Text(
            address.phone,
            style: AppTextStyles.bodyMedium(AppColors.secondaryBrand),
          ),
          const SizedBox(height: 8),

          // Address details
          Text(
            address.street,
            style: AppTextStyles.bodyMedium(AppColors.primary),
          ),
          const SizedBox(height: 4),
          Text(
            '${address.city}, ${address.state} - ${address.pincode}',
            style: AppTextStyles.bodyMedium(AppColors.secondaryBrand),
          ),
          if (address.landmark != null) ...[
            const SizedBox(height: 4),
            Text(
              'Near ${address.landmark}',
              style: AppTextStyles.bodySmall(AppColors.secondaryBrand),
            ),
          ],
        ],
      ),
    );
  }
}