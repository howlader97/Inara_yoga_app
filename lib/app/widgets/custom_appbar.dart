import 'package:flutter/material.dart';
import '../data/app_colors.dart';
import '../data/app_text_styles.dart';
import '../utils/app_size.dart';
import 'package:get/get.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.showAction = false,
    this.actionOnTap,
  });
  final String title;
  final bool showBackButton;
  final bool showAction;
  final Function()? actionOnTap;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: false,
      surfaceTintColor: Colors.transparent,
      backgroundColor: AppColors.backgroundColor,
      leadingWidth: 100,
      title: Text(
        title,
        style: AppTextStyles.medium24.apply(color: const Color(0xFF674E43)),
      ),
      actions: [
        if (showAction)
          GestureDetector(
            onTap: actionOnTap,
            child: Padding(
              padding: EdgeInsets.only(right: 15.w),
              child: Text(
                'Clear',
                style: AppTextStyles.medium16.apply(
                  color: const Color(0xFF674E43),
                ),
              ),
            ),
          ),
      ],
      leading: showBackButton
          ? TextButton.icon(
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 20.sp,
                color: const Color(0xFF6D4C41),
              ),
              label: Text(
                'Back',
                style: AppTextStyles.medium16.apply(
                  color: const Color(0xFF674E43),
                ),
              ),
              onPressed: () => Get.back(),
            )
          : SizedBox.shrink(),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
