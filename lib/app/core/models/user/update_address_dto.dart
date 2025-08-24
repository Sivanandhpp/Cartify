import 'package:cartify/app/core/models/user/address_model.dart';

class UpdateAddressDto {
  final String? recipientName;
  final String? phone;
  final String? street;
  final String? city;
  final String? state;
  final String? pincode;
  final String? landmark;
  final AddressType? addressType;
  final bool? isDefault;

  UpdateAddressDto({
    this.recipientName,
    this.phone,
    this.street,
    this.city,
    this.state,
    this.pincode,
    this.landmark,
    this.addressType,
    this.isDefault,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (recipientName != null) data['recipient_name'] = recipientName;
    if (phone != null) data['phone'] = phone;
    if (street != null) data['street'] = street;
    if (city != null) data['city'] = city;
    if (state != null) data['state'] = state;
    if (pincode != null) data['pincode'] = pincode;
    if (landmark != null) data['landmark'] = landmark;
    if (addressType != null) data['address_type'] = addressType.toString().split('.').last;
    if (isDefault != null) data['is_default'] = isDefault;
    return data;
  }
}