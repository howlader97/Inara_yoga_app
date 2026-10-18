import 'package:get/get.dart';
import '../controllers/class_details_controller.dart';

class ClassDetailsBinding extends BindingsInterface {
  @override
  void dependencies() {
    Get.lazyPut<ClassDetailsController>(() => ClassDetailsController());
  }
}
