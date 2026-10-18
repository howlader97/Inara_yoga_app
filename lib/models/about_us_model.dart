// about_model.dart
class AboutModel {
  final int activeMembers;
  final int totalClasses;
  final int totalInstructors;
  final String ourStory;
  final String ourMission;
  final String location;
  final String locationMapLink;
  final double? latitude;
  final double? longitude;
  final String email;
  final String phoneNumber;
  final String instagramAccount;
  final String facebookPage;
  final String websiteUrl;
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;

  AboutModel({
    required this.activeMembers,
    required this.totalClasses,
    required this.totalInstructors,
    required this.ourStory,
    required this.ourMission,
    required this.location,
    required this.locationMapLink,
    this.latitude,
    this.longitude,
    required this.email,
    required this.phoneNumber,
    required this.instagramAccount,
    required this.facebookPage,
    required this.websiteUrl,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AboutModel.fromJson(Map<String, dynamic> json) {
    return AboutModel(
      activeMembers: int.tryParse("${json['activeMembers'] ?? 0}") ?? 0,
      totalClasses: json['totalClasses'] ?? 0,
      totalInstructors: json['totalInstructors'] ?? 0,
      ourStory: json['ourStory'] ?? '',
      ourMission: json['ourMission'] ?? '',
      location: json['location'] ?? '',
      locationMapLink: json['locationMapLink'] ?? '',
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      instagramAccount: json['instagramAccount'] ?? '',
      facebookPage: json['facebookPage'] ?? '',
      websiteUrl: json['websiteUrl'] ?? '',
      id: json['id'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'activeMembers': activeMembers,
      'totalClasses': totalClasses,
      'totalInstructors': totalInstructors,
      'ourStory': ourStory,
      'ourMission': ourMission,
      'location': location,
      'locationMapLink': locationMapLink,
      'latitude': latitude,
      'longitude': longitude,
      'email': email,
      'phoneNumber': phoneNumber,
      'instagramAccount': instagramAccount,
      'facebookPage': facebookPage,
      'websiteUrl': websiteUrl,
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
