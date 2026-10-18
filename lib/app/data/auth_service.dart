import 'package:get/get.dart';

class AuthService extends GetxService {
  final RxBool isLoggedIn = false.obs;

  static AuthService get to => Get.find();

  void login() {
    isLoggedIn.value = true;
  }

  void logout() {
    isLoggedIn.value = false;
  }
}
