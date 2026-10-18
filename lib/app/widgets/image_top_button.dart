import 'package:flutter/material.dart';
import '../data/app_colors.dart';
import '../data/app_text_styles.dart';
import '../utils/app_size.dart';

class ImageTopButton extends StatelessWidget {
  const ImageTopButton({super.key, this.title = 'Back', this.onTap});
  final String title;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: AppColors.white600.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(40.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.arrow_back_ios,
                color: AppColors.bodyTextColor,
                size: 20.r,
              ),
              Text(
                title,
                style: AppTextStyles.bold(16, color: AppColors.bodyTextColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
