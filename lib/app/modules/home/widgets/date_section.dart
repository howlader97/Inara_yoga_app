import 'package:flutter/material.dart';
import '../../../data/app_colors.dart';
import '../../../data/app_text_styles.dart';
import '../controllers/home_controller.dart';
import '../../../utils/app_size.dart';
import 'package:get/get.dart';

class DateSection extends StatelessWidget {
  const DateSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  controller.handleTodayButtonClick();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.buttonSecondaryColor,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    "Today",
                    style: AppTextStyles.medium(
                      12,
                      color: AppColors.headlineColor,
                    ),
                  ),
                ),
              ),
              Obx(
                () => Row(
                  children: [
                    GestureDetector(
                      onTap: () => controller.previousMonth(),
                      behavior: HitTestBehavior.opaque,
                      child: Padding(
                        padding: EdgeInsets.all(8.r),
                        child: Icon(
                          Icons.arrow_back_ios,
                          size: 14.r,
                          color: AppColors.headlineColor,
                        ),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '${controller.currentMonthName} ${controller.currentYear}',
                      style: AppTextStyles.medium(
                        14,
                        color: AppColors.headlineColor,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    GestureDetector(
                      onTap: () => controller.nextMonth(),
                      behavior: HitTestBehavior.opaque,
                      child: Padding(
                        padding: EdgeInsets.all(8.r),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 14.r,
                          color: AppColors.headlineColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        SizedBox(
          height: 65.h,
          child: Obx(
            () => ListView.builder(
              controller: controller.scrollController,
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              itemCount: controller.dates.length,
              itemBuilder: (context, index) {
                return Obx(() {
                  bool isSelected = controller.selectedDateIndex.value == index;
                  var dateItem = controller.dates[index];
                  return GestureDetector(
                    onTap: () {
                      controller.setSelectedDate(index);
                    },
                    child: Container(
                      width: 60.w,
                      margin: EdgeInsets.symmetric(horizontal: 4.w),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.buttonPrimaryColor
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: isSelected
                              ? Colors.transparent
                              : Colors.grey.shade400,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            dateItem['day'] ?? '',
                            style: AppTextStyles.regular(
                              12,
                              color: isSelected
                                  ? Colors.white
                                  : Colors.grey.shade600,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            dateItem['date'] ?? '',
                            style: AppTextStyles.bold(
                              14,
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.headlineColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
