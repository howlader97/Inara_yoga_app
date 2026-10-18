import 'package:flutter/material.dart';
import '../../../../routes/app_pages.dart';
import '../../../../utils/app_log.dart';
import '../../../../widgets/snack_bar/app_snack_bar.dart';
import '../../../../../repository/auth_repository.dart';
import 'package:get/get.dart';

class CreateNewPasswordController extends GetxController {
  final AuthRepository _authRepository = AuthRepository.instance;
  late GlobalKey<FormState> formKey;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  RxString email = "".obs;

  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;
  final isLoading = false.obs;

  void togglePasswordVisibility() =>
      isPasswordVisible.value = !isPasswordVisible.value;
  void toggleConfirmPasswordVisibility() =>
      isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;

  Future<void> checkAndUpdate() async {
    try {
      if (!formKey.currentState!.validate()) return;
      isLoading.value = true;
      var response = await _authRepository.forgotResetPassword(
        email: email.value,
        newPassword: passwordController.text.trim(),
      );
      if (response) {
        Get.offAllNamed(Routes.logIn);
        AppSnackBar.success(
          "Successful password updated. Log in with your credentials",
        );
      }
    } catch (e) {
      errorLog("checkAndUpdate", e);
    } finally {
      isLoading.value = false;
    }
  }

  void onAppInitial() {
    try {
      formKey = .new();
      passwordController = .new();
      confirmPasswordController = .new();
      var arg = Get.arguments;
      if (arg is String) {
        email.value = arg;
      } else {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          Get.offAndToNamed(Routes.notFoundScreen);
        });
      }
    } catch (e) {
      errorLog("onAppInitial", e);
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        Get.offAndToNamed(Routes.errorScreen);
      });
    }
  }

  void onAppClose() {
    try {
      passwordController.dispose();
      confirmPasswordController.dispose();
    } catch (e) {
      errorLog("onAppClose", e);
    }
  }

  @override
  void onInit() {
    onAppInitial();
    super.onInit();
  }

  @override
  void onClose() {
    onAppClose();
    super.onClose();
  }
}
