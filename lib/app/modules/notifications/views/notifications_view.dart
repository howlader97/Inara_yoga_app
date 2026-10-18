import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../models/notification_model.dart';
import '../../../data/app_colors.dart';
import '../../../data/app_text_styles.dart';
import '../../../utils/app_size.dart';
import '../../../widgets/app_refresh_indicator.dart';
import '../../../widgets/custom_appbar.dart';
import '../controllers/notifications_controller.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  late final NotificationsController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<NotificationsController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(title: 'Notifications'),
      body: SafeArea(
        child: Column(
          children: [
            // Filter Bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              child: Row(
                children: [
                  _buildFilterChip(label: 'All', isUnread: false),
                  SizedBox(width: 12.w),
                  Obx(
                    () => _buildFilterChip(
                      label: controller.unreadCount.value > 0
                          ? 'Unread (${controller.unreadCount.value})'
                          : 'Unread',
                      isUnread: true,
                    ),
                  ),
                ],
              ),
            ),
            // Notifications List
            Expanded(
              child: Obx(() {
                final isLoading = controller.isLoading.value;
                final notifications = controller.notificationsList;

                if (!isLoading && notifications.isEmpty) {
                  return Center(
                    child: Text(
                      'No Notifications Found',
                      style: AppTextStyles.medium(16, color: Colors.grey),
                    ),
                  );
                }

                final displayList = isLoading
                    ? List.generate(
                        4,
                        (index) => NotificationItemModel(
                          id: 'mock_$index',
                          title: 'Class Booking Confirmed',
                          message:
                              'Your class booking for Hatha Yoga has been confirmed successfully.',
                          type: 'SUCCESS',
                          isRead: index > 1,
                          createdAt: DateTime.now().subtract(
                            Duration(hours: index + 1),
                          ),
                          actionUrl: '',
                        ),
                      )
                    : notifications;

                return Skeletonizer(
                  enabled: isLoading,
                  child: AppRefreshIndicator(
                    onRefresh: () =>
                        controller.fetchNotifications(isRefresh: true),
                    child: ListView.builder(
                      controller: controller.scrollController,
                      physics: isLoading
                          ? const NeverScrollableScrollPhysics()
                          : const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 10.h,
                      ),
                      itemCount:
                          displayList.length +
                          (!isLoading && controller.isLoadingMore.value
                              ? 1
                              : 0),
                      itemBuilder: (context, index) {
                        if (index == displayList.length) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.h),
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.buttonPrimaryColor,
                              ),
                            ),
                          );
                        }

                        final item = displayList[index];
                        return _buildNotificationItem(item, index);
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

  Widget _buildFilterChip({required String label, required bool isUnread}) {
    return Obx(() {
      final isSelected = controller.unreadOnly.value == isUnread;
      return GestureDetector(
        onTap: () => controller.toggleFilter(isUnread),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.buttonPrimaryColor
                : Colors.transparent,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: isSelected
                  ? AppColors.buttonPrimaryColor
                  : Colors.grey.shade400,
            ),
          ),
          child: Text(
            label,
            style: AppTextStyles.medium(
              14,
              color: isSelected ? Colors.white : AppColors.headlineColor,
            ),
          ),
        ),
      );
    });
  }

  Widget _buildNotificationItem(NotificationItemModel item, int index) {
    bool isUnread = !item.isRead;

    IconData getIcon(String type) {
      switch (type.toUpperCase()) {
        case 'SUCCESS':
          return Icons.check_circle_outline;
        case 'ERROR':
          return Icons.error_outline;
        case 'WARNING':
          return Icons.warning_amber_rounded;
        case 'REMINDER':
          return Icons.access_time;
        default:
          return Icons.notifications_none;
      }
    }

    Color getIconColor(String type) {
      switch (type.toUpperCase()) {
        case 'SUCCESS':
          return Colors.green;
        case 'ERROR':
          return Colors.red;
        case 'WARNING':
          return Colors.orange;
        case 'REMINDER':
          return Colors.blue;
        default:
          return AppColors.buttonPrimaryColor;
      }
    }

    String formatTimeAgo(DateTime dateTime) {
      final now = DateTime.now();
      final diff = now.difference(dateTime);

      if (diff.inDays > 7) {
        return DateFormat('dd MMM yyyy').format(dateTime);
      } else if (diff.inDays > 0) {
        return '${diff.inDays}d ago';
      } else if (diff.inHours > 0) {
        return '${diff.inHours}h ago';
      } else if (diff.inMinutes > 0) {
        return '${diff.inMinutes}m ago';
      } else {
        return 'Just now';
      }
    }

    return GestureDetector(
      onTap: () => controller.handleNotificationTap(item, index),
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: isUnread
              ? const Color(0xFF6B5345)
              : Colors.grey.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(25.r),
          border: isUnread ? null : Border.all(color: Colors.white, width: 1.r),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(12.r),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                getIcon(item.type),
                size: 24.r,
                color: getIconColor(item.type),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: AppTextStyles.bold(
                            16,
                            color: isUnread
                                ? Colors.white
                                : AppColors.headlineColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        formatTimeAgo(item.createdAt),
                        style: AppTextStyles.regular(
                          10,
                          color: isUnread ? Colors.white70 : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    item.message,
                    style: AppTextStyles.regular(
                      14,
                      color: isUnread
                          ? Colors.white.withValues(alpha: 0.8)
                          : Colors.grey.shade700,
                    ),
                  ),
                  if (item.actionUrl != null && item.actionUrl!.isNotEmpty) ...[
                    SizedBox(height: 8.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'View Details',
                          style: AppTextStyles.bold(
                            12,
                            color: isUnread
                                ? Colors.white
                                : AppColors.buttonPrimaryColor,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 10.r,
                          color: isUnread
                              ? Colors.white
                              : AppColors.buttonPrimaryColor,
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
