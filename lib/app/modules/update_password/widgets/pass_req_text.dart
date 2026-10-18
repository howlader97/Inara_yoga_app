import 'package:flutter/material.dart';
import '../../../data/app_colors.dart';
import '../../../data/app_text_styles.dart';
import '../../../utils/app_size.dart';

class PassRequirmentText extends StatelessWidget {
  const PassRequirmentText({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 16,
            color: AppColors.bodyTextColor,
          ),
          SizedBox(width: 8.w),
          Text(
            text,
            style: AppTextStyles.regular(12, color: AppColors.bodyTextColor),
          ),
        ],
      ),
    );
  }
}
