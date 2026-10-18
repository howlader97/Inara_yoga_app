class BookingHistoryResponse {
  final List<BookingHistoryItem> items;
  final int total;
  final int page;
  final int pageSize;
  final int totalPages;

  BookingHistoryResponse({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
    required this.totalPages,
  });

  factory BookingHistoryResponse.fromJson(Map<String, dynamic> json) {
    return BookingHistoryResponse(
      items:
          (json['items'] as List<dynamic>?)
              ?.map(
                (e) => BookingHistoryItem.fromJson(e as Map<String, dynamic>),
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

class BookingHistoryItem {
  final String bookingId;
  final String bookingType; // CLASS or COURSE
  final String? classId;
  final String? classTitle;
  final String? classImageUrl;
  final DateTime? classScheduledAt;
  final String? classLocation;
  final String? courseId;
  final String? courseTitle;
  final String? courseImageUrl;
  final DateTime? courseScheduledAt;
  final String? courseLocation;
  final String? instructorName;
  final String status;
  final num amountPaid;
  final String currency;
  final String paymentMethod;
  final String paymentStatus;
  final String referenceId;
  final DateTime bookedAt;
  final DateTime? cancelledAt;
  final String? notes;

  BookingHistoryItem({
    required this.bookingId,
    required this.bookingType,
    this.classId,
    this.classTitle,
    this.classImageUrl,
    this.classScheduledAt,
    this.classLocation,
    this.courseId,
    this.courseTitle,
    this.courseImageUrl,
    this.courseScheduledAt,
    this.courseLocation,
    this.instructorName,
    required this.status,
    required this.amountPaid,
    required this.currency,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.referenceId,
    required this.bookedAt,
    this.cancelledAt,
    this.notes,
  });

  factory BookingHistoryItem.fromJson(Map<String, dynamic> json) {
    return BookingHistoryItem(
      bookingId: json['booking_id'] ?? '',
      bookingType: json['booking_type'] ?? '',
      classId: json['class_id'],
      classTitle: json['class_title'],
      classImageUrl: json['class_image_url'],
      classScheduledAt: json['class_scheduled_at'] != null
          ? DateTime.tryParse(json['class_scheduled_at'])
          : null,
      classLocation: json['class_location'],
      courseId: json['course_id'],
      courseTitle: json['course_title'],
      courseImageUrl: json['course_image_url'],
      courseScheduledAt: json['course_scheduled_at'] != null
          ? DateTime.tryParse(json['course_scheduled_at'])
          : null,
      courseLocation: json['course_location'],
      instructorName: json['instructor_name'],
      status: json['status'] ?? '',
      amountPaid: json['amount_paid'] ?? 0,
      currency: json['currency'] ?? '',
      paymentMethod: json['payment_method'] ?? '',
      paymentStatus: json['payment_status'] ?? '',
      referenceId: json['reference_id'] ?? '',
      bookedAt: json['booked_at'] != null
          ? DateTime.parse(json['booked_at'])
          : DateTime.now(),
      cancelledAt: json['cancelled_at'] != null
          ? DateTime.tryParse(json['cancelled_at'])
          : null,
      notes: json['notes'],
    );
  }
}
