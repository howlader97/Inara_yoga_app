import 'package:flutter/material.dart';
import '../../auth/splash_screen/controllers/splash_screen_controller.dart';
import '../../../utils/app_log.dart';
import '../../../widgets/snack_bar/app_snack_bar.dart';
import '../../../../repository/edit_profile_repository.dart';
import 'package:get/get.dart';

import 'package:image_picker/image_picker.dart';

class EditProfileController extends GetxController {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController usernameController;
  late TextEditingController phoneController;
  final userData = appGlobalUserData;
  final EditProfileRepository _editProfileRepository =
      EditProfileRepository.instance;

  final profileImage = "".obs;
  final ImagePicker _picker = ImagePicker();
  final isLoading = false.obs;

  Future<void> updateProfile() async {
    try {
      isLoading.value = true;
      Map<String, dynamic> data = {};
      if (nameController.text.isNotEmpty) {
        data['name'] = nameController.text.trim();
      }
      if (phoneController.text.isNotEmpty) {
        data['phone'] = phoneController.text.trim();
      }

      final updatedUser = await _editProfileRepository.updateProfile(
        body: data,
        profileImage: profileImage.value,
      );

      if (updatedUser.id.isNotEmpty) {
        appGlobalUserData.value = updatedUser;
        Get.back();
        AppSnackBar.success("Profile updated successfully");
      }
    } catch (e) {
      errorLog("updateProfile", e);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    onAppInit();
  }

  void onAppInit() {
    try {
      final user = userData.value;
      nameController = TextEditingController(text: user?.name);
      emailController = TextEditingController(text: user?.email);
      usernameController = TextEditingController(
        text: "",
      ); // Initialize empty or from user if available
      phoneController = TextEditingController(text: user?.phone);
    } catch (e) {
      errorLog("onAppInit", e);
    }
  }

  Future<void> pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      profileImage.value = image.path;
    }
  }

  @override
  void onClose() {
    onAppClose();
    super.onClose();
  }

  void onAppClose() {
    try {
      nameController.dispose();
      emailController.dispose();
      usernameController.dispose();
      phoneController.dispose();
    } catch (e) {
      errorLog("onAppClose", e);
    }
  }
}
