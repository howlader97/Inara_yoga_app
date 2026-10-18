import 'package:get/get.dart';

import '../controllers/create_new_password_controller.dart';

class CreateNewPasswordBinding extends BindingsInterface {
  @override
  void dependencies() {
    Get.lazyPut<CreateNewPasswordController>(
      () => CreateNewPasswordController(),
    );
  }
}
