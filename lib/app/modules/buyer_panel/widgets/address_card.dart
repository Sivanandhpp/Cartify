import 'package:flutter/material.dart';
import '../../../core/index.dart';
import '../buyer_profile/controllers/buyer_address_controller.dart';

class AddressCard extends StatelessWidget {
  final Address address;
  final BuyerAddressController controller;
  final VoidCallback? onTap;
  final bool isSelected;
  final bool showEditButton;
  final bool showDeleteButton;
  final bool showSelectionIndicator;

  const AddressCard({
    super.key,
    required this.address,
    required this.controller,
    this.onTap,
    this.isSelected = false,
    this.showEditButton = true,
    this.showDeleteButton = false,
    this.showSelectionIndicator = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected
              ? AppColors.primary
              : AppColors.grey.withOpacity(0.3),
          width: isSelected || address.isDefault ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAddressHeader(),
                const SizedBox(height: 12),
                _buildAddressDetails(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddressHeader() {
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

        // Action buttons
        _buildActionButtons(),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Edit button
        if (showEditButton)
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
        // Delete button
        if (showDeleteButton)
          Row(
            children: [
              const SizedBox(width: 8),
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
          ),

        // Selection indicator
        if (showSelectionIndicator && isSelected)
          // if (showEditButton || showDeleteButton) const SizedBox(width: 12),
          Row(
            children: [
              const SizedBox(width: 8),

              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 16),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildAddressDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          address.recipientName,
          style: AppTextStyles.titleMedium(AppColors.primary),
        ),
        const SizedBox(height: 2),
        Text(
          address.phone,
          style: AppTextStyles.bodyMedium(AppColors.secondaryBrand),
        ),
        const SizedBox(height: 8),
        Text(
          address.street,
          style: AppTextStyles.bodyMedium(AppColors.primary),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          '${address.city}, ${address.state} - ${address.pincode}',
          style: AppTextStyles.bodyMedium(AppColors.secondaryBrand),
        ),
        if (address.landmark != null && address.landmark!.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            'Near ${address.landmark}',
            style: AppTextStyles.bodySmall(AppColors.secondaryBrand),
          ),
        ],
      ],
    );
  }
}
