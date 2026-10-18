import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../models/notification_model.dart';
import '../../../../repository/notification_repository.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/app_log.dart';
import '../../custom_bottom_nav/controllers/custom_bottom_nav_controller.dart';

class NotificationsController extends GetxController {
  final NotificationRepository _repository = NotificationRepository.instance;
  late ScrollController scrollController;

  var isLoading = false.obs;
  var notificationsList = <NotificationItemModel>[].obs;

  int currentPage = 1;
  int totalPages = 1;
  var totalCount = 0.obs;
  var unreadCount = 0.obs;

  var unreadOnly = false.obs;

  final RxBool isLoadingMore = false.obs;
  bool _isLoadingMoreInternal = false;

  @override
  void onInit() {
    super.onInit();
    scrollController = ScrollController();
    scrollController.addListener(_scrollListener);
    fetchNotifications();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void _scrollListener() {
    if (_isLoadingMoreInternal || isLoadingMore.value) return;
    if (!scrollController.hasClients ||
        scrollController.positions.length != 1) {
      return;
    }
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      loadMoreNotifications();
    }
  }

  Future<void> fetchNotifications({bool isRefresh = false}) async {
    try {
      if (!isRefresh) isLoading(true);

      final result = await _repository.getNotifications(
        page: 1,
        pageSize: 20,
        unreadOnly: unreadOnly.value,
      );

      if (result != null) {
        notificationsList.clear();
        notificationsList.addAll(result.items);
        currentPage = result.page;
        totalPages = result.totalPages;
        totalCount.value = result.total;
        unreadCount.value = result.unreadCount;
      }
    } catch (e) {
      errorLog("Fetch notifications error: ", e);
    } finally {
      isLoading(false);
    }
  }

  Future<void> loadMoreNotifications() async {
    try {
      if (_isLoadingMoreInternal || isLoadingMore.value) return;
      if (currentPage >= totalPages) return;

      _isLoadingMoreInternal = true;
      isLoadingMore.value = true;

      final nextPage = currentPage + 1;
      final result = await _repository.getNotifications(
        page: nextPage,
        pageSize: 20,
        unreadOnly: unreadOnly.value,
      );

      if (result != null) {
        notificationsList.addAll(result.items);
        currentPage = result.page;
        totalPages = result.totalPages;
        totalCount.value = result.total;
        unreadCount.value = result.unreadCount;
      }
    } catch (e) {
      errorLog("Pagination error", e);
    } finally {
      isLoadingMore.value = false;
      _isLoadingMoreInternal = false;
    }
  }

  void toggleFilter(bool unread) {
    if (unreadOnly.value == unread) return;
    unreadOnly.value = unread;
    fetchNotifications();
  }

  Future<void> handleNotificationTap(
    NotificationItemModel item,
    int index,
  ) async {
    // If unread, mark as read
    if (!item.isRead) {
      // Update local state instantly for UI responsiveness
      final updatedItem = NotificationItemModel(
        id: item.id,
        title: item.title,
        message: item.message,
        type: item.type,
        actionUrl: item.actionUrl,
        isRead: true,
        readAt: DateTime.now(),
        createdAt: item.createdAt,
      );
      notificationsList[index] = updatedItem;
      if (unreadCount.value > 0) unreadCount.value--;

      // Background API call
      _repository.markAsRead([item.id]);
    }

    // Handle action URL navigation
    final url = item.actionUrl;
    if (url == null || url.isEmpty) return;

    if (url.contains('/wallet')) {
      Get.toNamed(Routes.wallet);
    } else if (url.contains('/memberships')) {
      Get.toNamed(Routes.memberships);
    } else if (url.contains('/classes')) {
      if (Get.isRegistered<CustomBottomNavController>()) {
        Get.find<CustomBottomNavController>().changeIndex(5);
      }
      Get.until(
        (route) =>
            route.name == Routes.customBottomNav ||
            route.name == Routes.home ||
            route.name == '/',
      );
    } else if (url.contains('/payments')) {
      Get.toNamed(Routes.orderHistory);
    } else {
      appLog('Action URL tapped: $url');
    }
  }
}
