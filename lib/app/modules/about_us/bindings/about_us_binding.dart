import 'package:get/get.dart';

import '../controllers/about_us_controller.dart';

class AboutUsBinding extends BindingsInterface {
  @override
  void dependencies() {
    Get.lazyPut<AboutUsController>(() => AboutUsController());
  }
}
