/// User profile and address management models
///
/// This file contains all models related to user profile management,
/// address book functionality, and user data operations.

/// Enumeration of user roles in the system
///
/// Defines the different types of users and their access levels
/// in the Cartify e-commerce platform.
enum UserRole {
  /// Standard buyer role with shopping capabilities
  buyer,

  /// Seller role with product management capabilities
  seller,

  /// Administrative role with full system access
  admin,
}

/// Extension to handle UserRole conversion and utilities
extension UserRoleExtension on UserRole {
  /// Convert role to string for API communication
  String get value {
    switch (this) {
      case UserRole.buyer:
        return 'BUYER';
      case UserRole.seller:
        return 'SELLER';
      case UserRole.admin:
        return 'ADMIN';
    }
  }

  /// Create UserRole from string value
  static UserRole fromString(String value) {
    switch (value.toUpperCase()) {
      case 'BUYER':
        return UserRole.buyer;
      case 'SELLER':
        return UserRole.seller;
      case 'ADMIN':
        return UserRole.admin;
      default:
        return UserRole.buyer; // Default to buyer if unknown
    }
  }

  /// Check if user has seller privileges
  bool get canSell => this == UserRole.seller || this == UserRole.admin;

  /// Check if user has admin privileges
  bool get isAdmin => this == UserRole.admin;

  /// Get display name for the role
  String get displayName {
    switch (this) {
      case UserRole.buyer:
        return 'Buyer';
      case UserRole.seller:
        return 'Seller';
      case UserRole.admin:
        return 'Administrator';
    }
  }
}

/// Complete user profile model containing all user information
///
/// Represents the authenticated user's profile data including
/// personal information, role, and account details.
class UserProfile {
  /// Unique identifier for the user
  final String id;

  /// User's phone number (used for authentication)
  final String phoneNumber;

  /// User's display name (optional)
  final String? name;

  /// User's email address (optional)
  final String? email;

  /// URL to the user's profile picture (optional)
  final String? profilePictureUrl;

  /// User's role in the system
  final UserRole role;

  /// Timestamp when the account was created
  final DateTime createdAt;

  /// Timestamp when the profile was last updated
  final DateTime updatedAt;

