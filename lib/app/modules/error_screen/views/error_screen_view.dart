import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/app_colors.dart';
import '../../../data/app_text_styles.dart';
import '../../../data/image_path.dart';
import '../../../utils/app_size.dart';
import '../../../widgets/custom_elevated_button.dart';
import '../../../widgets/header_text.dart';
import '../controllers/error_screen_controller.dart';

class ErrorScreenView extends StatelessWidget {
  const ErrorScreenView({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<ErrorScreenController>()
        ? Get.find<ErrorScreenController>()
        : Get.put(ErrorScreenController());
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Image.asset(
                ImagePath.errorIllustration,
                height: 250.h,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 40.h),
              Obx(() => HeaderText(text: controller.errorTitle.value)),
              SizedBox(height: 16.h),
              Obx(
                () => Text(
                  controller.errorMessage.value,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.regular(
                    16,
                    color: AppColors.bodyTextColor.withValues(alpha: 0.7),
                  ),
                ),
              ),
              const Spacer(),
              CustomElevetedButton(
                buttonText: 'Try Again',
                onTap: () {
                  if (controller.retryAction != null) {
                    controller.retryAction!();
                  } else {
                    Get.back();
                  }
                },
              ),
              SizedBox(height: 12.h),
              TextButton(
                onPressed: () => Get.back(),
                child: Text(
                  'Go Back',
                  style: AppTextStyles.medium(
                    16,
                    color: AppColors.buttonPrimaryColor,
                  ),
                ),
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}
