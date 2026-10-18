import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../routes/app_pages.dart';
import '../../../../utils/app_log.dart';
import '../../../../widgets/snack_bar/app_snack_bar.dart';
import '../../../../../repository/auth_repository.dart';
import 'package:get/get.dart';

class RecoveryOtpController extends GetxController {
  final AuthRepository _authRepository = AuthRepository.instance;
  final RxInt seconds = 90.obs;
  Timer? _timer;
  late TextEditingController otpController;
  late GlobalKey<FormState> formKey;
  RxString email = "".obs;
  RxBool isSignUP = true.obs;
  RxBool isLoading = false.obs;

  Future<void> verifyOtp(GlobalKey<FormState> formKey) async {
    try {
      if (!formKey.currentState!.validate()) return;
      isLoading.value = true;
      var response = await _authRepository.authOtpVerify(
        email: email.value,
        otp: otpController.text.trim(),
      );
      if (response) {
        if (isSignUP.value) {
          AppSnackBar.success(
            "Successfully created account, login with your credential",
          );
          Get.offAllNamed(Routes.logIn);
        } else {
          Get.offAndToNamed(Routes.createNewPassword, arguments: email.value);
        }
      }
    } catch (e) {
      errorLog("verifyOtp", e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendOtp() async {
    try {
      if (seconds.value > 0) return;
      startTimer();
      await _authRepository.authResendOTP(email: email.value);
    } catch (e) {
      errorLog("resendOtp", e);
    }
  }

  void startTimer() {
    try {
      _timer?.cancel();
      seconds.value = 90;
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (seconds.value > 0) {
          seconds.value--;
        } else {
          _timer?.cancel();
        }
      });
    } catch (e) {
      errorLog("startTimer", e);
    }
  }

  String get timerText {
    try {
      // Calculate the remaining minutes
      int minutes = (seconds % 3600) ~/ 60;

      // Calculate the remaining seconds
      num secs = seconds % 60;

      // Format minutes, and seconds to be 2 digits
      String formattedMinutes = minutes.toString().padLeft(2, '0');
      String formattedSeconds = secs.toString().padLeft(2, '0');

      return "$formattedMinutes:$formattedSeconds";
    } catch (e) {
      errorLog("formatSecondFunction", e);
      return "00:00";
    }
  }

  void onAppInitial() {
    try {
      otpController = .new();
      formKey = .new();
      startTimer();
      var arg = Get.arguments;
      appLog(arg);
      if (arg is Map) {
        email.value = "${arg["email"] ?? ""}";
        isSignUP.value = arg["isSignUp"] is bool ? arg["isSignUp"] : true;
        appLog(arg["isSignUp"]);
      } else {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          Get.offAndToNamed(Routes.notFoundScreen);
        });
      }
    } catch (e) {
      errorLog("onAppInitial", e);
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        Get.offAndToNamed(Routes.notFoundScreen);
      });
    }
  }

  void onAppClose() {
    try {
      _timer?.cancel();
      otpController.dispose();
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
