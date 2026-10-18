import 'package:flutter/material.dart';
import 'package:george/app/data/app_text_styles.dart';
import 'package:george/app/modules/track_progress/controllers/track_progress_controller.dart';
import 'package:george/app/utils/app_size.dart';
import 'package:get/get.dart';

class AttendanceChatWidget extends StatelessWidget {
  const AttendanceChatWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TrackProgressController>();
    return SizedBox(
      height: 200.h,
      child: Obx(() {
        return ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: controller.attendanceData.length,
          separatorBuilder: (context, index) => SizedBox(width: 12.w),
          itemBuilder: (context, index) {
            final data = controller.attendanceData[index];
            final double total = (data['total'] as num).toDouble();
            final double attended = (data['attended'] as num).toDouble();
            final double percentage = attended / (total == 0 ? 1 : total);

            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  data['classes_label'],
                  style: TextStyle(fontSize: 10.sp, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 5.h),
                SizedBox(
                  width: 50.w,
                  height: 140.h,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      // Background Bar
                      Container(
                        width: 50.w,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEBE3D9),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      FractionallySizedBox(
                        heightFactor: percentage.clamp(0.0, 1.0),
                        child: Container(
                          width: 50.w,
                          decoration: BoxDecoration(
                            color: const Color(0xFF6D4C41),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  data['month'],
                  style: AppTextStyles.medium(
                    14,
                  ).copyWith(color: const Color(0xFF6D4C41)),
                ),
              ],
            );
          },
        );
      }),
    );
  }
}
