class MembershipResponseModel {
  final List<MembershipModel> memberships;
  final int total;
  final int page;
  final int pageSize;
  final int totalPages;

  MembershipResponseModel({
    required this.memberships,
    required this.total,
    required this.page,
    required this.pageSize,
    required this.totalPages,
  });

  factory MembershipResponseModel.fromJson(Map<String, dynamic> json) {
    return MembershipResponseModel(
      memberships: (json['memberships'] as List)
          .map((e) => MembershipModel.fromJson(e))
          .toList(),
      total: json['total'] ?? 0,
      page: json['page'] ?? 1,
      pageSize: json['pageSize'] ?? 10,
      totalPages: json['totalPages'] ?? 1,
    );
  }
}

class MembershipModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final int durationDays;
  final List<String> allowedClasses;
  final List<String> excludedClasses;
  final String? timeRestriction;
  final bool autoRenew;
  final String status;
  final int totalClasses;
  final List<ClassInfoModel> classDetails;
  final List<ClassInfoModel> excludedClassDetails;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int? numberOfSessions;
  final int? sessionsUsed;
  final int? sessionsRemaining;
  final String? packageId;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? daysRemaining;

  MembershipModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.durationDays,
    required this.allowedClasses,
    required this.excludedClasses,
    required this.timeRestriction,
    required this.autoRenew,
    required this.status,
    required this.totalClasses,
    required this.classDetails,
    required this.excludedClassDetails,
    required this.createdAt,
    required this.updatedAt,
    this.numberOfSessions,
    this.sessionsUsed,
    this.sessionsRemaining,
    this.packageId,
    this.startDate,
    this.endDate,
    this.daysRemaining,
  });

  factory MembershipModel.fromJson(Map<String, dynamic> json) {
    return MembershipModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      durationDays: json['durationDays'] ?? 0,
      allowedClasses: List<String>.from(json['allowedClasses'] ?? []),
      excludedClasses: List<String>.from(json['excludedClasses'] ?? []),
      timeRestriction: json['timeRestriction'],
      autoRenew: json['autoRenew'] ?? false,
      status: json['status'] ?? '',
      totalClasses: json['totalClasses'] ?? 0,
      classDetails: (json['classDetails'] as List? ?? [])
          .map((e) => ClassInfoModel.fromJson(e))
          .toList(),
      excludedClassDetails: (json['excludedClassDetails'] as List? ?? [])
          .map((e) => ClassInfoModel.fromJson(e))
          .toList(),
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
      numberOfSessions: json['numberOfSessions'],
      sessionsUsed: json['sessionsUsed'],
      sessionsRemaining: json['sessionsRemaining'],
      packageId: json['packageId'],
      startDate: json['startDate'] != null
          ? DateTime.tryParse(json['startDate'])
          : null,
      endDate: json['endDate'] != null
          ? DateTime.tryParse(json['endDate'])
          : null,
      daysRemaining: json['daysRemaining'],
    );
  }
}

class ClassInfoModel {
  final String id;
  final String title;
  final DateTime scheduledAt;
  final String duration;
  final String location;

  ClassInfoModel({
    required this.id,
    required this.title,
    required this.scheduledAt,
    required this.duration,
    required this.location,
  });

  factory ClassInfoModel.fromJson(Map<String, dynamic> json) {
    return ClassInfoModel(
      id: json['id'],
      title: json['title'],
      scheduledAt: DateTime.parse(json['scheduledAt']),
      duration: json['duration'],
      location: json['location'],
    );
  }
}
