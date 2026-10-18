import 'package:flutter/material.dart';
import '../../../utils/duration_formatter.dart';
import '../../../data/app_text_styles.dart';
import '../../../utils/app_size.dart';
import '../../../widgets/app_image/app_image.dart';
import '../../../widgets/custom_progress.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../models/instructor_data.dart';

class UpcomingClassesCard extends StatelessWidget {
  const UpcomingClassesCard({super.key, required this.instructor});

  final InstructorModel? instructor;

  @override
  Widget build(BuildContext context) {
    if (instructor?.upcomingClasses.isEmpty ?? true) {
      return Center(
        child: Text(
          'No upcoming classes',
          style: AppTextStyles.medium(14, color: Colors.grey),
        ),
      );
    }
    return ListView.builder(
      itemCount: instructor?.upcomingClasses.length ?? 0,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        final upcomingClass = instructor?.upcomingClasses[index];
        final className = upcomingClass?.title ?? 'No name added';
        final String difficulity = upcomingClass?.difficulty ?? 'Not found';
        final price = upcomingClass?.price ?? 0;
        final classInstructorName =
            upcomingClass?.instructorName ?? "Not added";
        final instructorAvater =
            upcomingClass?.instructorAvatar ??
            'https://i.pravatar.cc/150?img=32';
        final duration = upcomingClass?.duration ?? 'Not added';
        final scheduledAt = upcomingClass?.scheduledAt.toString() ?? "N/A";
        DateTime dateTime = DateTime.parse(scheduledAt).toQatarTime();
        final formatedDate = DateFormat('MMMM d, yyyy').format(dateTime);
        final availableSpots = upcomingClass?.availableSpots ?? 0;
        final totalSpots = upcomingClass?.totalSpots ?? 0;
        final progress = (totalSpots - availableSpots) / totalSpots;
        final id = upcomingClass?.id ?? '';
        return GestureDetector(
          onTap: () {
            Get.back(result: id);
          },
          child: Container(
            margin: EdgeInsets.only(bottom: 16.h),
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: const Color(0xFFE8DED3),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        difficulity,
                        style: AppTextStyles.medium(12, color: Colors.grey),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'QAR $price',
                          style: AppTextStyles.bold(
                            20,
                            color: const Color(0xFF6B5345),
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.male,
                              size: 18.r,
                              color: const Color(0xFF6B5345),
                            ),
                            Icon(
                              Icons.female,
                              size: 18.r,
                              color: const Color(0xFF6B5345),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  className,
                  style: AppTextStyles.medium(
                    18,
                    color: const Color(0xFF6B5345),
                  ),
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    ClipOval(
                      child: AppImage(
                        url: instructorAvater,
                        path: "assets/images/network_placeholder_image.jpg",
                        width: 30.r, // radius * 2
                        height: 30.r,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        classInstructorName,
                        style: AppTextStyles.medium(
                          14,
                          color: const Color(0xFF6B5345),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.arrow_forward,
                      color: const Color(0xFF6B5345),
                      size: 24.r,
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              formatedDate,
                              style: AppTextStyles.regular(
                                10,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              formatClassTimeRange(dateTime, duration),
                              style: AppTextStyles.medium(
                                12,
                                color: const Color(0xFF6B5345),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Available spots $availableSpots',
                          style: AppTextStyles.regular(10, color: Colors.grey),
                        ),
                        SizedBox(height: 4.h),
                        SizedBox(
                          width: 100,
                          child: CustomProgress(progress: progress),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
