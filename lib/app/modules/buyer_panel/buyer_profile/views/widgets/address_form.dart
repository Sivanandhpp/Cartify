import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cartify/app/core/index.dart';

class AddressFormView extends StatefulWidget {
  final Address? address; // null for add, existing address for edit

  const AddressFormView({super.key, this.address});

  @override
  State<AddressFormView> createState() => _AddressFormViewState();
}

class _AddressFormViewState extends State<AddressFormView> {
  final _formKey = GlobalKey<FormState>();
  final UserService _userService = Get.find<UserService>();

  late TextEditingController _recipientNameController;
  late TextEditingController _phoneController;
  late TextEditingController _streetController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _pincodeController;
  late TextEditingController _landmarkController;

  AddressType _selectedAddressType = AddressType.HOME;
  bool _isDefault = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _recipientNameController = TextEditingController(
      text: widget.address?.recipientName ?? '',
    );
    _phoneController = TextEditingController(text: widget.address?.phone ?? '');
    _streetController = TextEditingController(
      text: widget.address?.street ?? '',
    );
    _cityController = TextEditingController(text: widget.address?.city ?? '');
    _stateController = TextEditingController(text: widget.address?.state ?? '');
    _pincodeController = TextEditingController(
      text: widget.address?.pincode ?? '',
    );
    _landmarkController = TextEditingController(
      text: widget.address?.landmark ?? '',
    );

    if (widget.address != null) {
      _selectedAddressType = widget.address!.addressType;
      _isDefault = widget.address!.isDefault;
    }
  }

  @override
  void dispose() {
    _recipientNameController.dispose();
    _phoneController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();
    _landmarkController.dispose();
    super.dispose();
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.medium),
      child: TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.medium,
            vertical: AppSpacing.small,
          ),
        ),
      ),
    );
  }

  Widget _buildAddressTypeDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.medium),
      child: DropdownButtonFormField<AddressType>(
        value: _selectedAddressType,
        decoration: InputDecoration(
          labelText: 'Address Type',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.medium,
            vertical: AppSpacing.small,
          ),
        ),
        items: AddressType.values
            .map(
              (type) => DropdownMenuItem(
                value: type,
                child: Text(_getAddressTypeLabel(type)),
              ),
            )
            .toList(),
        onChanged: (value) {
          if (value != null) {
            setState(() {
              _selectedAddressType = value;
            });
          }
        },
      ),
    );
  }

  String _getAddressTypeLabel(AddressType type) {
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

  Widget _buildDefaultAddressSwitch() {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.large),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Set as default address', style: TextStyle(fontSize: 16)),
          Switch(
            value: _isDefault,
            onChanged: (value) {
              setState(() {
                _isDefault = value;
              });
            },
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  String? _validateRequired(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    if (value.length != 10) {
      return 'Enter a valid 10-digit phone number';
    }
    return null;
  }

  String? _validatePincode(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Pincode is required';
    }
    if (value.length != 6) {
      return 'Enter a valid 6-digit pincode';
    }
    return null;
  }

  Future<void> _saveAddress() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      if (widget.address == null) {
        // Add new address
        final dto = CreateAddressDto(
          recipientName: _recipientNameController.text.trim(),
          phone: _phoneController.text.trim(),
          street: _streetController.text.trim(),
          city: _cityController.text.trim(),
          state: _stateController.text.trim(),
          pincode: _pincodeController.text.trim(),
          landmark: _landmarkController.text.trim().isEmpty
              ? null
              : _landmarkController.text.trim(),
          addressType: _selectedAddressType,
          isDefault: _isDefault,
        );

        final result = await _userService.createAddress(dto);
        if (result != null) {
          Get.back(result: true);
          NotificationService.showSuccess(
            title: 'Success',
            message: 'Address added successfully',
          );
        } else {
          NotificationService.showError(
            title: 'Error',
            message: 'Failed to add address',
          );
        }
      } else {
        // Update existing address
        final dto = UpdateAddressDto(
          recipientName: _recipientNameController.text.trim(),
          phone: _phoneController.text.trim(),
          street: _streetController.text.trim(),
          city: _cityController.text.trim(),
          state: _stateController.text.trim(),
          pincode: _pincodeController.text.trim(),
          landmark: _landmarkController.text.trim().isEmpty
              ? null
              : _landmarkController.text.trim(),
          addressType: _selectedAddressType,
          isDefault: _isDefault,
        );

        final result = await _userService.updateAddress(
          widget.address!.id,
          dto,
        );
        if (result != null) {
          Get.back(result: true);
          NotificationService.showSuccess(
            title: 'Success',
            message: 'Address updated successfully',
          );
        } else {
          NotificationService.showError(
            title: 'Error',
            message: 'Failed to update address',
          );
        }
      }
    } catch (e) {
      NotificationService.showError(
        title: 'Error',
        message: 'Failed to save address: $e',
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.address == null ? 'Add Address' : 'Edit Address',
          style: const TextStyle(
            color: AppColors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.medium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTextField(
                controller: _recipientNameController,
                label: 'Recipient Name',
                validator: _validateRequired,
              ),
              _buildTextField(
                controller: _phoneController,
                label: 'Phone Number',
                validator: _validatePhone,
                keyboardType: TextInputType.phone,
              ),
              _buildTextField(
                controller: _streetController,
                label: 'Street Address',
                validator: _validateRequired,
                maxLines: 2,
              ),
              _buildTextField(
                controller: _cityController,
                label: 'City',
                validator: _validateRequired,
              ),
              _buildTextField(
                controller: _stateController,
                label: 'State',
                validator: _validateRequired,
              ),
              _buildTextField(
                controller: _pincodeController,
                label: 'Pincode',
                validator: _validatePincode,
                keyboardType: TextInputType.number,
              ),
              _buildTextField(
                controller: _landmarkController,
                label: 'Landmark (Optional)',
              ),
              _buildAddressTypeDropdown(),
              _buildDefaultAddressSwitch(),
              const SizedBox(height: AppSpacing.large),
              AppButton(
                text: widget.address == null ? 'Add Address' : 'Update Address',
                onPressed: _saveAddress,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
