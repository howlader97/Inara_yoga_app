class InstructorModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String avatar;
  final String backgroundImage;
  final String speciality;
  final String? bio;
  final DateTime joinedAt;
  final List<UpcomingClassModel> upcomingClasses;

  InstructorModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.avatar,
    required this.backgroundImage,
    required this.speciality,
    this.bio,
    required this.joinedAt,
    required this.upcomingClasses,
  });

  factory InstructorModel.fromJson(Map<String, dynamic> json) {
    return InstructorModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      avatar: json['avatar'] ?? '',
      backgroundImage: json['backgroundImage'] ?? '',
      speciality: json['speciality'] ?? '',
      bio: json['bio'],
      joinedAt: DateTime.parse(json['joinedAt']),
      upcomingClasses: (json['upcomingClasses'] as List<dynamic>? ?? [])
          .map((e) => UpcomingClassModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'avatar': avatar,
      'backgroundImage': backgroundImage,
      'speciality': speciality,
      'bio': bio,
      'joinedAt': joinedAt.toIso8601String(),
      'upcomingClasses': upcomingClasses.map((e) => e.toJson()).toList(),
    };
  }
}

class UpcomingClassModel {
  final String id;
  final String title;
  final String difficulty;
  final DateTime scheduledAt;
  final String duration;
  final double price;
  final String gender;
  final int availableSpots;
  final int totalSpots;
  final String instructorName;
  final String instructorAvatar;

  UpcomingClassModel({
    required this.id,
    required this.title,
    required this.difficulty,
    required this.scheduledAt,
    required this.duration,
    required this.price,
    required this.gender,
    required this.availableSpots,
    required this.totalSpots,
    required this.instructorName,
    required this.instructorAvatar,
  });

  factory UpcomingClassModel.fromJson(Map<String, dynamic> json) {
    return UpcomingClassModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      difficulty: json['difficulty'] ?? '',
      scheduledAt: DateTime.parse(json['scheduledAt']),
      duration: json['duration'] ?? '',
      price: (json['price'] as num).toDouble(),
      gender: json['gender'] ?? '',
      availableSpots: json['availableSpots'] ?? 0,
      totalSpots: json['totalSpots'] ?? 0,
      instructorName: json['instructorName'] ?? '',
      instructorAvatar: json['instructorAvatar'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'difficulty': difficulty,
      'scheduledAt': scheduledAt.toIso8601String(),
      'duration': duration,
      'price': price,
      'gender': gender,
      'availableSpots': availableSpots,
      'totalSpots': totalSpots,
      'instructorName': instructorName,
      'instructorAvatar': instructorAvatar,
    };
  }
}
