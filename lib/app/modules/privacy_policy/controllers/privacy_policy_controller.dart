import 'package:flutter/material.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/app_log.dart';
import '../../../../models/privacy_policy_model.dart';
import '../../../../repository/privacy_policy_repository.dart';
import 'package:get/get.dart';

class PrivacyPolicyController extends GetxController {
  final RxBool isLoading = false.obs;
  final Rxn<PrivacyPolicy> privacyPolicy = Rxn<PrivacyPolicy>();

  final PrivacyPolicyRepository _privacyPolicyRepository =
      PrivacyPolicyRepository.instance;

  void onAppInitialize() {
    try {
      isLoading.value = true;
      fetchPrivacyPolicy();
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAndToNamed(Routes.errorScreen);
      });
    }
  }

  Future<void> fetchPrivacyPolicy() async {
    try {
      isLoading.value = true;

      privacyPolicy.value = null;

      privacyPolicy.value = await _privacyPolicyRepository.getPrivacyPolicy();
    } catch (e) {
      errorLog("fetchPrivacyPolicy", e);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    onAppInitialize();
  }
}
