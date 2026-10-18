import 'package:get/get.dart';
import '../../../../models/booking_history_model.dart';
import '../../../../models/upcoming_booking_model.dart';
import '../../../../repository/booking_repository.dart';

class MyBookingsController extends GetxController {
  final RxInt selectedTab = 0.obs; // 0 for Upcoming, 1 for History
  final RxBool isLoadingHistory = false.obs;
  final RxBool isLoadingUpcoming = false.obs;
  final RxList<BookingHistoryItem> historyBookings = <BookingHistoryItem>[].obs;
  final RxList<UpcomingBookingItem> upcomingBookings =
      <UpcomingBookingItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchUpcomingBookings();
    fetchBookingHistory();
  }

  void selectTab(int index) {
    selectedTab.value = index;
    if (index == 0 && upcomingBookings.isEmpty) {
      fetchUpcomingBookings();
    } else if (index == 1 && historyBookings.isEmpty) {
      fetchBookingHistory();
    }
  }

  Future<void> fetchUpcomingBookings() async {
    try {
      isLoadingUpcoming.value = true;
      final response = await BookingRepository.instance.getUpcomingBookings(
        page: 1,
        pageSize: 20,
      );
      if (response != null) {
        upcomingBookings.assignAll(response.items);
      }
    } catch (e) {
      // handled
    } finally {
      isLoadingUpcoming.value = false;
    }
  }

  Future<void> fetchBookingHistory() async {
    try {
      isLoadingHistory.value = true;
      final response = await BookingRepository.instance.getBookingsHistory(
        page: 1,
        pageSize: 20,
      );
      if (response != null) {
        historyBookings.assignAll(response.items);
      }
    } catch (e) {
      // handled
    } finally {
      isLoadingHistory.value = false;
    }
  }

  Future<Map<String, dynamic>?> cancelBooking({
    required String bookingId,
    String reason = '',
  }) async {
    try {
      final response = await BookingRepository.instance.cancelBooking(
        bookingId: bookingId,
        reason: reason,
      );
      if (response != null) {
        fetchUpcomingBookings();
        fetchBookingHistory();
      }
      return response;
    } catch (e) {
      // handled
    }
    return null;
  }
}
