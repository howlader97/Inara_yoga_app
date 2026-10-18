import 'package:flutter/material.dart';
import '../../../data/app_colors.dart';
import '../../../data/app_text_styles.dart';
import '../../../utils/app_size.dart';

class QuickActionItem extends StatelessWidget {
  final String iconPath;
  final String label;
  final VoidCallback? onTap;
  final Color? iconColor;

  const QuickActionItem({
    super.key,
    required this.iconPath,
    required this.label,
    this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 60.r,
            width: 60.r,
            padding: EdgeInsets.all(14.r),
            decoration: BoxDecoration(
              color: AppColors.backgroundColor,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: const Color(0xFFFFFFFF).withValues(alpha: 0.7),
                width: 1.r,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6D4C41).withValues(alpha: 0.15),
                  offset: const Offset(4, 6),
                  blurRadius: 10,
                ),
                BoxShadow(
                  color: const Color(0xFFFFFFFF).withValues(alpha: 0.9),
                  offset: const Offset(-4, -4),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Image.asset(
              iconPath,
              fit: BoxFit.contain,
              color: iconColor ?? AppColors.bodyTextColor,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            label,
            style: AppTextStyles.regular(12, color: AppColors.headlineColor),
          ),
        ],
      ),
    );
  }
}
