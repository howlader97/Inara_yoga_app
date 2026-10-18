import 'package:get/get.dart';

import '../controllers/my_practice_controller.dart';

class MyPracticeBinding extends BindingsInterface {
  @override
  void dependencies() {
    Get.lazyPut<MyPracticeController>(
      () => MyPracticeController(),
    );
  }
}
