class AllCoursesModel {
  final List<Course> courses;
  final int total;
  final int page;
  final int pageSize;
  final int totalPages;

  AllCoursesModel({
    required this.courses,
    required this.total,
    required this.page,
    required this.pageSize,
    required this.totalPages,
  });

  factory AllCoursesModel.fromJson(Map<String, dynamic> json) {
    return AllCoursesModel(
      courses: (json['courses'] as List? ?? [])
          .map((e) => Course.fromJson(e))
          .toList(),
      total: json['total'] ?? 0,
      page: json['page'] ?? 1,
      pageSize: json['pageSize'] ?? 10,
      totalPages: json['totalPages'] ?? 1,
    );
  }
}

class Course {
  final String title;
  final String slug;
  final String description;
  final String imageUrl;
  final double price;
  final DateTime? scheduledAt;
  final DateTime? endDate;
  final String duration;
  final String difficulty;
  final String language;
  final String gender;
  final String? location; // ✅ nullable
  final String phone;
  final String locationMapLink;
  final int maxParticipants;
  final int availableSeat;
  final String id;
  final DateTime? publishedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Instructor instructor;
  final double? latitude;
  final double? longitude;

  Course({
    required this.title,
    required this.slug,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.scheduledAt,
    this.endDate,
    required this.duration,
    required this.difficulty,
    required this.language,
    required this.gender,
    required this.location,
    required this.phone,
    required this.locationMapLink,
    required this.maxParticipants,
    required this.availableSeat,
    required this.id,
    required this.publishedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.instructor,
    this.latitude,
    this.longitude,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      title: json['title'] ?? '',
      slug: json['slug'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      scheduledAt: json['scheduledAt'] != null
          ? DateTime.tryParse(json['scheduledAt'])
          : null,
      endDate: json['endDate'] != null
          ? DateTime.tryParse(json['endDate'])
          : null,
      duration: json['duration'] ?? '',
      difficulty: json['difficulty'] ?? '',
      language: json['language'] ?? '',
      gender: json['gender'] ?? '',
      location: json['location'], // ✅ can be null
      phone: json['phone'] ?? '',
      locationMapLink: json['locationMapLink'] ?? '',
      maxParticipants: json['maxParticipants'] ?? 0,
      availableSeat: json['availableSeat'] ?? 0,
      id: json['id'] ?? '',
      publishedAt: json['publishedAt'] != null
          ? DateTime.tryParse(json['publishedAt'])
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
      instructor: json['instructor'] != null
          ? Instructor.fromJson(json['instructor'])
          : Instructor.empty(),
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );
  }
}

class Instructor {
  final String id;
  final String name;
  final String email;
  final String avatar;

  Instructor({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
  });

  factory Instructor.fromJson(Map<String, dynamic> json) {
    return Instructor(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      avatar: json['avatar'] ?? '',
    );
  }

  factory Instructor.empty() {
    return Instructor(id: '', name: '', email: '', avatar: '');
  }
}
