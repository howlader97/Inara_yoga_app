import 'package:get/get.dart';

import '../controllers/splash_screen_controller.dart';

class SplashScreenBinding extends BindingsInterface {
  @override
  void dependencies() {
    Get.put<SplashScreenController>(SplashScreenController());
  }
}
