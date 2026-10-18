import 'package:get/get.dart';
import '../controllers/filter_controller.dart';

class FilterBinding extends BindingsInterface {
  @override
  void dependencies() {
    Get.lazyPut<FilterController>(() => FilterController(), fenix: true);
  }
}
