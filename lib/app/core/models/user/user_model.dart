import 'package:cartify/app/core/services/api_clean_url.dart';

/// Represents a user of the application.
///
/// This model contains all the information related to a user's profile.
class UserModel {
  final String id;
  final String phoneNumber;
  final String? name;
  final String? email;
  final String role; // enum: 'buyer', 'seller', 'admin'
  final String? profilePhotoUrl;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserModel({
    required this.id,
    required this.phoneNumber,
    this.name,
    this.email,
    required this.role,
    this.profilePhotoUrl,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  /// Creates a [UserModel] from a JSON object.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      name: json['name'],
      email: json['email'],
      role: json['role'] ?? 'buyer',
      profilePhotoUrl: ApiCleanUrl.cleanImageUrl(json['profile_photo_url']),
      isActive: json['is_active'] ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  /// Converts a [UserModel] instance to a JSON object.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone_number': phoneNumber,
      'name': name,
      'email': email,
      'role': role,
      'profile_photo_url': profilePhotoUrl,
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// Check if user has a valid profile picture
  bool get hasProfilePicture =>
      profilePhotoUrl != null && profilePhotoUrl!.isNotEmpty;
}
