import 'package:get/get.dart';

import '../controllers/log_in_controller.dart';

class LogInBinding extends BindingsInterface {
  @override
  void dependencies() {
    Get.lazyPut<LogInController>(() => LogInController());
  }
}
