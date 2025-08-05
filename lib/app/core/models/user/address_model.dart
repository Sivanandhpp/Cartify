// lib/app/core/models/user/address_model.dart

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
      ),
      isDefault: json['is_default'],
    );
  }
}
