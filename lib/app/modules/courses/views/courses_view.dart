import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../utils/duration_formatter.dart';
import '../../../utils/app_size.dart';
import '../../../widgets/app_image/app_image.dart';
import '../../../../models/all_courses_model.dart';
import 'package:get/get.dart';
import '../../../data/app_colors.dart';
import '../../../data/app_text_styles.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/app_refresh_indicator.dart';
import '../../home/controllers/home_controller.dart';
import '../../home/widgets/available_spot_indicator.dart';
import '../controllers/courses_controller.dart';

class CoursesView extends GetView<CoursesController> {
  const CoursesView({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildCoursesHeader(context),
            Expanded(
              child: Obx(() {
                final isLoading = controller.isLoading.value;
                final courses = controller.coursesList;

                if (!isLoading && courses.isEmpty) {
                  return const Center(child: Text("No Courses Found"));
                }

                final displayList = isLoading
                    ? List.generate(
                        3,
                        (index) => Course(
                          title: 'Hatha Yoga Alignment Course',
                          slug: 'mock-course',
                          description: 'Mock Description',
                          imageUrl: '',
                          price: 150.0,
                          scheduledAt: DateTime.now(),
                          duration: '4 Weeks',
                          difficulty: 'All Levels',
                          language: 'English',
                          gender: 'Both',
                          location: 'Main Studio',
                          phone: '+974 5550 5301',
                          locationMapLink: '',
                          maxParticipants: 20,
                          availableSeat: 15,
                          id: 'mock_$index',
                          publishedAt: DateTime.now(),
                          createdAt: DateTime.now(),
                          updatedAt: DateTime.now(),
                          instructor: Instructor(
                            id: 'mock_inst',
                            name: 'Sarah Jenkins',
                            email: 'sarah@example.com',
                            avatar: '',
                          ),
                        ),
                      )
                    : courses;

                return Skeletonizer(
                  enabled: isLoading,
                  child: AppRefreshIndicator(
                    onRefresh: () async {
                      await controller.fetchCourses();
                    },
                    child: ListView.builder(
                      controller: controller.scrollController,
                      physics: isLoading
                          ? const NeverScrollableScrollPhysics()
                          : const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.only(
                        top: 20.h,
                        bottom: 100.h,
                        left: 24.w,
                        right: 24.w,
                      ),
                      itemCount:
                          displayList.length +
                          (!isLoading && controller.isLoadingMore.value
                              ? 1
                              : 0),
                      itemBuilder: (context, index) {
                        if (index == displayList.length) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFF6B5345),
                              ),
                            ),
                          );
                        }

                        final course = displayList[index];

                        return _buildCourseCard(homeController, course);
                      },
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoursesHeader(BuildContext context) {
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
        bottom: 24.h,
      ),
      child: Center(
        child: Text(
          'Courses',
          style: AppTextStyles.medium24.apply(color: const Color(0xFF674E43)),
        ),
      ),
    );
  }

  Widget _buildCourseCard(
    HomeController homeController,
    Course course,
    //  {
    // bool showBadge = true,
    // }
  ) {
    final seatPercentage = course.maxParticipants == 0
        ? 0.0
        : ((course.maxParticipants - course.availableSeat) /
              course.maxParticipants);

    final scheduledAt = course.scheduledAt;
    final endDate = course.endDate;

    Widget dateAndTimeWidget;

    if (scheduledAt == null) {
      dateAndTimeWidget = const SizedBox.shrink();
    } else {
      final localStart = scheduledAt.toQatarTime();
      final localEnd = endDate?.toQatarTime();

      if (localEnd == null ||
          (localStart.year == localEnd.year &&
              localStart.month == localEnd.month &&
              localStart.day == localEnd.day)) {
        final dateStr = DateFormat('MMM d, yyyy').format(localStart);
        dateAndTimeWidget = Row(
          children: [
            Icon(Icons.access_time, size: 16.r, color: Colors.grey),
            SizedBox(width: 8.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dateStr,
                  style: AppTextStyles.regular(12, color: Colors.grey),
                ),
                Text(
                  formatClassTimeRange(localStart, course.duration),
                  style: AppTextStyles.medium(
                    12,
                    color: AppColors.headlineColor,
                  ),
                ),
              ],
            ),
          ],
        );
      } else {
        final startStr = DateFormat('MMM d, yyyy').format(localStart);
        final endStr = DateFormat('MMM d, yyyy').format(localEnd);
        dateAndTimeWidget = Row(
          children: [
            Icon(Icons.calendar_month_outlined, size: 16.r, color: Colors.grey),
            SizedBox(width: 8.w),
            Text(
              '$startStr - $endStr',
              style: AppTextStyles.medium(12, color: AppColors.headlineColor),
            ),
          ],
        );
      }
    }
    // return Obx(() {
    // final isPaid = homeController.isMembershipPaid.value && showBadge;

