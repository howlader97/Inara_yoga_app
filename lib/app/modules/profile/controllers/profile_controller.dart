import 'package:flutter/material.dart';
import '../../auth/splash_screen/controllers/splash_screen_controller.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/app_log.dart';
import '../../../../services/storage_services/get_storage_services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../repository/notification_repository.dart';
import '../../../widgets/snack_bar/app_snack_bar.dart';

class ProfileController extends GetxController {
  GetStorageServices storageServices = GetStorageServices.instance;
  final appNotifications = true.obs;
  final whatsappNotifications = true.obs;
  final userData = appGlobalUserData;

  final userName = "".obs;
  final userEmail = "".obs;
  final membershipType = "".obs;
  final profileImage = "".obs;

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    var status = await Permission.camera.status;
    if (status.isDenied) {
      status = await Permission.camera.request();
    }

    if (status.isPermanentlyDenied) {
      AppSnackBar.error(
        "Camera access is required to take a profile picture. Please enable it in settings.",
        action: SnackBarAction(
          label: 'Settings',
          textColor: Colors.blue,
          onPressed: () => openAppSettings(),
        ),
      );
      return;
    }

    if (status.isGranted) {
      try {
        final XFile? image = await _picker.pickImage(
          source: ImageSource.camera,
        );
        if (image != null) {
          profileImage.value = image.path;
        }
      } catch (e) {
        AppSnackBar.error("Failed to capture image: $e");
      }
    } else {
      AppSnackBar.error("Camera permission is required.");
    }
  }

  @override
  void onInit() {
    super.onInit();
    appNotifications.value =
        storageServices.box.read('app_notifications_enabled') ?? true;
    whatsappNotifications.value =
        storageServices.box.read('whatsapp_notifications_enabled') ?? true;
  }

  Future<void> toggleAppNotifications(bool value) async {
    final originalValue = appNotifications.value;
    appNotifications.value = value;

    final message = await NotificationRepository.instance
        .updateAppNotificationSetting(value);
    if (message != null) {
      await storageServices.box.write('app_notifications_enabled', value);
      await storageServices.box.save();
      AppSnackBar.success(message);
    } else {
      appNotifications.value = originalValue;
    }
  }

  Future<void> toggleWhatsappNotifications(bool value) async {
    final originalValue = whatsappNotifications.value;
    whatsappNotifications.value = value;

    final message = await NotificationRepository.instance
        .updateWhatsappNotificationSetting(value);
    if (message != null) {
      await storageServices.box.write('whatsapp_notifications_enabled', value);
      await storageServices.box.save();
      AppSnackBar.success(message);
    } else {
      whatsappNotifications.value = originalValue;
    }
  }

  Future<void> logout() async {
    try {
      Get.closeAllDialogs();
      Get.offAllNamed(Routes.logIn);
      await storageServices.logout();
    } catch (e) {
      errorLog("logout", e);
    }
  }
}
