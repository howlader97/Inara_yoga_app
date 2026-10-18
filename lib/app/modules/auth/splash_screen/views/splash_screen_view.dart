import 'package:flutter/material.dart';
import '../../../../utils/app_size.dart';
import 'package:get/get.dart';
import '../../../../data/app_colors.dart';
import '../../../../data/image_path.dart';
import '../controllers/splash_screen_controller.dart';

class SplashScreenView extends GetView<SplashScreenController> {
  const SplashScreenView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: controller.scaleAnimation,
              child: FadeTransition(
                opacity: controller.fadeAnimation,
                child: Image.asset(
                  ImagePath.splashImage,
                  height: 439.h,
                  width: 361.w,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 150.h,
                      width: 150.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.buttonPrimaryColor,
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        Icons.self_improvement,
                        size: 80.sp,
                        color: AppColors.buttonPrimaryColor,
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }
}
