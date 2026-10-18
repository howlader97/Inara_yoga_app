import 'package:flutter/material.dart';
import '../../../data/app_colors.dart';
import '../../../data/app_text_styles.dart';
import '../../../utils/app_size.dart';
import '../../../widgets/custom_elevated_button.dart';

void homeViewCallUsDialog({required BuildContext context}) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      backgroundColor: AppColors.whiteColor,
      content: Column(
        spacing: 10.h,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.watch_later_outlined),
          Text(
            "Coming Soon!",
            style: AppTextStyles.bold(20, color: AppColors.headlineColor),
            textAlign: TextAlign.center,
          ),
          Text(
            "This feature is currently under development. Stay tuned for updates!",
            style: AppTextStyles.regular(16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          CustomElevetedButton(
            buttonText: 'Okay',
            onTap: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    ),
  );
}
