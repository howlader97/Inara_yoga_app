import 'package:get/get.dart';

import '../controllers/profile_controller.dart';

class ProfileBinding extends BindingsInterface {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
