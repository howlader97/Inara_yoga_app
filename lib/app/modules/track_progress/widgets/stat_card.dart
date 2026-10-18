import 'package:flutter/material.dart';
import 'package:george/app/data/app_text_styles.dart';
import 'package:george/app/utils/app_size.dart';
import 'package:george/app/widgets/app_image/app_image.dart';

class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    this.icon = Icons.watch_later_outlined,
    required this.title,
    required this.subtitle,
    this.showIcon = true,
  });
  final IconData icon;
  final String title;
  final String subtitle;
  final bool showIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        color: const Color(
          0xFFD7CCC8,
        ).withValues(alpha: 0.5), // Light brownish/beige
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showIcon)
            Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: Icon(icon, size: 35.r, color: const Color(0xFF6D4C41)),
            ),
          if (!showIcon)
            Container(
              width: 35.r,
              height: 35.r,
              margin: EdgeInsets.only(bottom: 10.h),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                // border: Border.all(color: Colors.white, width: 2),
              ),
              child: ClipOval(
                child: AppImage(
                  url: "https://picsum.photos/seed/yoga_pose/800/600",
                  fit: BoxFit.cover,
                  path: "assets/images/network_placeholder_image.jpg",
                ),
              ),
            ),
          Text(
            title,
            style: AppTextStyles.bold(
              14,
            ).copyWith(color: const Color(0xFF6D4C41)),
          ),
          SizedBox(height: 5.h),
          Text(
            subtitle,
            style: AppTextStyles.regular(
              10,
            ).copyWith(color: const Color(0xFF6D4C41).withValues(alpha: 0.8)),
          ),
        ],
      ),
    );
  }
}
