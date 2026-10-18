import 'package:get/get.dart';

import '../controllers/memberships_controller.dart';

class MembershipsBinding extends BindingsInterface {
  @override
  void dependencies() {
    Get.lazyPut<MembershipsController>(() => MembershipsController());
  }
}
