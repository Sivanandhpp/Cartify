// lib/app/core/models/user/address_model.dart

import 'package:flutter/material.dart';

/// Represents a user's shipping address.
enum AddressType { HOME, WORK, HOSTEL, OTHER }

class Address {
  final String id;
  final String recipientName;
  final String phone;
  final String street;
  final String city;
  final String state;
  final String pincode;
  final String? landmark;
  final AddressType addressType;
  final bool isDefault;

  Address({
    required this.id,
    required this.recipientName,
    required this.phone,
    required this.street,
    required this.city,
    required this.state,
    required this.pincode,
    this.landmark,
    required this.addressType,
    required this.isDefault,
  });

  /// Creates an [Address] from a JSON object.
  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'],
      recipientName: json['recipient_name'],
      phone: json['phone'],
      street: json['street'],
      city: json['city'],
      state: json['state'],
      pincode: json['pincode'],
      landmark: json['landmark'],
      addressType: AddressType.values.firstWhere(
        (e) => e.toString().split('.').last == json['address_type'],
        orElse: () => AddressType.HOME,
      ),
      isDefault: json['is_default'] ?? false,
    );
  }

  /// Creates an [Address] from order shipping address JSON (which may have different structure)
  factory Address.fromOrderShippingJson(Map<String, dynamic> json) {
    return Address(
      // Generate a temporary ID for order shipping addresses that don't have one
      id:
          json['id']?.toString() ??
          'temp_${DateTime.now().millisecondsSinceEpoch}',
      recipientName: json['recipient_name']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      street: json['street']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      state: json['state']?.toString() ?? '',
      pincode: json['pincode']?.toString() ?? '',
      landmark: json['landmark']?.toString(),
      addressType: AddressType.values.firstWhere(
        (e) => e.toString().split('.').last == json['address_type'],
        orElse: () => AddressType.HOME,
      ),
      isDefault: false, // Order shipping addresses are not default addresses
    );
  }

  /// Converts the [Address] to a JSON object.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'recipient_name': recipientName,
      'phone': phone,
      'street': street,
      'city': city,
      'state': state,
      'pincode': pincode,
      'landmark': landmark,
      'address_type': addressType.toString().split('.').last,
      'is_default': isDefault,
    };
  }

  /// Validates if the address has all required fields
  bool get isValid {
    return recipientName.isNotEmpty &&
        phone.isNotEmpty &&
        street.isNotEmpty &&
        city.isNotEmpty &&
        state.isNotEmpty &&
        pincode.isNotEmpty;
  }

  /// Gets formatted address string for display
  String get formattedAddress {
    final parts = [street, city, state, pincode];
    if (landmark?.isNotEmpty == true) {
      parts.insert(1, landmark!);
    }
    return parts.join(', ');
  }

  /// Gets the appropriate icon for the address type
  IconData get icon {
    switch (addressType) {
      case AddressType.HOME:
        return Icons.home;
      case AddressType.WORK:
        return Icons.work;
      case AddressType.HOSTEL:
        return Icons.school;
      case AddressType.OTHER:
        return Icons.location_on;
    }
  }
}
