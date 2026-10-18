import 'membership_catalogue_model.dart';

class ActiveMembershipResponseModel {
  final List<ActiveMembershipModel> memberships;
  final int total;
  final int page;
  final int pageSize;
  final int totalPages;

  ActiveMembershipResponseModel({
    required this.memberships,
    required this.total,
    required this.page,
    required this.pageSize,
    required this.totalPages,
  });

  factory ActiveMembershipResponseModel.fromJson(Map<String, dynamic> json) {
    return ActiveMembershipResponseModel(
      memberships: (json['memberships'] as List? ?? [])
          .map((e) => ActiveMembershipModel.fromJson(e))
          .toList(),
      total: json['total'] ?? 0,
      page: json['page'] ?? 1,
      pageSize: json['pageSize'] ?? 10,
      totalPages: json['totalPages'] ?? 1,
    );
  }
}

class ActiveMembershipModel {
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
  final String userId;
  final double progress;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime enrolledAt;
  final DateTime? completedAt;
  final DateTime? cancelledAt;
  final int daysRemaining;
  final bool isExpired;

  ActiveMembershipModel({
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
    required this.userId,
    required this.progress,
    required this.startDate,
    required this.endDate,
    required this.enrolledAt,
    this.completedAt,
    this.cancelledAt,
    required this.daysRemaining,
    required this.isExpired,
  });

  factory ActiveMembershipModel.fromJson(Map<String, dynamic> json) {
    return ActiveMembershipModel(
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
      userId: json['userId'] ?? '',
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
      startDate: DateTime.parse(
        json['startDate'] ?? DateTime.now().toIso8601String(),
      ),
      endDate: DateTime.parse(
        json['endDate'] ?? DateTime.now().toIso8601String(),
      ),
      enrolledAt: DateTime.parse(
        json['enrolledAt'] ?? DateTime.now().toIso8601String(),
      ),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
      cancelledAt: json['cancelledAt'] != null
          ? DateTime.parse(json['cancelledAt'])
          : null,
      daysRemaining: json['daysRemaining'] ?? 0,
      isExpired: json['isExpired'] ?? false,
    );
  }
}
