import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/index.dart';

class AddressFormWidget extends StatefulWidget {
  final Address? address;
  final Function(CreateAddressDto) onSubmit;
  final bool isLoading;

  const AddressFormWidget({
    super.key,
    this.address,
    required this.onSubmit,
    this.isLoading = false,
  });

  @override
  State<AddressFormWidget> createState() => _AddressFormWidgetState();
}

class _AddressFormWidgetState extends State<AddressFormWidget> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _streetController;
  late final TextEditingController _cityController;
  late final TextEditingController _stateController;
  late final TextEditingController _pincodeController;
  late final TextEditingController _landmarkController;
  
  AddressType _selectedType = AddressType.HOME;
  bool _isDefault = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    final address = widget.address;
    _nameController = TextEditingController(text: address?.recipientName ?? '');
    _phoneController = TextEditingController(text: address?.phone ?? '');
    _streetController = TextEditingController(text: address?.street ?? '');
    _cityController = TextEditingController(text: address?.city ?? '');
    _stateController = TextEditingController(text: address?.state ?? '');
    _pincodeController = TextEditingController(text: address?.pincode ?? '');
    _landmarkController = TextEditingController(text: address?.landmark ?? '');
    
    if (address != null) {
      _selectedType = address.addressType;
      _isDefault = address.isDefault;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();
    _landmarkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Text(
                  widget.address == null ? 'Add New Address' : 'Edit Address',
                  style: AppTextStyles.headlineSmall(AppColors.primary),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: AppColors.secondaryBrand),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Form fields
            _buildTextField(
              controller: _nameController,
              label: 'Full Name',
              hint: 'Enter recipient name',
              validator: (value) => value?.isEmpty == true ? 'Name is required' : null,
            ),
            const SizedBox(height: 16),

            _buildTextField(
              controller: _phoneController,
              label: 'Phone Number',
              hint: 'Enter phone number',
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value?.isEmpty == true) return 'Phone number is required';
                if (value!.length != 10) return 'Enter valid 10-digit phone number';
                return null;
              },
            ),
            const SizedBox(height: 16),

            _buildTextField(
              controller: _streetController,
              label: 'Street Address',
              hint: 'House No, Building, Street',
              maxLines: 2,
              validator: (value) => value?.isEmpty == true ? 'Street address is required' : null,
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _cityController,
                    label: 'City',
                    hint: 'Enter city',
                    validator: (value) => value?.isEmpty == true ? 'City is required' : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    controller: _stateController,
                    label: 'State',
                    hint: 'Enter state',
                    validator: (value) => value?.isEmpty == true ? 'State is required' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    controller: _pincodeController,
                    label: 'Pincode',
                    hint: 'Enter pincode',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value?.isEmpty == true) return 'Pincode is required';
                      if (value!.length != 6) return 'Enter valid 6-digit pincode';
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField(
                    controller: _landmarkController,
                    label: 'Landmark (Optional)',
                    hint: 'Nearby landmark',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Address type selection
            Text(
              'Address Type',
              style: AppTextStyles.labelMedium(AppColors.primary),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: AddressType.values.map((type) {
                final isSelected = _selectedType == type;
                return ChoiceChip(
                  label: Text(_getAddressTypeLabel(type)),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() => _selectedType = type);
                    }
                  },
                  selectedColor: AppColors.primary.withOpacity(0.2),
                  labelStyle: TextStyle(
                    color: isSelected ? AppColors.primary : AppColors.secondaryBrand,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Default address toggle
            Row(
              children: [
                Checkbox(
                  value: _isDefault,
                  onChanged: (value) => setState(() => _isDefault = value ?? false),
                  activeColor: AppColors.primary,
                ),
                Text(
                  'Set as default address',
                  style: AppTextStyles.bodyMedium(AppColors.primary),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Submit button
            AppButton(
              text: widget.address == null ? 'Add Address' : 'Update Address',
              onPressed: _handleSubmit,
              isLoading: widget.isLoading,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.labelMedium(AppColors.primary),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.bodyMedium(AppColors.secondaryBrand),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.background),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.background),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.lightError),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            filled: true,
            fillColor: AppColors.background,
          ),
        ),
      ],
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

  void _handleSubmit() {
    if (_formKey.currentState?.validate() == true) {
      final dto = CreateAddressDto(
        recipientName: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        street: _streetController.text.trim(),
        city: _cityController.text.trim(),
        state: _stateController.text.trim(),
        pincode: _pincodeController.text.trim(),
        landmark: _landmarkController.text.trim().isEmpty ? null : _landmarkController.text.trim(),
        addressType: _selectedType,
        isDefault: _isDefault,
      );
      widget.onSubmit(dto);
    }
  }
}