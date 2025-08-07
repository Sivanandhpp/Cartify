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
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.phoneNumber,
    this.name,
    this.email,
    required this.role,
    this.profilePhotoUrl,
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
      createdAt: DateTime.parse(json['created_at']),
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
      'created_at': createdAt.toIso8601String(),
    };
  }
}
