import '../app/data/app_api_end_point.dart';
import '../app/utils/app_log.dart';
import '../models/booking_history_model.dart';
import '../models/upcoming_booking_model.dart';
import '../services/api/api_services.dart';

class BookingRepository {
  BookingRepository._privateConstructor();
  static final BookingRepository _instance =
      BookingRepository._privateConstructor();
  static BookingRepository get instance => _instance;

  final ApiServices _apiServices = ApiServices.instance;
  final AppApiEndPoint _apiEndPoint = AppApiEndPoint.instance;

  Future<UpcomingBookingResponse?> getUpcomingBookings({
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await _apiServices.apiGetServices(
        '${_apiEndPoint.upcomingBookings}?page=$page&page_size=$pageSize',
      );
      if (response != null) {
        return UpcomingBookingResponse.fromJson(response);
      }
    } catch (e) {
      errorLog('getUpcomingBookings repo error', e);
    }
    return null;
  }

  Future<Map<String, dynamic>?> cancelBooking({
    required String bookingId,
    String reason = '',
  }) async {
    try {
      final body = {'booking_id': bookingId, 'reason': reason};
      final response = await _apiServices.apiPostServices(
        url: _apiEndPoint.cancelBooking,
        body: body,
      );
      return response;
    } catch (e) {
      errorLog('cancelBooking repo error', e);
    }
    return null;
  }

  Future<BookingHistoryResponse?> getBookingsHistory({
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await _apiServices.apiGetServices(
        '${_apiEndPoint.bookingHistory}?page=$page&page_size=$pageSize',
      );
      if (response != null) {
        return BookingHistoryResponse.fromJson(response);
      }
    } catch (e) {
      errorLog('getBookingsHistory repo error', e);
    }
    return null;
  }

  Future<Map<String, dynamic>?> payBooking({
    required String classId,
    required String paymentMethod,
    String? membershipId,
  }) async {
    try {
      final body = {
        'class_id': classId,
        'payment_method': paymentMethod,
        if (membershipId != null && membershipId.isNotEmpty)
          'membership_id': membershipId,
      };

      final response = await _apiServices.apiPostServices(
        url: _apiEndPoint.bookingPay,
        body: body,
      );

      return response;
    } catch (e) {
      errorLog('payBooking repo error', e);
    }
    return null;
  }

  Future<Map<String, dynamic>?> payCourse({
    required String courseId,
    required String paymentMethod,
  }) async {
    try {
      final body = {'course_id': courseId, 'payment_method': paymentMethod};

      final response = await _apiServices.apiPostServices(
        url: _apiEndPoint.coursePay,
        body: body,
      );

      return response;
    } catch (e) {
      errorLog('payCourse repo error', e);
    }
    return null;
  }

  Future<Map<String, dynamic>?> checkoutOrder({
    required String productId,
    required int quantity,
    required String paymentMethod,
    String notes = 'string',
  }) async {
    try {
      final body = {
        'items': [
          {'product_id': productId, 'quantity': quantity},
        ],
        'payment_method': paymentMethod,
        'notes': notes,
      };

      final response = await _apiServices.apiPostServices(
        url: _apiEndPoint.orderPay,
        body: body,
      );

      return response;
    } catch (e) {
      errorLog('checkoutOrder repo error', e);
    }
    return null;
  }

  Future<Map<String, dynamic>?> buyMembership({
    required String membershipPlanId,
    required String paymentMethod,
    bool autoRenew = false,
  }) async {
    try {
      final body = {
        'membership_plan_id': membershipPlanId,
        'payment_method': paymentMethod,
        'auto_renew': autoRenew,
      };

      final response = await _apiServices.apiPostServices(
        url: _apiEndPoint.membershipPay,
        body: body,
      );

      return response;
    } catch (e) {
      errorLog('buyMembership repo error', e);
    }
    return null;
  }

  Future<Map<String, dynamic>?> buyPackage({
    required String packageId,
    required String paymentMethod,
    bool autoRenew = false,
  }) async {
    try {
      final body = {
        'package_id': packageId,
        'payment_method': paymentMethod,
        'auto_renew': autoRenew,
      };

      final response = await _apiServices.apiPostServices(
        url: _apiEndPoint.packagePay,
        body: body,
      );

      return response;
    } catch (e) {
      errorLog('buyPackage repo error', e);
    }
    return null;
  }
}
