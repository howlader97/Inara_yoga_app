class AppUserData {
  final String email;
  final String name;
  final String bio;
  final String avatar;
  final String id;
  final String role;
  final bool isActive;
  final bool isVerified;
  final String phone;
  final String gender;
  final String createdAt;

  const AppUserData({
    this.email = '',
    this.name = '',
    this.bio = '',
    this.avatar = '',
    this.id = '',
    this.role = '',
    this.isActive = false,
    this.isVerified = false,
    this.phone = '',
    this.gender = '',
    this.createdAt = '',
  });

  /// Empty factory
  factory AppUserData.empty() => const AppUserData();

  /// From JSON
  factory AppUserData.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const AppUserData();
    }

    return AppUserData(
      email: json['email']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      bio: json['bio']?.toString() ?? '',
      avatar: json['avatar']?.toString() ?? '',
      id: json['id']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
      isActive: json['isActive'] is bool ? json['isActive'] : false,
      isVerified: json['isVerified'] is bool ? json['isVerified'] : false,
      phone: json['phone']?.toString() ?? '',
      gender: json['gender']?.toString() ?? '',
      createdAt: json['createdAt']?.toString() ?? '',
    );
  }

  /// To JSON
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'bio': bio,
      'avatar': avatar,
      'id': id,
      'role': role,
      'isActive': isActive,
      'isVerified': isVerified,
      'phone': phone,
      'gender': gender,
      'createdAt': createdAt,
    };
  }

  /// CopyWith
  AppUserData copyWith({
    String? email,
    String? name,
    String? bio,
    String? avatar,
    String? id,
    String? role,
    bool? isActive,
    bool? isVerified,
    String? phone,
    String? gender,
    String? createdAt,
  }) {
    return AppUserData(
      email: email ?? this.email,
      name: name ?? this.name,
      bio: bio ?? this.bio,
      avatar: avatar ?? this.avatar,
      id: id ?? this.id,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      isVerified: isVerified ?? this.isVerified,
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'AppUserData(email: $email, name: $name, id: $id)';
  }
}
