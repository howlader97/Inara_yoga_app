import 'package:flutter/material.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/app_log.dart';
import '../../../../models/all_courses_model.dart';
import '../../../../repository/course_repository.dart';
import '../../../../repository/booking_repository.dart';
import 'package:get/get.dart';

class CoursesController extends GetxController {
  final CourseRepository _service = CourseRepository.instance;
  late ScrollController scrollController;

  var isLoading = false.obs;
  var coursesList = <Course>[].obs;
  final count = 0.obs;
  void increment() => count.value++;
  int currentPage = 1;
  int totalPages = 1;
  final RxBool isLoadingMore = false.obs;
  bool _isLoadingMoreInternal = false;

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

  Future<void> fetchCourses() async {
    try {
      isLoading(true);

      // Fetch booked items in parallel to update UI status
      fetchBookedItems();

      final result = await _service.getAllCourses(page: 1);

      if (result != null) {
        coursesList.clear(); // Clear existing list on fresh fetch
        coursesList.addAll(result.courses);
        currentPage = result.page;
        totalPages = result.totalPages;
      }
    } catch (e) {
      errorLog("Error: ", e);
    } finally {
      isLoading(false);
    }
  }

  Future<void> loadMoreCourses() async {
    try {
      if (_isLoadingMoreInternal || isLoadingMore.value) return;
      if (currentPage >= totalPages) return;

      _isLoadingMoreInternal = true;
      isLoadingMore.value = true;

      final nextPage = currentPage + 1;
      final result = await _service.getAllCourses(page: nextPage);

      if (result != null) {
        coursesList.addAll(result.courses);
        currentPage = result.page;
        totalPages = result.totalPages;
      }
    } catch (e) {
      errorLog("Pagination error", e);
    } finally {
      isLoadingMore.value = false;
      _isLoadingMoreInternal = false;
    }
  }

  void onInitialize() {
    try {
      fetchCourses();
      scrollController = ScrollController();
      scrollController.addListener(() {
        if (_isLoadingMoreInternal || isLoadingMore.value) return;

        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200) {
          loadMoreCourses();
        }
      });
    } catch (e) {
      errorLog('Course fetch error', e);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAndToNamed(Routes.errorScreen);
      });
    }
  }

  void onAppClose() {
    try {
      scrollController.dispose();
    } catch (e) {
      errorLog("onAppClose", e);
    }
  }

  @override
  void onInit() {
    onInitialize();
    super.onInit();
  }

  @override
  void onClose() {
    onAppClose();
    super.onClose();
  }
}
