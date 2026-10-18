import 'package:flutter/material.dart';

import '../data/app_colors.dart';
import '../data/app_text_styles.dart';

class HeaderText extends StatelessWidget {
  const HeaderText({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.bold(
        32,
        color: AppColors.headlineColor,
        fontFamily: 'Times New Roman',
      ),
    );
  }
}
