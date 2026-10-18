import 'package:get/get.dart';

import '../controllers/registration_controller.dart';

class RegistrationBinding extends BindingsInterface {
  @override
  void dependencies() {
    Get.lazyPut<RegistrationController>(() => RegistrationController());
  }
}