    // final price = isPaid ? 'QAR 0' : 'QAR ${course.price}';

    return GestureDetector(
      onTap: () => Get.toNamed(
        Routes.courseDetails,
        preventDuplicates: true,
        arguments: course.id,
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: 24.h),
        decoration: BoxDecoration(
          color: AppColors.cardBackgroundColor,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: const Color(0xFF6D4C41).withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Course Image
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
              child: AppImage(
                url: course.imageUrl,
                networkPlaceholderImage:
                    "assets/images/network_placeholder_image.jpg", // fallback
                fit: BoxFit.cover,
                width: double.infinity,
                height: 180.h,
              ),
            ),

            /// Content
            Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Level + Price
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
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Row(
                          children: [
                            Text(
                              course.difficulty,
                              style: AppTextStyles.medium(
                                12,
                                color: Colors.grey,
                              ),
                            ),
                            // if (isPaid) ...[
                            //   SizedBox(width: 8.w),
                            //   Text(
                            //     '| Membership',
                            //     style: AppTextStyles.medium(
                            //       12,
                            //       color: Colors.grey,
                            //     ),
                            //   ),
                            // ],
                          ],
                        ),
                      ),
                      Text(
                        'QAR ${course.price}',
                        style: AppTextStyles.medium(
                          16,
                          color: AppColors.headlineColor,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 8.h),

                  /// Title
                  Text(
                    course.title,
                    style: AppTextStyles.medium(
                      20,
                      color: AppColors.headlineColor,
                    ),
                  ),

                  SizedBox(height: 12.h),

                  /// Instructor
                  Row(
                    children: [
                      ClipOval(
                        child: AppImage(
                          url: course.instructor.avatar,
                          path: "assets/images/network_placeholder_image.jpg",
                          width: 40.r, // radius * 2
                          height: 40.r,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Instructor',
                            style: AppTextStyles.regular(
                              10,
                              color: Colors.grey,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                course.instructor.name,
                                style: AppTextStyles.medium(
                                  14,
                                  color: AppColors.headlineColor,
                                ),
                              ),
                              if (controller.bookedCourseIds.contains(
                                course.id,
                              )) ...[
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
                        ],
                      ),
                      // const Spacer(),
                      // Icon(
                      //   Icons.arrow_forward,
                      //   size: 20.r,
                      //   color: AppColors.headlineColor,
                      // ),
                    ],
                  ),

                  SizedBox(height: 16.h),

                  /// Divider Line
                  Row(
                    children: List.generate(
                      20,
                      (index) => Expanded(
                        child: Container(
                          height: 1,
                          margin: EdgeInsets.symmetric(horizontal: 2.w),
                          color: index % 2 == 0
                              ? Colors.grey.shade400
                              : Colors.transparent,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 16.h),

                  /// Date + Seats
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      dateAndTimeWidget,

                      /// Seat Info
                      SizedBox(
                        width: 100.w,
                        child: AvailableSpotsIndicator(
                          availableSeats: course.availableSeat,
                          progress: seatPercentage,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    // });
  }
}
