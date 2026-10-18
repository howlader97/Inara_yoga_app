import 'package:get/get.dart';
import '../../courses/controllers/filter_controller.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends BindingsInterface {
  @override
  void dependencies() {
    Get.put<FilterController>(FilterController());
    Get.lazyPut<HomeController>(() => HomeController());
  }
}
