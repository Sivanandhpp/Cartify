import 'package:cartify/app/modules/buyer_panel/buyer_profile/views/widgets/address_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/index.dart';

class BuyerAddressController extends GetxController {
  final UserService _userService = Get.find<UserService>();

  // Reactive state
  final RxList<Address> addresses = <Address>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadAddresses();
  }

  /// Loads all user addresses
  Future<void> loadAddresses() async {
    try {
      isLoading.value = true;
      final result = await _userService.getAddresses();
      addresses.value = result;
    } catch (e) {
      NotificationService.showError(title: 'Failed', message: 'Failed to load addresses');
      LogService.error('Error loading addresses', e);
    } finally {
      isLoading.value = false;
    }
  }

  /// Refreshes the addresses list
  Future<void> refreshAddresses() async {
    await loadAddresses();
  }

  /// Shows the add address form
  void showAddAddressForm() async {
    final result = await Get.to(() => const AddressFormView());
    if (result == true) {
      await loadAddresses(); // Refresh the list after adding
    }
  }

  /// Shows the edit address form
  void showEditAddressForm(Address address) async {
    final result = await Get.to(() => AddressFormView(address: address));
    if (result == true) {
      await loadAddresses(); // Refresh the list after editing
    }
  }

  /// Shows delete confirmation dialog
  void showDeleteConfirmation(Address address) {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Delete Address',
          style: AppTextStyles.headlineSmall(AppColors.primary),
        ),
        content: Text(
          'Are you sure you want to delete this address? This action cannot be undone.',
          style: AppTextStyles.bodyMedium(AppColors.secondaryBrand),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: AppTextStyles.labelMedium(AppColors.secondaryBrand),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              deleteAddress(address.id);
            },
            child: Text(
              'Delete',
              style: AppTextStyles.labelMedium(AppColors.lightError),
            ),
          ),
        ],
      ),
    );
  }

  /// Deletes an address
  Future<void> deleteAddress(String addressId) async {
    try {
      final success = await _userService.deleteAddress(addressId);
      
      if (success) {
        addresses.removeWhere((addr) => addr.id == addressId);
        NotificationService.showSuccess(title: 'Success', message: 'Address deleted successfully');
      } else {
        NotificationService.showError(title: 'Failed', message: 'Failed to delete address');
      }
    } catch (e) {
      NotificationService.showError(title: 'Failed', message: 'Failed to delete address');
      LogService.error('Error deleting address', e);
    }
  }

  /// Gets the address type icon
  IconData getAddressTypeIcon(AddressType type) {
    switch (type) {
      case AddressType.HOME:
        return Icons.home_outlined;
      case AddressType.WORK:
        return Icons.business_outlined;
      case AddressType.HOSTEL:
        return Icons.school_outlined;
      case AddressType.OTHER:
        return Icons.location_on_outlined;
    }
  }

  /// Gets the address type label
  String getAddressTypeLabel(AddressType type) {
    switch (type) {
      case AddressType.HOME:
        return 'Home';
      case AddressType.WORK:
        return 'Work';
      case AddressType.HOSTEL:
        return 'Hostel';
      case AddressType.OTHER:
        return 'Other';
    }
  }
}