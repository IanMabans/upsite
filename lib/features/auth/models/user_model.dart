/// User model for authentication.
///
/// Represents the authenticated user returned from Laravel API.
/// Contains user profile information and auth token.
class UserModel {
  final int id;
  final String name;
  final String email;
  final String? emailVerifiedAt;
  final String? profilePhotoUrl;
  final String? token;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.emailVerifiedAt,
    this.profilePhotoUrl,
    this.token,
    this.createdAt,
    this.updatedAt,
  });

  /// Create UserModel from JSON response.
  ///
  /// Handles Laravel API response format where user data
  /// may be nested in 'user' key or at root level.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Handle nested 'user' object from login/register response
    final userData = json['user'] ?? json;
    final token = json['token'] as String?;

    return UserModel(
      id: userData['id'] as int,
      name: userData['name'] as String,
      email: userData['email'] as String,
      emailVerifiedAt: userData['email_verified_at'] as String?,
      profilePhotoUrl: userData['profile_photo_url'] as String?,
      token: token,
      createdAt: userData['created_at'] != null
          ? DateTime.tryParse(userData['created_at'] as String)
          : null,
      updatedAt: userData['updated_at'] != null
          ? DateTime.tryParse(userData['updated_at'] as String)
          : null,
    );
  }

  /// Convert UserModel to JSON for API requests.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'email_verified_at': emailVerifiedAt,
      'profile_photo_url': profilePhotoUrl,
    };
  }

  /// Check if email is verified
  bool get isEmailVerified => emailVerifiedAt != null;

  /// Get user initials for avatar
  String get initials {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  /// Create a copy with updated fields
  UserModel copyWith({
    int? id,
    String? name,
    String? email,
    String? emailVerifiedAt,
    String? profilePhotoUrl,
    String? token,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      token: token ?? this.token,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email)';
  }
}
