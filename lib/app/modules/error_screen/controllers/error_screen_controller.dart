import 'package:get/get.dart';

class ErrorScreenController extends GetxController {
  final errorTitle = 'Oops!'.obs;
  final errorMessage = 'Something went wrong. Please try again later.'.obs;

  void Function()? retryAction;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      if (Get.arguments['title'] != null) {
        errorTitle.value = Get.arguments['title'];
      }
      if (Get.arguments['message'] != null) {
        errorMessage.value = Get.arguments['message'];
      }
      if (Get.arguments['onRetry'] != null) {
        retryAction = Get.arguments['onRetry'];
      }
    }
  }
}
