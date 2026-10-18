// legal_content_model.dart
class PrivacyPolicy {
  final String id;
  final String type; // e.g., "TERMS_CONDITIONS" or "PRIVACY_POLICY"
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;

  PrivacyPolicy({
    required this.id,
    required this.type,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  // Parse from JSON
  factory PrivacyPolicy.fromJson(Map<String, dynamic> json) {
    return PrivacyPolicy(
      id: json['id'] as String,
      type: json['type'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  // Convert back to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
