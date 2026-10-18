import 'package:flutter/material.dart';
import '../data/app_colors.dart';
import '../data/app_text_styles.dart';
import 'package:get/get.dart';

class AuthOptions extends StatelessWidget {
  const AuthOptions({
    super.key,
    this.onTap,
    required this.titleText,
    required this.optionText,
    required this.seconds,
  });
  final Function()? onTap;
  final String titleText, optionText;
  final RxInt seconds;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Center(
        child: GestureDetector(
          onTap: onTap,
          child: RichText(
            text: TextSpan(
              text: titleText,
              style: AppTextStyles.regular(16, color: Colors.grey),
              children: [
                TextSpan(
                  text: optionText,
                  style: AppTextStyles.bold(
                    16,
                    color: seconds.value <= 0
                        ? AppColors.headlineColor
                        : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
