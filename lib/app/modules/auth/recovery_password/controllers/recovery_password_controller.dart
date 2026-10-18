import 'package:flutter/material.dart';
import '../../../../routes/app_pages.dart';
import '../../../../utils/app_log.dart';
import '../../../../../repository/auth_repository.dart';
import 'package:get/get.dart';

class RecoveryPasswordController extends GetxController {
  final AuthRepository _authRepository = AuthRepository.instance;
  late GlobalKey<FormState> formKey;
  late TextEditingController emailController;
  RxBool isLoading = false.obs;

  Future<void> checkAndSendOtp() async {
    try {
      if (!formKey.currentState!.validate()) {
        return;
      }
      isLoading.value = true;
      var response = await _authRepository.forgotPassword(
        email: emailController.text.trim().toLowerCase(),
      );
      if (response) {
        Get.toNamed(
          Routes.recoveryOtp,
          arguments: {
            'isSignUp': false,
            "email": emailController.text.trim().toLowerCase(),
          },
        );
      }
    } catch (e) {
      errorLog("checkAndSendOtp", e);
    } finally {
      isLoading.value = false;
    }
  }

  void onAppInitial() {
    try {
      formKey = .new();
      emailController = .new();
    } catch (e) {
      errorLog("message", e);
    }
  }

  void onAppClose() {
    try {
      emailController.dispose();
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
