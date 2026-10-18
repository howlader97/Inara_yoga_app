import 'package:flutter/material.dart';
import '../../../data/app_colors.dart';
import '../../../data/app_text_styles.dart';
import 'pass_req_text.dart';
import '../../../utils/app_size.dart';

class PassReqInfo extends StatelessWidget {
  const PassReqInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.cardBackgroundColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Password Requirements:',
            style: AppTextStyles.bold(14, color: AppColors.buttonPrimaryColor),
          ),
          SizedBox(height: 8.h),
          PassRequirmentText(text: 'Minimum 8 characters'),
          PassRequirmentText(text: 'At least one uppercase letter'),
          PassRequirmentText(text: 'At least one number'),
          PassRequirmentText(
            text: 'At least one special character (!@#\$%^&*)',
          ),
        ],
      ),
    );
  }
}
