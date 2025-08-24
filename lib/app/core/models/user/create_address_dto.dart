import 'package:cartify/app/core/models/user/address_model.dart';

/// Data Transfer Object for creating a new address.
class CreateAddressDto {
  final String recipientName;
  final String phone;
  final String street;
  final String city;
  final String state;
  final String pincode;
  final String? landmark;
  final AddressType addressType;
  final bool? isDefault;

  CreateAddressDto({
    required this.recipientName,
    required this.phone,
    required this.street,
    required this.city,
    required this.state,
    required this.pincode,
    this.landmark,
    required this.addressType,
    this.isDefault,
  });

  /// Converts the [CreateAddressDto] instance to a JSON map.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'recipient_name': recipientName,
      'phone': phone,
      'street': street,
      'city': city,
      'state': state,
      'pincode': pincode,
      'address_type': addressType.toString().split('.').last,
    };
    if (landmark != null) {
      data['landmark'] = landmark;
    }
    if (isDefault != null) {
      data['is_default'] = isDefault;
    }
    return data;
  }
}