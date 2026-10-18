import '../../store/controllers/store_controller.dart';
import 'package:get/get.dart';
import '../controllers/checkout_controller.dart';

class CheckoutBinding extends BindingsInterface {
  @override
  void dependencies() {
    Get.lazyPut<CheckoutController>(() => CheckoutController());
    Get.lazyPut<StoreController>(() => StoreController());
  }
}
