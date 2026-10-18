import 'package:flutter/material.dart';
import '../utils/app_size.dart';

class RoundedIconContainer extends StatelessWidget {
  const RoundedIconContainer({
    super.key,
    this.onTap,
    required this.iconPath,
    this.backgroundColor = Colors.white,
    this.iconColor,
    this.border,
  });

  final Function()? onTap;
  final String iconPath;
  final Color backgroundColor;
  final Color? iconColor;
  final BoxBorder? border;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
          border: border,
        ),
        child: Image.asset(
          iconPath,
          height: 20.r,
          width: 20.r,
          color: iconColor,
        ),
      ),
    );
  }
}
