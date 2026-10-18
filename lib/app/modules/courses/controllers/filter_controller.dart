import 'package:flutter/material.dart';
import '../../home/controllers/home_controller.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/app_log.dart';
import 'package:get/get.dart';

class FilterController extends GetxController {
  // --- Instructor ---
  final RxList<String> instructors = <String>[].obs;
  final RxString instructorSearch = ''.obs;

  // --- Class Name ---
  final RxList<String> classes = <String>[].obs;
  final RxString classSearch = ''.obs;

  // --- Difficulty ---
  final List<String> difficulties = ['Beginner', 'Intermediate', 'Advanced'];
  final RxString selectedDifficulty = ''.obs;

  // --- Gender ---
  final List<String> genders = ['Male', 'Female', 'Both'];
  final RxString selectedGender = ''.obs;

  // Track if filter is applied
  final RxBool isFilterApplied = false.obs;

  final RxString selectedInstructor = ''.obs;
  final RxString selectedClass = ''.obs;

  final HomeController homeController = Get.find<HomeController>();

  void setArgs(Map<String, dynamic>? args) {
    if (args != null) {
      final List<String> instructorsList = args['instructors'] ?? [];
      instructors.value = instructorsList.toSet().toList();
      final List<String> classesList = args['classes'] ?? [];
      classes.value = classesList.toSet().toList();
    }
  }

  void applyFilter() {
    isFilterApplied.value =
        selectedDifficulty.value.isNotEmpty ||
        selectedGender.value.isNotEmpty ||
        selectedInstructor.value.isNotEmpty ||
        selectedClass.value.isNotEmpty;

    appLog('---- FILTER DATA ----');
    appLog('Instructor: ${selectedInstructor.value}');
    appLog('Class: ${selectedClass.value}');
    appLog('Difficulty: ${selectedDifficulty.value}');
    appLog('Gender: ${selectedGender.value}');
    appLog('----------------------');

    homeController.fetchClasses(
      homeController.currentDate.value,
      difficulty: selectedDifficulty.value,
      gender: selectedGender.value,
      instructor: selectedInstructor.value,
      className: selectedClass.value,
    );

    Get.back();
  }

  void onInitialize() {
    try {
      final arg = Get.arguments;
      if (arg != null) {
        final List<String> instructorsList = arg['instructors'] ?? [];
        instructors.value = instructorsList.toSet().toList();
        final List<String> classesList = arg['classes'] ?? [];
        classes.value = classesList.toSet().toList();
      }
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        errorLog('Filter Error', e);
        Get.toNamed(Routes.errorScreen);
      });
    }
  }

  void clearFilter() {
    selectedInstructor.value = '';
    selectedClass.value = '';
    selectedDifficulty.value = '';
    selectedGender.value = '';
    isFilterApplied.value = false;
    homeController.fetchClasses(homeController.currentDate.value);
    Get.back();
  }

  @override
  void onInit() {
    onInitialize();
    super.onInit();
  }
}
