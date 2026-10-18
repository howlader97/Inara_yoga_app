import 'package:get/get.dart';
import '../controllers/my_bookings_controller.dart';

class MyBookingsBinding extends BindingsInterface {
  @override
  void dependencies() {
    Get.lazyPut<MyBookingsController>(() => MyBookingsController());
  }
}
