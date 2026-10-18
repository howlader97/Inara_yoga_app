import 'package:flutter/material.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/app_log.dart';
import '../../../../models/terms_and_conditions_model.dart';
import '../../../../repository/terms_and_conditons_repository.dart';
import 'package:get/get.dart';

class TermsConditionsController extends GetxController {
  final RxBool isLoading = false.obs;
  final TermsAndConditonsRepository _termsAndConditonsRepository =
      TermsAndConditonsRepository.instance;

  Rxn<TermsConditions> termsCondition = Rxn<TermsConditions>();

  void onAppInitialize() {
    try {
      isLoading.value = true;
      fetchTermsAndConditions();
    } catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAndToNamed(Routes.errorScreen);
      });
    }
  }

  Future<void> fetchTermsAndConditions() async {
    try {
      isLoading.value = true;

      termsCondition.value = null;

      termsCondition.value = await _termsAndConditonsRepository
          .getTermsAndConditons();
    } catch (e) {
      errorLog("fetchTermsAndConditions", e);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    onAppInitialize();
    super.onInit();
  }
}