  const UserProfile({
    required this.id,
    required this.phoneNumber,
    this.name,
    this.email,
    this.profilePictureUrl,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create instance from JSON response
  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    id: json['id'] as String,
    phoneNumber: json['phone_number'] as String,
    name: json['name'] as String?,
    email: json['email'] as String?,
    profilePictureUrl: json['profile_picture_url'] as String?,
    role: UserRoleExtension.fromString(json['role'] as String),
    createdAt: DateTime.parse(json['created_at'] as String),
    updatedAt: DateTime.parse(json['updated_at'] as String),
  );

  /// Convert to JSON for API requests
  Map<String, dynamic> toJson() => {
    'id': id,
    'phone_number': phoneNumber,
    'name': name,
    'email': email,
    'profile_picture_url': profilePictureUrl,
    'role': role.value,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };

  /// Create a copy with updated values
  UserProfile copyWith({
    String? id,
    String? phoneNumber,
    String? name,
    String? email,
    String? profilePictureUrl,
    UserRole? role,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => UserProfile(
    id: id ?? this.id,
    phoneNumber: phoneNumber ?? this.phoneNumber,
    name: name ?? this.name,
    email: email ?? this.email,
    profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
    role: role ?? this.role,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  /// Get display name (name or phone number fallback)
  String get displayName => name ?? phoneNumber;

  /// Check if profile has complete basic information
  bool get isComplete => name != null && name!.isNotEmpty;

  @override
  String toString() =>
      'UserProfile('
      'id: $id, '
      'phoneNumber: $phoneNumber, '
      'name: $name, '
      'role: ${role.displayName})';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfile &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          phoneNumber == other.phoneNumber &&
          name == other.name &&
          email == other.email &&
          profilePictureUrl == other.profilePictureUrl &&
          role == other.role &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode => Object.hash(
    id,
    phoneNumber,
    name,
    email,
    profilePictureUrl,
    role,
    createdAt,
    updatedAt,
  );
}

/// Data transfer object for updating user profile
///
/// Contains only the fields that can be updated by the user.
/// All fields are optional since partial updates are supported.
class UpdateUserProfileDto {
  /// Updated display name
  final String? name;

  /// Updated email address
  final String? email;

  const UpdateUserProfileDto({this.name, this.email});

  /// Convert to JSON for API requests
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    if (name != null) json['name'] = name;
    if (email != null) json['email'] = email;
    return json;
  }

  /// Create instance from JSON
  factory UpdateUserProfileDto.fromJson(Map<String, dynamic> json) =>
      UpdateUserProfileDto(
        name: json['name'] as String?,
        email: json['email'] as String?,
      );

  /// Check if the DTO has any data to update
  bool get hasUpdates => name != null || email != null;

  @override
  String toString() => 'UpdateUserProfileDto(name: $name, email: $email)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UpdateUserProfileDto &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          email == other.email;

  @override
  int get hashCode => Object.hash(name, email);
}

/// Address model for user's shipping and billing addresses
///
/// Represents a complete address with all necessary fields
/// for order delivery and contact information.
class Address {
  /// Unique identifier for the address
  final String id;

  /// User ID who owns this address
  final String userId;

  /// Address label (e.g., "Home", "Office", "Mom's House")
  final String label;

  /// Full name of the recipient
  final String recipientName;

  /// Contact phone number for delivery
  final String phoneNumber;

  /// Street address line 1
  final String addressLine1;

  /// Street address line 2 (optional)
  final String? addressLine2;

  /// City name
  final String city;

  /// State or province
  final String state;

  /// Postal/ZIP code
  final String postalCode;

  /// Country name
  final String country;

  /// Whether this is the default address
  final bool isDefault;

  /// Timestamp when the address was created
  final DateTime createdAt;

  /// Timestamp when the address was last updated
  final DateTime updatedAt;

  const Address({
    required this.id,
    required this.userId,
    required this.label,
    required this.recipientName,
    required this.phoneNumber,
    required this.addressLine1,
    this.addressLine2,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
    required this.isDefault,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create instance from JSON response
  factory Address.fromJson(Map<String, dynamic> json) => Address(
    id: json['id'] as String,
    userId: json['user_id'] as String,
    label: json['label'] as String,
    recipientName: json['recipient_name'] as String,
    phoneNumber: json['phone_number'] as String,
    addressLine1: json['address_line_1'] as String,
    addressLine2: json['address_line_2'] as String?,
    city: json['city'] as String,
    state: json['state'] as String,
    postalCode: json['postal_code'] as String,
    country: json['country'] as String,
    isDefault: json['is_default'] as bool,
    createdAt: DateTime.parse(json['created_at'] as String),
    updatedAt: DateTime.parse(json['updated_at'] as String),
  );

  /// Convert to JSON for API requests
  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'label': label,
    'recipient_name': recipientName,
    'phone_number': phoneNumber,
    'address_line_1': addressLine1,
    'address_line_2': addressLine2,
    'city': city,
    'state': state,
    'postal_code': postalCode,
    'country': country,
    'is_default': isDefault,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };

  /// Create a copy with updated values
  Address copyWith({
    String? id,
    String? userId,
    String? label,
    String? recipientName,
    String? phoneNumber,
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? state,
    String? postalCode,
    String? country,
    bool? isDefault,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Address(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    label: label ?? this.label,
    recipientName: recipientName ?? this.recipientName,
    phoneNumber: phoneNumber ?? this.phoneNumber,
    addressLine1: addressLine1 ?? this.addressLine1,
    addressLine2: addressLine2 ?? this.addressLine2,
    city: city ?? this.city,
    state: state ?? this.state,
    postalCode: postalCode ?? this.postalCode,
    country: country ?? this.country,
    isDefault: isDefault ?? this.isDefault,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  /// Get formatted address string for display
  String get formattedAddress {
    final buffer = StringBuffer(addressLine1);
    if (addressLine2 != null && addressLine2!.isNotEmpty) {
      buffer.write(', $addressLine2');
    }
    buffer.write('\n$city, $state $postalCode');
    buffer.write('\n$country');
    return buffer.toString();
  }

  /// Get single line formatted address
  String get singleLineAddress {
    final buffer = StringBuffer(addressLine1);
    if (addressLine2 != null && addressLine2!.isNotEmpty) {
      buffer.write(', $addressLine2');
    }
    buffer.write(', $city, $state $postalCode, $country');
    return buffer.toString();
  }

  @override
  String toString() =>
      'Address('
      'id: $id, '
      'label: $label, '
      'recipientName: $recipientName, '
      'isDefault: $isDefault)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Address &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          userId == other.userId &&
          label == other.label &&
          recipientName == other.recipientName &&
          phoneNumber == other.phoneNumber &&
          addressLine1 == other.addressLine1 &&
          addressLine2 == other.addressLine2 &&
          city == other.city &&
          state == other.state &&
          postalCode == other.postalCode &&
          country == other.country &&
          isDefault == other.isDefault;

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    label,
    recipientName,
    phoneNumber,
    addressLine1,
    addressLine2,
    city,
    state,
    postalCode,
    country,
    isDefault,
  );
}

/// Data transfer object for creating new addresses
///
/// Contains all required fields for creating a new address.
/// The ID and timestamps will be generated by the server.
class CreateAddressDto {
  /// Address label for easy identification
  final String label;

  /// Full name of the recipient
  final String recipientName;

  /// Contact phone number for delivery
  final String phoneNumber;

  /// Street address line 1
  final String addressLine1;

  /// Street address line 2 (optional)
  final String? addressLine2;

  /// City name
  final String city;

  /// State or province
  final String state;

  /// Postal/ZIP code
  final String postalCode;

  /// Country name
  final String country;

  /// Whether this should be the default address
  final bool isDefault;

  const CreateAddressDto({
    required this.label,
    required this.recipientName,
    required this.phoneNumber,
    required this.addressLine1,
    this.addressLine2,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
    this.isDefault = false,
  });

  /// Convert to JSON for API requests
  Map<String, dynamic> toJson() => {
    'label': label,
    'recipient_name': recipientName,
    'phone_number': phoneNumber,
    'address_line_1': addressLine1,
    'address_line_2': addressLine2,
    'city': city,
    'state': state,
    'postal_code': postalCode,
    'country': country,
    'is_default': isDefault,
  };

  /// Create instance from JSON
  factory CreateAddressDto.fromJson(Map<String, dynamic> json) =>
      CreateAddressDto(
        label: json['label'] as String,
        recipientName: json['recipient_name'] as String,
        phoneNumber: json['phone_number'] as String,
        addressLine1: json['address_line_1'] as String,
        addressLine2: json['address_line_2'] as String?,
        city: json['city'] as String,
        state: json['state'] as String,
        postalCode: json['postal_code'] as String,
        country: json['country'] as String,
        isDefault: json['is_default'] as bool? ?? false,
      );

  @override
  String toString() =>
      'CreateAddressDto('
      'label: $label, '
      'recipientName: $recipientName, '
      'city: $city, '
      'isDefault: $isDefault)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreateAddressDto &&
          runtimeType == other.runtimeType &&
          label == other.label &&
          recipientName == other.recipientName &&
          phoneNumber == other.phoneNumber &&
          addressLine1 == other.addressLine1 &&
          addressLine2 == other.addressLine2 &&
          city == other.city &&
          state == other.state &&
          postalCode == other.postalCode &&
          country == other.country &&
          isDefault == other.isDefault;

  @override
  int get hashCode => Object.hash(
    label,
    recipientName,
    phoneNumber,
    addressLine1,
    addressLine2,
    city,
    state,
    postalCode,
    country,
    isDefault,
  );
}

/// Data transfer object for updating existing addresses
///
/// Contains optional fields for partial address updates.
/// Only provided fields will be updated on the server.
class UpdateAddressDto {
  /// Updated address label
  final String? label;

  /// Updated recipient name
  final String? recipientName;

  /// Updated phone number
  final String? phoneNumber;

  /// Updated street address line 1
  final String? addressLine1;

  /// Updated street address line 2
  final String? addressLine2;

  /// Updated city
  final String? city;

  /// Updated state
  final String? state;

  /// Updated postal code
  final String? postalCode;

  /// Updated country
  final String? country;

  /// Updated default status
  final bool? isDefault;

  const UpdateAddressDto({
    this.label,
    this.recipientName,
    this.phoneNumber,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.state,
    this.postalCode,
    this.country,
    this.isDefault,
  });

  /// Convert to JSON for API requests
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    if (label != null) json['label'] = label;
    if (recipientName != null) json['recipient_name'] = recipientName;
    if (phoneNumber != null) json['phone_number'] = phoneNumber;
    if (addressLine1 != null) json['address_line_1'] = addressLine1;
    if (addressLine2 != null) json['address_line_2'] = addressLine2;
    if (city != null) json['city'] = city;
    if (state != null) json['state'] = state;
    if (postalCode != null) json['postal_code'] = postalCode;
    if (country != null) json['country'] = country;
    if (isDefault != null) json['is_default'] = isDefault;
    return json;
  }

  /// Create instance from JSON
  factory UpdateAddressDto.fromJson(Map<String, dynamic> json) =>
      UpdateAddressDto(
        label: json['label'] as String?,
        recipientName: json['recipient_name'] as String?,
        phoneNumber: json['phone_number'] as String?,
        addressLine1: json['address_line_1'] as String?,
        addressLine2: json['address_line_2'] as String?,
        city: json['city'] as String?,
        state: json['state'] as String?,
        postalCode: json['postal_code'] as String?,
        country: json['country'] as String?,
        isDefault: json['is_default'] as bool?,
      );

  /// Check if the DTO has any data to update
  bool get hasUpdates =>
      label != null ||
      recipientName != null ||
      phoneNumber != null ||
      addressLine1 != null ||
      addressLine2 != null ||
      city != null ||
      state != null ||
      postalCode != null ||
      country != null ||
      isDefault != null;

  @override
  String toString() =>
      'UpdateAddressDto('
      'label: $label, '
      'recipientName: $recipientName, '
      'hasUpdates: $hasUpdates)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UpdateAddressDto &&
          runtimeType == other.runtimeType &&
          label == other.label &&
          recipientName == other.recipientName &&
          phoneNumber == other.phoneNumber &&
          addressLine1 == other.addressLine1 &&
          addressLine2 == other.addressLine2 &&
          city == other.city &&
          state == other.state &&
          postalCode == other.postalCode &&
          country == other.country &&
          isDefault == other.isDefault;

  @override
  int get hashCode => Object.hash(
    label,
    recipientName,
    phoneNumber,
    addressLine1,
    addressLine2,
    city,
    state,
    postalCode,
    country,
    isDefault,
  );
}
