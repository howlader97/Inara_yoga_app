import 'package:flutter/material.dart';
import '../../../../data/app_colors.dart';
import '../../../../data/app_text_styles.dart';
import '../controllers/recovery_otp_controller.dart';
import '../../../../utils/app_log.dart';
import '../../../../utils/app_size.dart';
import '../../../../widgets/custom_elevated_button.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpTextField extends StatelessWidget {
  const OtpTextField({super.key, required this.controller});
  final RecoveryOtpController controller;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return Form(
      key: formKey,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: PinCodeTextField(
              appContext: context,
              length: 6,

              keyboardType: TextInputType.number,
              animationType: AnimationType.fade,
              animationDuration: const Duration(milliseconds: 300),

              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(12.r),
                // fieldHeight: 45.h,
                // fieldWidth: 45.w,
                borderWidth: 1.0,
                activeColor: AppColors.borderColor,
                inactiveColor: AppColors.borderColor,
                selectedColor: AppColors.borderColor,
                activeFillColor: Colors.transparent,
                inactiveFillColor: Colors.transparent,
                selectedFillColor: Colors.transparent,
              ),

              enableActiveFill: false,
              backgroundColor: Colors.transparent,

              textStyle: AppTextStyles.medium(
                24,
                color: AppColors.headlineColor,
              ),

              onCompleted: (value) {
                appLog("OTP: $value");
              },
              onChanged: (value) {
                controller.otpController.text = value;
              },
            ),
          ),
          SizedBox(height: 40.h),

          // Buttons
          Obx(
            () => Row(
              children: [
                Expanded(
                  child: CustomElevetedButton(
                    buttonText: 'Back',
                    buttonTextColor: AppColors.headlineColor,
                    backgroundColor: AppColors.buttonSecondaryColor,
                    onTap: () => Get.back(),
                  ),
                ),
                SizedBox(width: 20.w),
                Expanded(
                  child: CustomElevetedButton(
                    buttonText: controller.isLoading.value
                        ? "loading..."
                        : "Confirm",
                    backgroundColor: AppColors.buttonPrimaryColor,
                    buttonTextColor: AppColors.whiteColor,
                    onTap: () {
                      controller.verifyOtp(formKey);
                      // if (isRegistering) {`
                      //   return Get.offAllNamed(Routes.customBottomNav);
                      // } else {
                      //   return Get.toNamed(Routes.createNewPassword);
                      // }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
