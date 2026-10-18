import 'package:flutter/material.dart';
import '../../../utils/app_log.dart';
import '../../../widgets/snack_bar/app_snack_bar.dart';
import '../../../../services/storage_services/get_storage_services.dart';
import 'package:get/get.dart';

import '../../../../repository/change_password_repository.dart';
import '../../../routes/app_pages.dart';

class UpdatePasswordController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool showCurrentPassword = true.obs;
  RxBool showNewPassword = true.obs;
  RxBool showConfirmPassword = true.obs;
  late TextEditingController passwordController;
  late TextEditingController newPasswordController;
  late TextEditingController confirmPasswordController;
  GetStorageServices storageServices = GetStorageServices.instance;

  // Form validation
  final formKey = GlobalKey<FormState>();

  void toggleCurrentPassword() {
    showCurrentPassword.toggle();
  }

  void toggleNewPassword() {
    showNewPassword.toggle();
  }

  void toggleConfirmPassword() {
    showConfirmPassword.toggle();
  }

  Future<void> updatePassword() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;

    try {
      final result = await ChangePasswordRepository.instance.updatePassword(
        currentPass: passwordController.text.trim(),
        newPass: newPasswordController.text.trim(),
        confirmPass: confirmPasswordController.text.trim(),
      );

      if (result != null) {
        AppSnackBar.success(result['message']);
        await storageServices.logout();
        Get.offAllNamed(Routes.logIn);
      }
    } catch (e) {
      errorLog('Error', e);
      AppSnackBar.error(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your current password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    return null;
  }

  String? validateNewPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter new password';
    }
    if (value.length < 8) {
      return 'New password must be at least 8 characters long';
    }

    // Check for at least one uppercase letter
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }

    // Check for at least one number
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }

    // Check for at least one special character
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least one special character';
    }

    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your new password';
    }
    if (value != newPasswordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  void onAppInitialize() {
    try {
      passwordController = TextEditingController();
      newPasswordController = TextEditingController();
      confirmPasswordController = TextEditingController();
    } catch (e) {
      errorLog('controller initialize error', e);
    }
  }

  @override
  void onInit() {
    onAppInitialize();
    super.onInit();
  }

  @override
  void onClose() {
    passwordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
