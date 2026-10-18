import 'package:flutter/material.dart';
import '../../../data/app_colors.dart';
import '../../../data/image_path.dart';
import '../controllers/home_controller.dart';
import '../../notifications/controllers/notifications_controller.dart';
import '../../courses/controllers/filter_controller.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/app_size.dart';
import '../../../widgets/custom_text_button.dart';
import '../../../widgets/rounded_icon_container.dart';
import 'package:get/get.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.cardBackgroundColor,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30.r)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6D4C41).withValues(alpha: 0.12),
            offset: const Offset(0, 8),
            blurRadius: 16,
          ),
        ],
      ),
      padding: EdgeInsets.only(
        left: 24.w,
        right: 24.w,
        top: 10.h,
        bottom: 20.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomTextButton(
            icon: Icons.menu_book,
            buttonText: 'Bookings',
            onTap: () => Get.toNamed(Routes.myBookings),
          ),
          Image.asset(
            ImagePath.splashImage,
            height: 100.h,
            width: 100.w,
            fit: BoxFit.contain,
          ),
          Row(
            children: [
              Obx(() {
                final isApplied =
                    Get.isRegistered<FilterController>() &&
                    Get.find<FilterController>().isFilterApplied.value;
                return RoundedIconContainer(
                  iconPath: ImagePath.funnelIcon,
                  onTap: () {
                    final filterController = Get.find<FilterController>();
                    filterController.setArgs({
                      'instructors': controller.allInstructor.value,
                      'classes': controller.allClassName.value,
                    });
                    Get.toNamed(
                      Routes.filter,
                      arguments: {
                        'instructors': controller.allInstructor.value,
                        'classes': controller.allClassName.value,
                      },
                    );
                  },
                  backgroundColor: Colors.white,
                  iconColor: AppColors.headlineColor,
                  border: isApplied
                      ? Border.all(color: AppColors.headlineColor, width: 1.5.r)
                      : null,
                );
              }),
              SizedBox(width: 12.w),
              Obx(() {
                final notificationsController =
                    Get.find<NotificationsController>();
                final unreadCount = notificationsController.unreadCount.value;
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.notifications);
                      },
                      child: Container(
                        padding: EdgeInsets.all(8.r),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.notifications_none_outlined,
                          size: 25.r,
                          color: AppColors.bodyTextColor,
                        ),
                      ),
                    ),
                    if (unreadCount > 0)
                      Positioned(
                        top: 6.h,
                        right: 4.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: unreadCount > 9 ? 4.w : 0,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.notificationBadgeColor,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          constraints: BoxConstraints(
                            minWidth: 16.r,
                            minHeight: 16.r,
                          ),
                          child: Center(
                            child: Text(
                              unreadCount > 99 ? '99+' : '$unreadCount',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9.sp,
                                fontWeight: FontWeight.bold,
                                height: 1.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              }),
            ],
          ),
        ],
      ),
    );
  }
}
