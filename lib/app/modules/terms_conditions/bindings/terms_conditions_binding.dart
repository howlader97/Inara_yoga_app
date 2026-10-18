import 'package:get/get.dart';

import '../controllers/terms_conditions_controller.dart';

class TermsConditionsBinding extends BindingsInterface {
  @override
  void dependencies() {
    Get.lazyPut<TermsConditionsController>(() => TermsConditionsController());
  }
}
