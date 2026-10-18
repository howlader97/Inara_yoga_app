import 'package:get/get.dart';
import '../controllers/instructor_details_controller.dart';

class InstructorDetailsBinding extends BindingsInterface {
  @override
  void dependencies() {
    Get.lazyPut<InstructorDetailsController>(
      () => InstructorDetailsController(),
    );
  }
}
