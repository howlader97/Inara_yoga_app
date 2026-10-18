import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../utils/app_size.dart';
import 'package:get/get.dart';

import '../../../data/app_text_styles.dart';
import '../controllers/home_controller.dart';

class ClassHeaderSection extends GetView<HomeController> {
  const ClassHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Obx(
          //   () => Text(
          //     controller.selectedDateLabel == 'Upcoming Classes'
          //         ? 'Upcoming Classes'
          //         : "${controller.selectedDateLabel}'s Classes",
          //     style: AppTextStyles.bold(24, color: AppColors.headlineColor),
          //   ),
          // ),
          Obx(() {
            final date = controller.currentDate.value;
            if (date.isEmpty) return const SizedBox();

            try {
              // Parse the date string in MM-DD-YYYY format
              final parts = date.split('-');
              if (parts.length == 3) {
                final month = int.parse(parts[0]);
                final day = int.parse(parts[1]);
                final year = int.parse(parts[2]);

                final dateTime = DateTime(year, month, day);
                final dateFormat = DateFormat('EEE d MMM').format(dateTime);

                return Text(
                  dateFormat,
                  style: AppTextStyles.regular(14, color: Colors.grey),
                );
              }
            } catch (e) {
              // If parsing fails, return the original string or empty
              return Text(
                date,
                style: AppTextStyles.regular(14, color: Colors.grey),
              );
            }

            return const SizedBox();
          }),
        ],
      ),
    );
  }
}
