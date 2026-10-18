import 'package:get/get.dart';
import '../controllers/store_controller.dart';

class StoreBinding extends BindingsInterface {
  @override
  void dependencies() {
    Get.lazyPut<StoreController>(() => StoreController());
  }
}
