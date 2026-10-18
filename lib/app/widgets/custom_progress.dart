import 'package:flutter/material.dart';
import '../data/app_colors.dart';
import '../utils/app_size.dart';

class CustomProgress extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final Color? backgroundColor;
  final Color? progressColor;
  final double? height;

  const CustomProgress({
    super.key,
    required this.progress,
    this.backgroundColor,
    this.height,
    this.progressColor,
  });

  @override
  Widget build(BuildContext context) {
    final clampedProgress = progress.clamp(0.0, 1.0);

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final thumbPosition = (width * clampedProgress).clamp(12, width - 12);

        return Stack(
          alignment: Alignment.centerLeft,
          children: [
            // Background Bar
            Container(
              height: height ?? 15.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: backgroundColor ?? Colors.grey.shade300,
                borderRadius: BorderRadius.circular(100),
              ),
            ),

            // Progress Fill
            Container(
              height: height ?? 15.h,
              width: thumbPosition.toDouble(),
              decoration: BoxDecoration(
                color: progressColor ?? AppColors.buttonPrimaryColor,
                borderRadius: BorderRadius.circular(100),
              ),
            ),

            // Thumb Circle
            Positioned(
              left: thumbPosition - 12, // half of thumb size
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Center(
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
