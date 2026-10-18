import 'package:get/get.dart';

import '../controllers/recovery_otp_controller.dart';

class RecoveryOtpBinding extends BindingsInterface {
  @override
  void dependencies() {
    Get.lazyPut<RecoveryOtpController>(() => RecoveryOtpController());
  }
}
