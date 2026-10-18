import 'package:flutter/material.dart';
import '../../../data/app_colors.dart';
import '../../../data/app_text_styles.dart';
import 'available_spot_indicator.dart';
import 'badge_container.dart';
import 'cancelled_indicator.dart';
import 'fully_booked_indicator.dart';
import 'gender_icon_row.dart';
import 'wait_list_dialog.dart';
import '../controllers/home_controller.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/app_size.dart';
import '../../../widgets/app_image/app_image.dart';
import 'package:get/get.dart';

class ClassCard extends StatelessWidget {
  final String badge;
  final String title;
  final String price;
  final String time;
  final String instructor;
  final String status;
  final int? availableSeats;
  final bool isMembershipPaid;
  final String image;
  final double progress;
  final String classId;
  final String gender;
  final bool isBooked;

  const ClassCard({
    super.key,
    required this.badge,
    required this.title,
    required this.price,
    required this.time,
    required this.instructor,
    required this.status,
    this.availableSeats,
    required this.isMembershipPaid,
    required this.image,
    required this.progress,
    required this.classId,
    required this.gender,
    this.isBooked = false,
  });

  @override
  Widget build(BuildContext context) {
    final classStatus = status.toLowerCase();
    return GestureDetector(
      onTap: () async {
        await Get.toNamed(Routes.classDetails, arguments: classId);
        if (Get.isRegistered<HomeController>()) {
          final homeController = Get.find<HomeController>();
          homeController.fetchBookedItems();
          homeController.fetchClasses(homeController.currentDate.value);
        }
      },
      child: Container(
        padding: EdgeInsets.all(16.r),
        margin: EdgeInsets.only(bottom: 15.h),
        decoration: BoxDecoration(
          color: AppColors.cardBackgroundColor,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: const Color(0xFFFFFFFF).withValues(alpha: 0.6),
            width: 1.5.r,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6D4C41).withValues(alpha: 0.08),
              offset: const Offset(4, 8),
              blurRadius: 16,
            ),
            BoxShadow(
              color: const Color(0xFFFFFFFF).withValues(alpha: 0.8),
              offset: const Offset(-4, -4),
              blurRadius: 12,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    BadgeContainer(text: badge),
                    if (isMembershipPaid) ...[
                      SizedBox(width: 8.w),
                      BadgeContainer(text: 'Membership'),
                    ],
                  ],
                ),
                Text(
                  price,
                  style: AppTextStyles.medium(
                    16,
                    color: AppColors.headlineColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: AppTextStyles.medium(
                      18,
                      color: AppColors.headlineColor,
                    ),
                  ),
                ),
                GenderIconsRow(gender: gender),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Row(
                  children: [
                    ClipOval(
                      child: AppImage(
                        url: image,
                        path: "assets/images/network_placeholder_image.jpg",
                        width: 30.r, // radius * 2
                        height: 30.r,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      instructor,
                      style: AppTextStyles.regular(
                        14,
                        color: AppColors.headlineColor,
                      ),
                    ),
                    if (isBooked) ...[
                      SizedBox(width: 8.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8EFEA),
                          borderRadius: BorderRadius.circular(100.r),
                        ),
                        child: Text(
                          'Booked ✓',
                          style: AppTextStyles.medium(
                            11,
                            color: const Color(0xFF3E5C46),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const Spacer(),
                if (status == 'available')
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(
                        Routes.courseDetails,
                        preventDuplicates: true,
                        arguments: {
                          'title': title,
                          'price': price,
                          'fromHistory': status != 'available',
                        },
                      );
                    },
                    child: Icon(
                      Icons.arrow_forward,
                      color: AppColors.headlineColor,
                      size: 24.r,
                    ),
                  )
                else if (status == 'fully_booked')
                  GestureDetector(
                    onTap: () => waitListDialog(context: context),
                    child: Icon(
                      Icons.notification_add_outlined,
                      color: AppColors.headlineColor,
                      size: 24.r,
                    ),
                  ),
              ],
            ),
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.access_time, size: 16.r, color: Colors.grey),
                    SizedBox(width: 4.w),
                    Text(
                      time,
                      style: AppTextStyles.regular(14, color: Colors.grey),
                    ),
                  ],
                ),
                if (classStatus != 'cancelled' && availableSeats != 0)
                  SizedBox(
                    width: 100.w,
                    child: AvailableSpotsIndicator(
                      availableSeats: availableSeats ?? 0,
                      progress: progress,
                    ),
                  )
                else if (availableSeats == 0)
                  const FullyBookedIndicator()
                else if (classStatus == 'cancelled')
                  const CancelledIndicator(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
