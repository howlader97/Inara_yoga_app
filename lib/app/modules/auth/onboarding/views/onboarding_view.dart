import 'package:flutter/material.dart';
import '../widgets/background_image.dart';
import '../../../../utils/app_size.dart';
import '../../../../widgets/custom_elevated_button.dart';
import '../../../../widgets/header_text.dart';
import 'package:get/get.dart';

import '../../../../data/app_colors.dart';
import '../../../../routes/app_pages.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Background Image
            BackgroundImage(),

            //Bottom Info
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                children: [
                  //Header Text
                  HeaderText(text: 'Join Us'),
                  SizedBox(height: 30.h),

                  // Sign In Button
                  CustomElevetedButton(
                    buttonText: 'Sign In',
                    onTap: () {
                      Get.toNamed(Routes.logIn);
                    },
                  ),
                  SizedBox(height: 15.h),

                  // Create Account Button
                  CustomElevetedButton(
                    buttonText: 'Create Account',
                    backgroundColor: AppColors.buttonSecondaryColor,
                    buttonTextColor: AppColors.headlineColor,
                    onTap: () {
                      Get.toNamed(Routes.registration);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
