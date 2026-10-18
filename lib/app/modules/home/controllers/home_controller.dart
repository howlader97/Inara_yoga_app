import 'package:flutter/material.dart';
import '../../../data/app_api_end_point.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/app_log.dart';
import '../../../../models/class_data.dart';
import '../../../../repository/home_repository.dart';
import '../../../../repository/booking_repository.dart';
import '../../../../services/api/api_services.dart';
import '../../../../services/storage_services/get_storage_services.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final HomeRepository _homeRepository = HomeRepository.instance;
  final RxInt selectedDateIndex = (DateTime.now().day - 1).obs;
  final RxBool isMembershipPaid = true.obs;
  final RxInt sessionsLeft = 5.obs;
  final AppApiEndPoint api = AppApiEndPoint.instance;
  final GetStorageServices storageServices = GetStorageServices.instance;
  final ApiServices apiServices = ApiServices.instance;
  RxList<ClassModel> allClasses = <ClassModel>[].obs;
  RxList<String> allInstructor = <String>[].obs;
  RxList<String> allClassName = <String>[].obs;
  final RxBool isLoading = false.obs;
  RxInt currentPage = 1.obs;
  RxInt lastPage = 1.obs;
  RxBool isLoadingMore = false.obs;
  final ScrollController scrollController = ScrollController();
  final ScrollController classScrollController = ScrollController();
  RxString currentDate = ''.obs;

  final RxSet<String> bookedClassIds = <String>{}.obs;
  final RxSet<String> bookedCourseIds = <String>{}.obs;

  Future<void> fetchBookedItems() async {
    try {
      final response = await BookingRepository.instance.getUpcomingBookings(
        page: 1,
        pageSize: 100,
      );
      if (response != null) {
        final classes = response.items
            .where((e) => e.classId != null)
            .map((e) => e.classId!)
            .toSet();
        final courses = response.items
            .where((e) => e.courseId != null)
            .map((e) => e.courseId!)
            .toSet();
        bookedClassIds.assignAll(classes);
        bookedCourseIds.assignAll(courses);
      }
    } catch (e) {
      errorLog('fetchBookedItems error', e);
    }
  }

  Future<void> fetchClasses(
    String date, {
    bool isLoadMore = false,
    String? difficulty,
    String? gender,
    String? instructor,
    String? className,
  }) async {
    try {
      if (isLoadMore) {
        isLoadingMore.value = true;
      } else {
        isLoading.value = true;
        currentPage.value = 1;
        allClasses.clear();
      }
      currentDate.value = date;

      // Fetch booked items in parallel to update UI status
      fetchBookedItems();

      final response = await _homeRepository.fetchClasses(
        date: date,
        page: currentPage.value,
        difficulty: difficulty ?? '',
        gender: gender ?? '',
        instructor: instructor ?? '',
        className: className ?? '',
      );

      if (response != null) {
        if (isLoadMore) {
          allClasses.addAll(response.classes);
        } else {
          allClasses.assignAll(response.classes);
        }
        lastPage.value = response.totalPages;
      }
    } catch (e) {
      errorLog("fetchClasses", e);
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  Future<void> loadMoreClasses() async {
    if (isLoadingMore.value || currentPage.value >= lastPage.value) return;

    currentPage.value++;
    final selected = DateTime(
      currentYear,
      currentMonth.value.month,
      selectedDateIndex.value + 1,
    );
    final formattedDate =
        '${selected.month.toString().padLeft(2, '0')}-${selected.day.toString().padLeft(2, '0')}-${selected.year}';
    currentDate.value = formattedDate;
    await fetchClasses(formattedDate, isLoadMore: true);
  }

  final Rx<DateTime> currentMonth = DateTime(
    DateTime.now().year,
    DateTime.now().month,
  ).obs;

  final List<String> monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  String get currentMonthName => monthNames[currentMonth.value.month - 1];
  int get currentYear => currentMonth.value.year;

  // String get selectedDateString {
  //   if (dates.isEmpty || selectedDateIndex.value >= dates.length) return '';

  //   final now = DateTime.now();
  //   final today = DateTime(now.year, now.month, now.day);
  //   final selected = DateTime(
  //     currentYear,
  //     currentMonth.value.month,
  //     selectedDateIndex.value + 1,
  //   );

  //   final shortDay = dates[selectedDateIndex.value]['day'];

  //   if (selected.year == today.year &&
  //       selected.month == today.month &&
  //       selected.day == today.day) {
  //     return 'Today, ${today.day} ${currentMonthName.substring(0, 3)} $currentYear';
  //   }

  //   final tomorrow = today.add(const Duration(days: 1));
  //   if (selected.year == tomorrow.year &&
  //       selected.month == tomorrow.month &&
  //       selected.day == tomorrow.day) {
  //     return 'Tomorrow, ${tomorrow.day} ${currentMonthName.substring(0, 3)} $currentYear';
  //   }

  //   final yesterday = today.subtract(const Duration(days: 1));
  //   if (selected.year == yesterday.year &&
  //       selected.month == yesterday.month &&
  //       selected.day == yesterday.day) {
  //     return 'Yesterday, ${yesterday.day} ${currentMonthName.substring(0, 3)} $currentYear';
  //   }

  //   final fullDay = _getFullDayName(shortDay ?? '');
  //   final date = dates[selectedDateIndex.value]['date'];
  //   final yearSuffix = currentYear.toString().substring(2);
  //   return '$fullDay $date ${currentMonthName.substring(0, 3)} $yearSuffix';
  // }

  String get selectedDateLabel {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selected = DateTime(
      currentYear,
      currentMonth.value.month,
      selectedDateIndex.value + 1,
    );

    // Check for Today
    if (selected.year == today.year &&
        selected.month == today.month &&
        selected.day == today.day) {
      return 'Today';
    }

    // Check for Tomorrow
    final tomorrow = today.add(const Duration(days: 1));
    if (selected.year == tomorrow.year &&
        selected.month == tomorrow.month &&
        selected.day == tomorrow.day) {
      return 'Tomorrow';
    }

    // Check for Yesterday
    final yesterday = today.subtract(const Duration(days: 1));
    if (selected.year == yesterday.year &&
        selected.month == yesterday.month &&
        selected.day == yesterday.day) {
      return 'Yesterday';
    }

    // Check if it's a Future date (after tomorrow)
    if (selected.isAfter(tomorrow)) {
      return 'Upcoming';
    }

    // Check if it's a Past date (before yesterday)
    if (selected.isBefore(yesterday)) {
      return 'Previous';
    }

    // Fallback (should never reach here)
    return '';
  }

  String get todayButtonText {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (dates.isEmpty || selectedDateIndex.value >= dates.length) {
      return 'Today';
    }

    final selected = DateTime(
      currentYear,
      currentMonth.value.month,
      selectedDateIndex.value + 1,
    );

    if (selected.isAtSameMomentAs(today)) return 'Today';

    final tomorrow = today.add(const Duration(days: 1));
    if (selected.isAtSameMomentAs(tomorrow)) return 'Tomorrow';

    final yesterday = today.subtract(const Duration(days: 1));
    if (selected.isAtSameMomentAs(yesterday)) return 'Yesterday';

    return 'Today';
  }

  // String _getFullDayName(String shortName) {
  //   switch (shortName) {
  //     case 'Mon':
  //       return 'Monday';
  //     case 'Tue':
  //       return 'Tuesday';
  //     case 'Wed':
  //       return 'Wednesday';
  //     case 'Thu':
  //       return 'Thursday';
  //     case 'Fri':
  //       return 'Friday';
  //     case 'Sat':
  //       return 'Saturday';
  //     case 'Sun':
  //       return 'Sunday';
  //     default:
  //       return shortName;
  //   }
  // }

  final dates = <Map<String, String>>[].obs;
  String get _todayFormattedDate {
    final now = DateTime.now();
    final month = now.month.toString().padLeft(2, '0');
    final day = now.day.toString().padLeft(2, '0');
    final year = now.year.toString();
    return '$month-$day-$year';
  }

  void onAppInitialized() {
    try {
      fetchClasses(_todayFormattedDate);
      _initializeToToday();
      classScrollController.addListener(() {
        if (classScrollController.position.pixels >=
            classScrollController.position.maxScrollExtent - 200) {
          loadMoreClasses();
        }
      });
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAndToNamed(Routes.errorScreen);
      });
    }
  }

  void onAppClose() {
    try {
      scrollController.dispose();
      classScrollController.dispose();
    } catch (e) {
      errorLog("onAppClose", e);
    }
  }

  @override
  void onInit() {
    super.onInit();
    onAppInitialized();
  }

  @override
  void onClose() {
    onAppClose();
    super.onClose();
  }

  void _initializeToToday() {
    final now = DateTime.now();
    currentMonth.value = DateTime(now.year, now.month);
    generateDates();
    selectedDateIndex.value = now.day - 1;
  }

  @override
  void onReady() {
    super.onReady();
    refreshToToday();
  }

  void refreshToToday() {
    _initializeToToday();
    scrollToSelectedDate();
  }

  void scrollToSelectedDate() {
    if (selectedDateIndex.value != -1) {
      // Use addPostFrameCallback to ensure the scroll happens after the frame is rendered
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _executeScroll();
      });
    }
  }

  void _executeScroll() {
    if (scrollController.hasClients) {
      double screenWidth = Get.width;
      double itemWidth = 80.0 * (screenWidth / 390.0);
      double offset = selectedDateIndex.value * itemWidth;
      double targetOffset = offset - (screenWidth / 2) + (itemWidth / 2);

      if (targetOffset < 0) targetOffset = 0;
      if (targetOffset > scrollController.position.maxScrollExtent) {
        targetOffset = scrollController.position.maxScrollExtent;
      }

      scrollController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void generateDates() {
    int year = currentMonth.value.year;
    int month = currentMonth.value.month;

    int daysInMonth = DateTime(year, month + 1, 0).day;

    final List<String> weekDays = [
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun',
    ];

    final List<Map<String, String>> newDates = [];
    for (int i = 1; i <= daysInMonth; i++) {
      DateTime date = DateTime(year, month, i);
      String dayName = weekDays[date.weekday - 1];

      newDates.add({'day': dayName, 'date': i.toString()});
    }
    dates.assignAll(newDates);
  }

  void nextMonth() {
    int nextMonth = currentMonth.value.month + 1;
    int year = currentMonth.value.year;
    if (nextMonth > 12) {
      nextMonth = 1;
      year++;
    }
    currentMonth.value = DateTime(year, nextMonth);
    generateDates();
  }

  void previousMonth() {
    int prevMonth = currentMonth.value.month - 1;
    int year = currentMonth.value.year;
    if (prevMonth < 1) {
      prevMonth = 12;
      year--;
    }
    currentMonth.value = DateTime(year, prevMonth);
    generateDates();
  }

  void setSelectedDate(int index) {
    selectedDateIndex.value = index;
    final selected = DateTime(
      currentYear,
      currentMonth.value.month,
      selectedDateIndex.value + 1,
    );
    final formatedDate =
        '${selected.month.toString().padLeft(2, '0')}-${selected.day.toString().padLeft(2, '0')}-${selected.year}';
    currentDate.value = formatedDate;
    fetchClasses(formatedDate);
    scrollToSelectedDate();
  }

  void resetToToday() {
    _initializeToToday();
    scrollToSelectedDate();
  }

  void handleTodayButtonClick() {
    resetToToday();
    final selected = DateTime(
      currentYear,
      currentMonth.value.month,
      selectedDateIndex.value + 1,
    );
    final formatedDate =
        '${selected.month.toString().padLeft(2, '0')}-${selected.day.toString().padLeft(2, '0')}-${selected.year}';
    currentDate.value = formatedDate;
    fetchClasses(formatedDate);
  }
}
