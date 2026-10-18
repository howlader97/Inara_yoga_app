import 'package:flutter/material.dart';
import '../../../utils/app_size.dart';

import '../../../data/app_text_styles.dart';

class BadgeContainer extends StatelessWidget {
  const BadgeContainer({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(200),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(text, style: AppTextStyles.medium(12, color: Colors.grey)),
    );
  }
}
