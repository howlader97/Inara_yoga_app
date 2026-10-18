import 'package:get/get.dart';
import '../controllers/notifications_controller.dart';

class NotificationsBinding extends BindingsInterface {
  @override
  void dependencies() {
    Get.lazyPut<NotificationsController>(
      () => NotificationsController(),
      fenix: true,
    );
  }
}
