import 'package:cartify/app/core/models/user/update_address_dto.dart';
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
  
  String _selectedAddressType = 'HOME';
  bool _isDefault = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _recipientNameController = TextEditingController(text: widget.address?.recipientName ?? '');
    _phoneController = TextEditingController(text: widget.address?.phone ?? '');
    _streetController = TextEditingController(text: widget.address?.street ?? '');
    _cityController = TextEditingController(text: widget.address?.city ?? '');
    _stateController = TextEditingController(text: widget.address?.state ?? '');
    _pincodeController = TextEditingController(text: widget.address?.pincode ?? '');
    _landmarkController = TextEditingController(text: widget.address?.landmark ?? '');
    
    if (widget.address != null) {
      _selectedAddressType = widget.address!.addressType.toString().split('.').last;
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
    // required String? Function(String?) validator,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.medium),
      child: TextFormField(
        controller: controller,
        // validator: validator,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
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
      child: DropdownButtonFormField<String>(
        value: _selectedAddressType,
        decoration: InputDecoration(
          labelText: 'Address Type',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.medium,
            vertical: AppSpacing.small,
          ),
        ),
        items: ['HOME', 'WORK', 'HOSTEL', 'OTHER']
            .map((type) => DropdownMenuItem(
                  value: type,
                  child: Text(type),
                ))
            .toList(),
        onChanged: (value) {
          setState(() {
            _selectedAddressType = value!;
          });
        },
      ),
    );
  }

  Widget _buildDefaultAddressSwitch() {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.large),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Set as default address',
            style: TextStyle(fontSize: 16),
          ),
          Switch(
            value: _isDefault,
            onChanged: (value) {
              setState(() {
                _isDefault = value;
              });
            },
          ),
        ],
      ),
    );
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
          recipientName: _recipientNameController.text,
          phone: _phoneController.text,
          street: _streetController.text,
          city: _cityController.text,
          state: _stateController.text,
          pincode: _pincodeController.text,
          landmark: _landmarkController.text.isEmpty ? null : _landmarkController.text,
          addressType: _selectedAddressType,
          isDefault: _isDefault,
        );
        
        final result = await _userService.addAddress(dto);
        if (result != null) {
          Get.back(result: true);
          Get.snackbar('Success', 'Address added successfully');
        }
      } else {
        // Update existing address
        final dto = UpdateAddressDto(
          recipientName: _recipientNameController.text,
          phone: _phoneController.text,
          street: _streetController.text,
          city: _cityController.text,
          state: _stateController.text,
          pincode: _pincodeController.text,
          landmark: _landmarkController.text.isEmpty ? null : _landmarkController.text,
          addressType: _selectedAddressType,
          isDefault: _isDefault,
        );
        
        final result = await _userService.updateAddress(widget.address!.id, dto as CreateAddressDto);
        if (result != null) {
          Get.back(result: true);
          Get.snackbar('Success', 'Address updated successfully');
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to save address');
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
        title: Text(widget.address == null ? 'Add Address' : 'Edit Address'),
        centerTitle: true,
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
                // validator: AppValidators.required,
              ),
              _buildTextField(
                controller: _phoneController,
                label: 'Phone Number',
                // validator: AppValidators.phone,
                keyboardType: TextInputType.phone,
              ),
              _buildTextField(
                controller: _streetController,
                label: 'Street Address',
                // validator: AppValidators.required,
                maxLines: 2,
              ),
              _buildTextField(
                controller: _cityController,
                label: 'City',
                // validator: AppValidators.required,
              ),
              _buildTextField(
                controller: _stateController,
                label: 'State',
                // validator: AppValidators.required,
              ),
              _buildTextField(
                controller: _pincodeController,
                label: 'Pincode',
                // validator: AppValidators.required,
                keyboardType: TextInputType.number,
              ),
              _buildTextField(
                controller: _landmarkController,
                label: 'Landmark (Optional)',
                // validator: null,
              ),
              _buildAddressTypeDropdown(),
              _buildDefaultAddressSwitch(),
              const SizedBox(height: AppSpacing.large),
              AppButton(
                text: widget.address == null ? 'Add Address' : 'Update Address',
                onPressed:() {
                  
                },
                //  _isLoading ? null : _saveAddress,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}