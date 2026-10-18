import 'package:flutter/material.dart';
import '../../../data/app_colors.dart';
import '../../../data/app_text_styles.dart';
import '../../../utils/app_size.dart';
import 'package:get/get.dart';

void waitListDialog({required BuildContext context}) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: AppColors.whiteColor,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: AppColors.buttonSecondaryColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notification_add_outlined,
              color: AppColors.headlineColor,
              size: 32.r,
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            "You're on the list!",
            style: AppTextStyles.bold(20, color: AppColors.headlineColor),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12.h),
          Text(
            "We'll alert you if a spot becomes available.",
            style: AppTextStyles.regular(16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: () => Get.back(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.buttonPrimaryColor,
              minimumSize: Size(double.infinity, 50.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Text(
              "OK",
              style: AppTextStyles.bold(16, color: Colors.white),
            ),
          ),
        ],
      ),
    ),
  );
}
