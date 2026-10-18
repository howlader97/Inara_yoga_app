import 'package:flutter/material.dart';
import '../data/app_colors.dart';
import '../data/app_text_styles.dart';

class HeaderSubText extends StatelessWidget {
  const HeaderSubText({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: AppTextStyles.regular(
        14,
        color: AppColors.headlineColor.withValues(alpha: 0.8),
      ),
    );
  }
}
