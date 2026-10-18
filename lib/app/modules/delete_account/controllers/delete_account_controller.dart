import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../services/api/api_services.dart';
import '../../../../services/storage_services/get_storage_services.dart';
import '../../../data/app_api_end_point.dart';
import '../../../routes/app_pages.dart';

class DeleteAccountController extends GetxController {
  late TextEditingController passwordController;
  final isPasswordVisible = false.obs;
  final isLoading = false.obs;

  @override
  void onClose() {
    passwordController.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    passwordController = TextEditingController();
    super.onInit();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> deleteAccount() async {
    final password = passwordController.text.trim();
    if (password.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your password',
        snackPosition: SnackPosition.bottom,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    final response = await ApiServices.instance.apiDeleteServices(
      url: AppApiEndPoint.instance.userDelete,
      body: {'password': password},
    );
    isLoading.value = false;

    if (response != null) {
      Get.snackbar(
        'Account Deleted',
        'Your account has been deleted permanently.',
        snackPosition: SnackPosition.bottom,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      await GetStorageServices.instance.logout();
      Get.offAllNamed(Routes.logIn);
    }
  }
}
