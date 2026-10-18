import 'package:get/get.dart';

import '../controllers/not_found_screen_controller.dart';

class NotFoundScreenBinding extends BindingsInterface {
  @override
  void dependencies() {
    Get.lazyPut<NotFoundScreenController>(() => NotFoundScreenController());
  }
}
