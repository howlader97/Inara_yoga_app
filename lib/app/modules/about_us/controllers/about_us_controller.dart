import 'package:flutter/cupertino.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/app_log.dart';
import '../../../../models/about_us_model.dart';
import '../../../../repository/about_us_repository.dart';
import 'package:get/get.dart';

class AboutUsController extends GetxController {
  final RxBool isLoading = false.obs;

  Rxn<AboutModel> aboutUs = Rxn<AboutModel>();

  final AboutUsRepository _aboutUsRepository = AboutUsRepository.instance;

  Future<void> getAboutUs() async {
    try {
      isLoading.value = true;
      aboutUs.value = null;

      aboutUs.value = await _aboutUsRepository.getAboutUs();
    } catch (e) {
      errorLog('About Us', e);
    } finally {
      isLoading.value = false;
    }
  }

  void onInitialize() {
    try {
      getAboutUs();
    } catch (e) {
      errorLog('About Us', e);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAndToNamed(Routes.errorScreen);
      });
    }
  }

  @override
  void onInit() {
    onInitialize();
    super.onInit();
  }
}
