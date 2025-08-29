// lib/app/core/models/user/user_model.dart

/// Represents a user of the application.
///
/// This model contains all the information related to a user's profile.
class UserModel {
  final String id;
  final String phoneNumber;
  final String? name;
  final String? email;
  final String role;
  final String? profilePhotoUrl;
  final bool isActive;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.phoneNumber,
    this.name,
    this.email,
    required this.role,
    this.profilePhotoUrl,
    required this.isActive,
    required this.createdAt,
  });

  /// Creates a [UserModel] from a JSON object.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      phoneNumber: json['phone_number'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      profilePhotoUrl: json['profile_photo_url'],
      isActive: json['is_active'] ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
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
      'created_at': createdAt.toIso8601String(),
    };
  }
}
