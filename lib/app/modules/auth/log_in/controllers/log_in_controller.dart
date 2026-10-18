import 'package:flutter/material.dart';
import '../../splash_screen/controllers/splash_screen_controller.dart';
import '../../../../routes/app_pages.dart';
import '../../../../utils/app_log.dart';
import '../../../../../repository/auth_repository.dart';
import '../../../../../services/storage_services/get_storage_services.dart';
import 'package:get/get.dart';

class LogInController extends GetxController {
  final GetStorageServices _storageServices = GetStorageServices.instance;
  final AuthRepository authRepository = AuthRepository.instance;
  late GlobalKey<FormState> formKey;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late FocusNode focusNode;
  final isPasswordVisible = false.obs;
  final isRememberMe = false.obs;
  RxBool isLoading = false.obs;

  Future<void> login() async {
    try {
      if (!formKey.currentState!.validate()) {
        return;
      }
      isLoading.value = true;
      var response = await authRepository.login(
        email: emailController.text.trim().toLowerCase(),
        password: passwordController.text.trim(),
      );
      if (response) {
        appGlobalUserData.value = await authRepository.getUser();
        if (isRememberMe.value) {
          await _storageServices.setLoginInformation(
            email: emailController.text.trim().toLowerCase(),
            password: passwordController.text.trim(),
          );
        }
        Get.offAllNamed(Routes.customBottomNav);
      }
    } catch (e) {
      errorLog("login", e);
    } finally {
      isLoading.value = false;
    }
    // if (formKey.currentState?.validate() ?? false) {
    //   Get.offAllNamed('/custom-bottom-nav');
    // }
  }

  void togglePasswordVisibility() =>
      isPasswordVisible.value = !isPasswordVisible.value;
  void toggleRememberMe() => isRememberMe.value = !isRememberMe.value;

  void onAppInitial() {
    try {
      emailController = .new();
      passwordController = .new();
      // emailController.text = 'marvin@test.com';
      // passwordController.text = 'User123!';
      formKey = .new();
      focusNode = .new();
      var data = _storageServices.getLoginInformation();
      if (data.isNotEmpty) {
        isRememberMe.value = true;
        if (data["email"] is String) {
          emailController.text = data["email"].toString();
        }
        if (data["password"] is String) {
          passwordController.text = data["password"].toString();
        }
      } else {
        isRememberMe.value = false;
      }
    } catch (e) {
      errorLog("onAppInitial", e);
    }
  }

  void onAppClose() {
    try {
      emailController.dispose();
      passwordController.dispose();
      focusNode.dispose();
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
