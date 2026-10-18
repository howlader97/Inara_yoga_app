// terms_conditions_model.dart
class TermsConditions {
  final String id;
  final String type;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;

  TermsConditions({
    required this.id,
    required this.type,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory constructor to create instance from JSON
  factory TermsConditions.fromJson(Map<String, dynamic> json) {
    return TermsConditions(
      id: json['id'] as String,
      type: json['type'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  // Convert instance back to JSON
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
