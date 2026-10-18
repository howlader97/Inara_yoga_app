import 'package:flutter/material.dart';
import '../../../../routes/app_pages.dart';
import '../../../../utils/app_log.dart';
import '../../../../../models/app_user_data.dart';
import '../../../../../repository/auth_repository.dart';
import '../../../../../services/storage_services/get_storage_services.dart';
import 'package:get/get.dart';

Rxn<AppUserData> appGlobalUserData = Rxn<AppUserData>();

class SplashScreenController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> scaleAnimation;
  late Animation<double> fadeAnimation;
  final GetStorageServices storageServices = GetStorageServices.instance;
  final AuthRepository authRepository = AuthRepository.instance;

  Future<void> onAppInitial() async {
    try {
      animationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1500),
      );

      scaleAnimation = CurvedAnimation(
        parent: animationController,
        curve: Curves.easeOutBack,
      );

      fadeAnimation = CurvedAnimation(
        parent: animationController,
        curve: Curves.easeIn,
      );

      animationController.forward();

      var token = GetStorageServices.instance.getToken();
      if (token.isEmpty) {
        Future.delayed(const Duration(seconds: 2), () {
          Get.offNamed(Routes.onboarding);
        });
        return;
      }

      appGlobalUserData.value = await authRepository.getUser();
      if (appGlobalUserData.value == null) {
        Get.offNamed(Routes.onboarding);
      } else {
        Get.offNamed(Routes.customBottomNav);
      }
    } catch (e) {
      errorLog("onAppInitial", e);
    }
  }

  void onAppClose() {
    try {
      animationController.dispose();
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
