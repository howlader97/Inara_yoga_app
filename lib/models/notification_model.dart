class NotificationResponseModel {
  final List<NotificationItemModel> items;
  final int total;
  final int unreadCount;
  final int page;
  final int pageSize;
  final int totalPages;

  NotificationResponseModel({
    required this.items,
    required this.total,
    required this.unreadCount,
    required this.page,
    required this.pageSize,
    required this.totalPages,
  });

  factory NotificationResponseModel.fromJson(Map<String, dynamic> json) {
    return NotificationResponseModel(
      items:
          (json['items'] as List<dynamic>?)
              ?.map(
                (e) =>
                    NotificationItemModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      total: json['total'] as int? ?? 0,
      unreadCount: json['unreadCount'] as int? ?? 0,
      page: json['page'] as int? ?? 1,
      pageSize: json['pageSize'] as int? ?? 20,
      totalPages: json['totalPages'] as int? ?? 1,
    );
  }
}

class NotificationItemModel {
  final String id;
  final String title;
  final String message;
  final String type; // ERROR, INFO, SUCCESS, WARNING, REMINDER
  final String? actionUrl;
  final bool isRead;
  final DateTime? readAt;
  final DateTime createdAt;

  NotificationItemModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    this.actionUrl,
    required this.isRead,
    this.readAt,
    required this.createdAt,
  });

  factory NotificationItemModel.fromJson(Map<String, dynamic> json) {
    return NotificationItemModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      message: json['message'] as String? ?? '',
      type: json['type'] as String? ?? 'INFO',
      actionUrl: json['actionUrl'] as String?,
      isRead: json['isRead'] as bool? ?? false,
      readAt: json['readAt'] != null
          ? DateTime.tryParse(json['readAt'].toString())?.toLocal()
          : null,
      createdAt: json['createdAt'] != null
          ? (DateTime.tryParse(json['createdAt'].toString())?.toLocal() ??
                DateTime.now())
          : DateTime.now(),
    );
  }
}
