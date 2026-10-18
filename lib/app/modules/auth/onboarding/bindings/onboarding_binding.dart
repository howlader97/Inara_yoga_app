import 'package:get/get.dart';

import '../controllers/onboarding_controller.dart';

class OnboardingBinding extends BindingsInterface {
  @override
  void dependencies() {
    Get.lazyPut<OnboardingController>(() => OnboardingController());
  }
}
