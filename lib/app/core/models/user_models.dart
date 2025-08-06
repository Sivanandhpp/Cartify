/// User profile and address related models for Cartify
/// These models handle user data structures and address management

/// Model for user profile information
class UserProfile {
  final String id;
  final String? name;
  final String phoneNumber;
  final String? email;
  final String? profilePictureUrl;
  final String role;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserProfile({
    required this.id,
    this.name,
    required this.phoneNumber,
    this.email,
    this.profilePictureUrl,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create from JSON response
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] ?? '',
      name: json['name'],
      phoneNumber: json['phone_number'] ?? '',
      email: json['email'],
      profilePictureUrl: json['profile_picture_url'],
      role: json['role'] ?? 'BUYER',
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updated_at'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  /// Convert to JSON for API requests
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone_number': phoneNumber,
      'email': email,
      'profile_picture_url': profilePictureUrl,
      'role': role,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Create a copy with updated fields
  UserProfile copyWith({
    String? id,
    String? name,
    String? phoneNumber,
    String? email,
    String? profilePictureUrl,
    String? role,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Model for updating user profile
class UpdateUserProfileDto {
  final String? name;
  final String? email;

  const UpdateUserProfileDto({this.name, this.email});

  /// Convert to JSON for API requests
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (name != null) data['name'] = name;
    if (email != null) data['email'] = email;
    return data;
  }
}

/// Model for user address
class UserAddress {
  final String id;
  final String title;
  final String fullName;
  final String phoneNumber;
  final String addressLine1;
  final String? addressLine2;
  final String city;
  final String state;
  final String pincode;
  final String? landmark;
  final bool isDefault;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserAddress({
    required this.id,
    required this.title,
    required this.fullName,
    required this.phoneNumber,
    required this.addressLine1,
    this.addressLine2,
    required this.city,
    required this.state,
    required this.pincode,
    this.landmark,
    required this.isDefault,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create from JSON response
  factory UserAddress.fromJson(Map<String, dynamic> json) {
    return UserAddress(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      fullName: json['full_name'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      addressLine1: json['address_line_1'] ?? '',
      addressLine2: json['address_line_2'],
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      pincode: json['pincode'] ?? '',
      landmark: json['landmark'],
      isDefault: json['is_default'] ?? false,
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updated_at'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  /// Convert to JSON for API requests
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'full_name': fullName,
      'phone_number': phoneNumber,
      'address_line_1': addressLine1,
      'address_line_2': addressLine2,
      'city': city,
      'state': state,
      'pincode': pincode,
      'landmark': landmark,
      'is_default': isDefault,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Get formatted address as a single string
  String get formattedAddress {
    final buffer = StringBuffer();
    buffer.write(addressLine1);
    if (addressLine2 != null && addressLine2!.isNotEmpty) {
      buffer.write(', $addressLine2');
    }
    if (landmark != null && landmark!.isNotEmpty) {
      buffer.write(', $landmark');
    }
    buffer.write(', $city, $state - $pincode');
    return buffer.toString();
  }
}

/// Model for creating or updating address
class CreateAddressDto {
  final String title;
  final String fullName;
  final String phoneNumber;
  final String addressLine1;
  final String? addressLine2;
  final String city;
  final String state;
  final String pincode;
  final String? landmark;
  final bool isDefault;

  const CreateAddressDto({
    required this.title,
    required this.fullName,
    required this.phoneNumber,
    required this.addressLine1,
    this.addressLine2,
    required this.city,
    required this.state,
    required this.pincode,
    this.landmark,
    this.isDefault = false,
  });

  /// Convert to JSON for API requests
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'full_name': fullName,
      'phone_number': phoneNumber,
      'address_line_1': addressLine1,
      'address_line_2': addressLine2,
      'city': city,
      'state': state,
      'pincode': pincode,
      'landmark': landmark,
      'is_default': isDefault,
    };
  }
}
