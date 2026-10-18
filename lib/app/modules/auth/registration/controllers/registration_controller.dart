import 'package:flutter/material.dart';
import '../../../../routes/app_pages.dart';
import '../../../../utils/app_log.dart';
import '../../../../../repository/auth_repository.dart';
import 'package:get/get.dart';

class RegistrationController extends GetxController {
  AuthRepository authRepository = AuthRepository.instance;
  late GlobalKey<FormState> formKey;
  late TextEditingController fullNameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  late FocusNode focusNode;

  final selectedGender = 'Male'.obs;
  RxBool isPasswordVisible = false.obs;
  RxBool isConfirmPasswordVisible = false.obs;
  RxBool isTermsAccepted = false.obs;
  RxBool isLoading = false.obs;

  void togglePasswordVisibility() =>
      isPasswordVisible.value = !isPasswordVisible.value;
  void toggleConfirmPasswordVisibility() =>
      isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;

  void setGender(String? value) {
    if (value != null) {
      selectedGender.value = value;
    }
  }

  Future<void> signUp() async {
    try {
      if (!formKey.currentState!.validate()) {
        return;
      }
      isLoading.value = true;
      var response = await authRepository.signUp(
        name: fullNameController.text.trim(),
        email: emailController.text.trim().toLowerCase(),
        phoneNumber: phoneController.text.trim(),
        gender: selectedGender.value,
        password: passwordController.text.trim(),
      );
      if (response) {
        Get.toNamed(
          Routes.recoveryOtp,
          arguments: {
            'isSignUp': true,
            "email": emailController.text.trim().toLowerCase(),
          },
        );
      }
    } catch (e) {
      errorLog("signUp", e);
    } finally {
      isLoading.value = false;
    }
  }

  void onAppInitial() {
    try {
      formKey = .new();
      fullNameController = .new();
      phoneController = .new();
      emailController = .new();
      passwordController = .new();
      confirmPasswordController = .new();
      focusNode = .new();
    } catch (e) {
      errorLog("onAppInitial", e);
    }
  }

  void onAppClose() {
    try {
      fullNameController.dispose();
      phoneController.dispose();
      emailController.dispose();
      passwordController.dispose();
      confirmPasswordController.dispose();
      focusNode.dispose();
    } catch (e) {
      errorLog("onAppInitial", e);
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
