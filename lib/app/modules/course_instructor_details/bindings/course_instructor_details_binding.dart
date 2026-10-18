import 'package:get/get.dart';
import '../controllers/course_instructor_details_controller.dart';

class CourseInstructorDetailsBinding extends BindingsInterface {
  @override
  void dependencies() {
    Get.lazyPut<CourseInstructorDetailsController>(
      () => CourseInstructorDetailsController(),
    );
  }
}
