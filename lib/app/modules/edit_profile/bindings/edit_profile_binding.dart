import 'package:get/get.dart';

import '../controllers/edit_profile_controller.dart';

class EditProfileBinding extends BindingsInterface {
  @override
  void dependencies() {
    Get.lazyPut<EditProfileController>(() => EditProfileController());
  }
}
