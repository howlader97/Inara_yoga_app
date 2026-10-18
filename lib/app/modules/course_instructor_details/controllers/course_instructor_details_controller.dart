import 'package:flutter/material.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/app_log.dart';
import '../../../../models/instructor_data.dart';
import '../../../../repository/instructor_repository.dart';
import 'package:get/get.dart';

class CourseInstructorDetailsController extends GetxController {
  final InstructorRepository _instructorRepository =
      InstructorRepository.instance;

  final RxBool isLoading = false.obs;
  RxString id = ''.obs;

  final Rxn<InstructorModel> instructorDeatils = Rxn<InstructorModel>();

  void onAppInitiazied() {
    try {
      var arg = Get.arguments;
      if (arg is String) {
        id.value = arg;
        fetchInstructor(id.value);
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.offAndToNamed(Routes.notFoundScreen);
        });
      }
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAndToNamed(Routes.errorScreen);
      });
    }
  }

  @override
  void onInit() {
    onAppInitiazied();
    super.onInit();
  }

  Future<void> fetchInstructor(String id) async {
    try {
      isLoading.value = true;

      final result = await _instructorRepository.fetchInstructorModel(id: id);

      instructorDeatils.value = result;
    } catch (e) {
      errorLog("Fetch Instructor", e);
    } finally {
      isLoading.value = false;
    }
  }
}
