import 'package:flutter/material.dart';
import 'package:george/app/modules/track_progress/widgets/attendance_chart.dart';
import 'package:george/app/modules/track_progress/widgets/class_attended_info_section.dart';
import 'package:george/app/modules/track_progress/widgets/stat_card_section.dart';
import 'package:george/app/utils/app_size.dart';
import 'package:george/app/widgets/custom_appbar.dart';

import 'package:get/get.dart';

import '../../../data/app_text_styles.dart';
import '../controllers/track_progress_controller.dart';

class TrackProgressView extends GetView<TrackProgressController> {
  const TrackProgressView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Track Progress'),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Monthly Attendance",
                style: AppTextStyles.bold(20, color: const Color(0xFF6D4C41)),
              ),
              SizedBox(height: 10.h),
              AttendanceChatWidget(),
              SizedBox(height: 30.h),
              ClassAttendedInfoSection(),
              SizedBox(height: 10.h),
              StatCardSection(),
              SizedBox(height: 110.h),
            ],
          ),
        ),
      ),
    );
  }
}
