class UpcomingBookingResponse {
  final List<UpcomingBookingItem> items;
  final int total;
  final int page;
  final int pageSize;
  final int totalPages;

  UpcomingBookingResponse({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
    required this.totalPages,
  });

  factory UpcomingBookingResponse.fromJson(Map<String, dynamic> json) {
    return UpcomingBookingResponse(
      items:
          (json['items'] as List<dynamic>?)
              ?.map(
                (e) => UpcomingBookingItem.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      total: json['total'] ?? 0,
      page: json['page'] ?? 1,
      pageSize: json['page_size'] ?? 20,
      totalPages: json['total_pages'] ?? 1,
    );
  }
}

class UpcomingBookingItem {
  final String bookingId;
  final String bookingType;
  final String status;
  final DateTime bookedAt;
  final num amountPaid;
  final String paymentMethod;
  final String? notes;
  final String? classId;
  final String? classTitle;
  final String? classImageUrl;
  final String? courseId;
  final String? courseTitle;
  final String? courseImageUrl;
  final DateTime? scheduledAt;
  final String? duration;
  final String? location;
  final String? difficulty;
  final int? availableSeat;
  final String? instructorName;
  final String? instructorAvatar;
  final String? cancellationRule;

  UpcomingBookingItem({
    required this.bookingId,
    required this.bookingType,
    required this.status,
    required this.bookedAt,
    required this.amountPaid,
    required this.paymentMethod,
    this.notes,
    this.classId,
    this.classTitle,
    this.classImageUrl,
    this.courseId,
    this.courseTitle,
    this.courseImageUrl,
    this.scheduledAt,
    this.duration,
    this.location,
    this.difficulty,
    this.availableSeat,
    this.instructorName,
    this.instructorAvatar,
    this.cancellationRule,
  });

  factory UpcomingBookingItem.fromJson(Map<String, dynamic> json) {
    return UpcomingBookingItem(
      bookingId: json['booking_id'] ?? '',
      bookingType: json['booking_type'] ?? '',
      status: json['status'] ?? '',
      bookedAt: json['booked_at'] != null
          ? DateTime.parse(json['booked_at'])
          : DateTime.now(),
      amountPaid: json['amount_paid'] ?? 0,
      paymentMethod: json['payment_method'] ?? '',
      notes: json['notes'],
      classId: json['class_id'],
      classTitle: json['class_title'],
      classImageUrl: json['class_image_url'],
      courseId: json['course_id'],
      courseTitle: json['course_title'],
      courseImageUrl: json['course_image_url'],
      scheduledAt: json['scheduled_at'] != null
          ? DateTime.tryParse(json['scheduled_at'])
          : null,
      duration: json['duration']?.toString(),
      location: json['location'],
      difficulty: json['difficulty'],
      availableSeat: json['available_seat'],
      instructorName: json['instructor_name'],
      instructorAvatar: json['instructor_avatar'],
      cancellationRule: json['cancellation_rule'],
    );
  }
}
