import 'package:get/get.dart';
import '../controllers/booking_details_controller.dart';

class BookingDetailsBinding extends BindingsInterface {
  @override
  void dependencies() {
    Get.lazyPut<BookingDetailsController>(() => BookingDetailsController());
  }
}
