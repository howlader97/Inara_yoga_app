import 'package:flutter/material.dart';
import '../widgets/otp_textfield.dart';
import '../../../../utils/app_size.dart';
import '../../../../widgets/auth_option_text.dart';
import '../../../../widgets/header_sub_text.dart';
import '../../../../widgets/header_text.dart';
import 'package:get/get.dart';
import '../../../../data/app_colors.dart';
import '../../../../data/app_text_styles.dart';
import '../controllers/recovery_otp_controller.dart';

class RecoveryOtpView extends GetView<RecoveryOtpController> {
  const RecoveryOtpView({super.key});
  @override
  Widget build(BuildContext context) {
    return GetBuilder<RecoveryOtpController>(
      init: RecoveryOtpController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColors.backgroundColor,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(top: 50.h, left: 24.w, right: 24.w),
              child: Column(
                children: [
                  //Header Section
                  HeaderText(text: 'Verification'),
                  SizedBox(height: 20.h),
                  HeaderSubText(
                    text: 'We sent Verification code to your Email address',
                  ),
                  SizedBox(height: 40.h),

                  // OTP Field
                  OtpTextField(controller: controller),
                  SizedBox(height: 30.h),

                  // Resend Text
                  AuthOptions(
                    titleText: 'Didn\'t receive a code! ',
                    optionText: 'Resend',
                    onTap: () => controller.resendOtp(),
                    seconds: controller.seconds,
                  ),

                  SizedBox(height: 20.h),

                  // Timer
                  Obx(
                    () => Text(
                      controller.timerText,
                      style: AppTextStyles.medium(
                        14,
                        color: AppColors.headlineColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
