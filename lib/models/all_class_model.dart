class AllClassModel {
  List<Classes> courses;
  int total;
  int page;
  int pageSize;
  int totalPages;

  AllClassModel({
    required this.courses,
    required this.total,
    required this.page,
    required this.pageSize,
    required this.totalPages,
  });

  factory AllClassModel.fromJson(Map<String, dynamic> json) {
    return AllClassModel(
      courses: (json['courses'] as List? ?? [])
          .map((e) => Classes.fromJson(e))
          .toList(),
      total: json['total'] ?? 0,
      page: json['page'] ?? 1,
      pageSize: json['pageSize'] ?? 10,
      totalPages: json['totalPages'] ?? 1,
    );
  }
}

class Classes {
  String title;
  String slug;
  String description;
  String coverImage;
  double price; // ✅ changed to double
  DateTime? scheduledAt;
  String duration;
  String level;
  String language;
  String gender;
  String location;
  String phone;
  String locationMapLink;
  int totalSeat;
  int availableSeat;
  String id;
  DateTime? publishedAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  Instructor instructor;

  Classes({
    required this.title,
    required this.slug,
    required this.description,
    required this.coverImage,
    required this.price,
    required this.scheduledAt,
    required this.duration,
    required this.level,
    required this.language,
    required this.gender,
    required this.location,
    required this.phone,
    required this.locationMapLink,
    required this.totalSeat,
    required this.availableSeat,
    required this.id,
    required this.publishedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.instructor,
  });

  factory Classes.fromJson(Map<String, dynamic> json) {
    return Classes(
      title: json['title'] ?? '',
      slug: json['slug'] ?? '',
      description: json['description'] ?? '',
      coverImage: json['coverImage'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0, // ✅ fixed
      scheduledAt: json['scheduledAt'] != null
          ? DateTime.tryParse(json['scheduledAt'])
          : null,
      duration: json['duration'] ?? '',
      level: json['level'] ?? '',
      language: json['language'] ?? '',
      gender: json['gender'] ?? '',
      location: json['location'] ?? '',
      phone: json['phone'] ?? '',
      locationMapLink: json['locationMapLink'] ?? '',
      totalSeat: json['TotalSeat'] ?? 0,
      availableSeat: json['AvailableSeat'] ?? 0,
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
          : Instructor(name: '', image: ''),
    );
  }
}

class Instructor {
  final String name;
  final String image;

  Instructor({required this.name, required this.image});

  factory Instructor.fromJson(Map<String, dynamic> json) {
    return Instructor(name: json['name'] ?? '', image: json['avatar'] ?? '');
  }
}
