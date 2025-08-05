// lib/app/core/models/user/update_user_dto.dart

/// Data Transfer Object for updating a user's profile.
///
/// This class is used to send the updated user information to the backend.
class UpdateUserDto {
  final String? name;
  final String? email;

  UpdateUserDto({this.name, this.email});

  /// Converts the [UpdateUserDto] instance to a JSON map.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (name != null) {
      data['name'] = name;
    }
    if (email != null) {
      data['email'] = email;
    }
    return data;
  }
}
