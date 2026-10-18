import 'package:flutter/material.dart';
import 'package:george/app/routes/app_pages.dart';
import 'package:intl/intl.dart';
import '../../../../models/booking_history_model.dart';
import '../../../../models/upcoming_booking_model.dart';
import '../../../utils/app_size.dart';
import '../../../widgets/app_image/app_image.dart';
import '../../../widgets/custom_appbar.dart';
import 'package:get/get.dart';
import '../../../utils/duration_formatter.dart';

import '../../../data/app_colors.dart';
import '../../../data/app_text_styles.dart';
import '../controllers/my_bookings_controller.dart';

class MyBookingsView extends GetView<MyBookingsController> {
  const MyBookingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(title: "My Bookings"),
      body: SafeArea(
        child: Column(
          children: [
            _buildTabs(),
            Expanded(
              child: Obx(() {
                if (controller.selectedTab.value == 0) {
                  return _buildUpcomingList(context);
                } else {
                  return _buildHistoryList();
                }
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Obx(
        () => Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => controller.selectTab(0),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  decoration: BoxDecoration(
                    color: controller.selectedTab.value == 0
                        ? const Color(0xFF6B5345)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Center(
                    child: Text(
                      'Upcoming',
                      style: AppTextStyles.bold(
                        16,
                        color: controller.selectedTab.value == 0
                            ? Colors.white
                            : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => controller.selectTab(1),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  decoration: BoxDecoration(
                    color: controller.selectedTab.value == 1
                        ? const Color(0xFF6B5345)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Center(
                    child: Text(
                      'History',
                      style: AppTextStyles.bold(
                        16,
                        color: controller.selectedTab.value == 1
                            ? Colors.white
                            : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingList(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingUpcoming.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (controller.upcomingBookings.isEmpty) {
        return const Center(child: Text("No upcoming bookings found"));
      }
      return RefreshIndicator(
        onRefresh: () => controller.fetchUpcomingBookings(),
        child: ListView(
          padding: EdgeInsets.all(24.r),
          children: [
            ...controller.upcomingBookings.map(
              (item) => Padding(
                padding: EdgeInsets.only(bottom: 24.h),
                child: _buildBookingCard(context, item),
              ),
            ),
            if (controller.upcomingBookings.isNotEmpty) ...[
              SizedBox(height: 8.h),
              _buildCancellationRule(
                controller.upcomingBookings.first.cancellationRule ??
                    'Cancellations made within 3 hours of the class start time are non refundable.',
              ),
            ],
          ],
        ),
      );
    });
  }

  Widget _buildHistoryList() {
    return Obx(() {
      if (controller.isLoadingHistory.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (controller.historyBookings.isEmpty) {
        return const Center(child: Text("No booking history found"));
      }
      return ListView.builder(
        padding: EdgeInsets.all(24.r),
        itemCount: controller.historyBookings.length,
        itemBuilder: (context, index) {
          final item = controller.historyBookings[index];
          return Padding(
            padding: EdgeInsets.only(bottom: 24.h),
            child: _buildHistoryCard(item),
          );
        },
      );
    });
  }

  Widget _buildHistoryCard(BookingHistoryItem item) {
    const Color brownColor = Color(0xFF6B5345);
    const Color cardColor = Color(0xFFE8DED3);

    final isClass = item.bookingType == 'CLASS';
    final title = (isClass ? item.classTitle : item.courseTitle) ?? '';
    final imageUrl = (isClass ? item.classImageUrl : item.courseImageUrl) ?? '';
    final scheduledAt = isClass
        ? item.classScheduledAt
        : item.courseScheduledAt;
    final location = (isClass ? item.classLocation : item.courseLocation) ?? '';

    String displayStatus = item.status;
    if (displayStatus.isNotEmpty) {
      displayStatus =
          displayStatus[0].toUpperCase() +
          displayStatus.substring(1).toLowerCase();
    }

    return GestureDetector(
      onTap: () {
        if (isClass) {
          if (item.classId != null) {
            Get.toNamed(
              Routes.classDetails,
              arguments: {'id': item.classId, 'fromHistory': true},
            );
          }
        } else {
          if (item.courseId != null) {
            Get.toNamed(
              Routes.courseDetails,
              arguments: {'id': item.courseId, 'fromHistory': true},
            );
          }
        }
      },
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15.r),
              child: AppImage(
                url: imageUrl,
                path: "assets/images/network_placeholder_image.jpg",
                height: 180.h,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      _formatBookingDate(scheduledAt),
                      style: AppTextStyles.medium(
                        10,
                        color: brownColor.withValues(alpha: 0.8),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    displayStatus,
                    style: AppTextStyles.medium(
                      10,
                      color: brownColor.withValues(alpha: 0.8),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Text(title, style: AppTextStyles.bold(20, color: brownColor)),
            SizedBox(height: 12.h),
            Row(
              children: [
                SizedBox(
                  width: 36.r,
                  height: 36.r,
                  child: ClipOval(
                    child: AppImage(
                      url: 'https://i.pravatar.cc/150?img=32',
                      path: "assets/images/network_placeholder_image.jpg",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Instructors',
                        style: AppTextStyles.regular(
                          10,
                          color: brownColor.withValues(alpha: 0.6),
                        ),
                      ),
                      Text(
                        item.instructorName ?? 'Sarah Jenkins',
                        style: AppTextStyles.medium(14, color: brownColor),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 16.r,
                  color: brownColor.withValues(alpha: 0.6),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    location,
                    style: AppTextStyles.medium(
                      12,
                      color: brownColor.withValues(alpha: 0.6),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatBookingDate(DateTime? scheduledAt) {
    if (scheduledAt == null) return '';
    final localTime = scheduledAt.toQatarTime();
    return DateFormat('MMM dd, yyyy, h:mm a').format(localTime);
  }

  Widget _buildBookingCard(BuildContext context, UpcomingBookingItem item) {
    const Color brownColor = Color(0xFF6B5345);
    const Color cardColor = Color(0xFFE8DED3);

    final isClass = item.bookingType == 'CLASS';
    final titleText =
        (isClass ? item.classTitle : item.courseTitle) ??
        item.notes ??
        (isClass ? 'Class' : 'Course');
    final imageUrl = (isClass ? item.classImageUrl : item.courseImageUrl) ?? '';
    final locationText = item.location ?? '';
    final scheduledText = _formatBookingDate(item.scheduledAt);
    final instructor = item.instructorName ?? '';
    final avatar = item.instructorAvatar ?? '';

    String displayStatus = item.status;
    if (displayStatus.isNotEmpty) {
      displayStatus =
          displayStatus[0].toUpperCase() +
          displayStatus.substring(1).toLowerCase();
    }

    return GestureDetector(
      onTap: () {
        if (isClass) {
          if (item.classId != null) {
            Get.toNamed(
              Routes.classDetails,
              arguments: {'id': item.classId, 'fromHistory': true},
            );
          }
        } else {
          if (item.courseId != null) {
            Get.toNamed(
              Routes.courseDetails,
              arguments: {'id': item.courseId, 'fromHistory': true},
            );
          }
        }
      },
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15.r),
              child: AppImage(
                url: imageUrl,
                path:
                    "assets/images/network_placeholder_image.jpg", // fallback asset
                height: 180.h,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      scheduledText,
                      style: AppTextStyles.medium(
                        10,
                        color: brownColor.withValues(alpha: 0.8),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3EFE9),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    displayStatus,
                    style: AppTextStyles.medium(10, color: brownColor),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Text(
              titleText,
              style: AppTextStyles.bold(20, color: brownColor),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                SizedBox(
                  width: 36.r,
                  height: 36.r,
                  child: ClipOval(
                    child: AppImage(
                      url: avatar,
                      path: "assets/images/network_placeholder_image.jpg",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Instructors',
                        style: AppTextStyles.regular(
                          10,
                          color: brownColor.withValues(alpha: 0.6),
                        ),
                      ),
                      Text(
                        instructor,
                        style: AppTextStyles.medium(14, color: brownColor),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 16.r,
                  color: brownColor.withValues(alpha: 0.6),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    locationText,
                    style: AppTextStyles.medium(
                      12,
                      color: brownColor.withValues(alpha: 0.6),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            SizedBox(
              width: double.infinity,
              height: 45.h,
              child: ElevatedButton(
                onPressed: () => _showCancelConfirmationDialog(context, item),
                style: ElevatedButton.styleFrom(
                  backgroundColor: brownColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Cancel',
                  style: AppTextStyles.bold(16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCancelConfirmationDialog(
    BuildContext context,
    UpcomingBookingItem item,
  ) {
    _showCustomDialog(
      context,
      title: 'Cancel Booking?',
      subtitle: 'Do you really want to cancel this booking?',
      onYes: () async {
        // Show a loading dialog
        Get.dialog(
          const Center(child: CircularProgressIndicator()),
          barrierDismissible: false,
        );

        final response = await controller.cancelBooking(
          bookingId: item.bookingId,
        );

        // Close loading dialog
        Navigator.pop(context);

        if (response != null) {
          _showClassCancelledDialog(
            context,
            refundMessage: response['refund_message'] ?? '',
            cancellationRule: response['cancellation_rule'] ?? '',
          );
        }
      },
    );
  }

  void _showClassCancelledDialog(
    BuildContext context, {
    required String refundMessage,
    required String cancellationRule,
  }) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Container(
          padding: EdgeInsets.all(20.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.close, size: 24.r, color: Colors.grey),
                ),
              ),
              Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                  size: 40.r,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Class Cancelled',
                textAlign: TextAlign.center,
                style: AppTextStyles.bold(20, color: const Color(0xFF6B5345)),
              ),
              SizedBox(height: 12.h),
              Text(
                refundMessage.isNotEmpty
                    ? refundMessage
                    : 'Your class has been cancelled successfully.',
                textAlign: TextAlign.center,
                style: AppTextStyles.regular(14, color: Colors.grey.shade600),
              ),
              if (cancellationRule.isNotEmpty) ...[
                SizedBox(height: 8.h),
                Text(
                  cancellationRule,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.regular(12, color: Colors.grey.shade500),
                ),
              ],
              SizedBox(height: 24.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close dialog
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6B5345),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                  ),
                  child: Text(
                    'Close',
                    style: AppTextStyles.bold(16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCustomDialog(
    BuildContext context, {
    required String title,
    required String subtitle,
    required VoidCallback onYes,
  }) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Container(
          padding: EdgeInsets.all(20.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.close, size: 24.r, color: Colors.grey),
                ),
              ),
              Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.cancel_outlined,
                  color: Colors.red,
                  size: 40.r,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                title,
                textAlign: TextAlign.center,
                style: AppTextStyles.bold(20, color: const Color(0xFF6B5345)),
              ),
              SizedBox(height: 12.h),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.regular(14, color: Colors.grey.shade600),
              ),
              SizedBox(height: 24.h),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFDCC8B8),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                      child: Text(
                        'No',
                        style: AppTextStyles.bold(16, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        onYes();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6B5345),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                      ),
                      child: Text(
                        'Yes',
                        style: AppTextStyles.bold(16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCancellationRule(String rule) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cancellation Rule',
          style: AppTextStyles.bold(18, color: const Color(0xFF6B5345)),
        ),
        SizedBox(height: 8.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 6.h),
              child: Container(
                width: 4.r,
                height: 4.r,
                decoration: const BoxDecoration(
                  color: Colors.grey,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                rule,
                style: AppTextStyles.regular(14, color: Colors.grey.shade600),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
