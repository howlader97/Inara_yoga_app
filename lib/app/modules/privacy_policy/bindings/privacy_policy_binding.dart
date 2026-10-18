import 'package:get/get.dart';

import '../controllers/privacy_policy_controller.dart';

class PrivacyPolicyBinding extends BindingsInterface {
  @override
  void dependencies() {
    Get.lazyPut<PrivacyPolicyController>(() => PrivacyPolicyController());
  }
}
