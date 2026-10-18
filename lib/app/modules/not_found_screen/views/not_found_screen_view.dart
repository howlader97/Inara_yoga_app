import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/app_colors.dart';
import '../../../data/app_text_styles.dart';
import '../../../data/image_path.dart';
import '../../../utils/app_size.dart';
import '../../../widgets/custom_elevated_button.dart';
import '../../../widgets/header_text.dart';
import '../controllers/not_found_screen_controller.dart';

class NotFoundScreenView extends GetView<NotFoundScreenController> {
  const NotFoundScreenView({super.key});
  @override
  Widget build(BuildContext context) {
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
                ImagePath.notFoundIllustration,
                height: 250.h,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 40.h),
              Obx(() => HeaderText(text: controller.title.value)),
              SizedBox(height: 16.h),
              Obx(
                () => Text(
                  controller.message.value,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.regular(
                    16,
                    color: AppColors.bodyTextColor.withValues(alpha: 0.7),
                  ),
                ),
              ),
              const Spacer(),
              CustomElevetedButton(
                buttonText: 'Back to Home',
                onTap: () => Get.back(),
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}
