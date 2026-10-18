import 'package:get/get.dart';
import '../controllers/courses_controller.dart';

class CoursesBinding extends BindingsInterface {
  @override
  void dependencies() {
    Get.lazyPut<CoursesController>(() => CoursesController());
  }
}
