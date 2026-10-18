import '../app/data/app_api_end_point.dart';
import '../app/utils/app_log.dart';
import '../models/notification_model.dart';
import '../services/api/api_services.dart';

class NotificationRepository {
  NotificationRepository._privateConstructor();
  static final NotificationRepository _instance =
      NotificationRepository._privateConstructor();
  static NotificationRepository get instance => _instance;

  final ApiServices _apiServices = ApiServices.instance;
  final AppApiEndPoint _apiEndPoint = AppApiEndPoint.instance;

  Future<NotificationResponseModel?> getNotifications({
    int page = 1,
    int pageSize = 20,
    bool unreadOnly = false,
  }) async {
    try {
      Map<String, dynamic> queryParameters = {
        'page': page,
        'page_size': pageSize,
        'unread_only': unreadOnly,
      };

      var response = await _apiServices.apiGetServices(
        _apiEndPoint.notifications,
        queryParameters: queryParameters,
      );

      if (response != null) {
        return NotificationResponseModel.fromJson(response);
      }
    } catch (e) {
      errorLog('getNotifications repo', e);
    }
    return null;
  }

  Future<bool> markAsRead(List<String> ids) async {
    try {
      var response = await _apiServices.apiPatchServices(
        url: _apiEndPoint.markRead,
        body: {'notificationIds': ids},
      );
      return response != null;
    } catch (e) {
      errorLog('markAsRead repo', e);
      return false;
    }
  }

  Future<String?> updateAppNotificationSetting(bool enabled) async {
    try {
      var response = await _apiServices.apiPatchServices(
        url: "${_apiEndPoint.toggleAppNotification}?enabled=$enabled",
      );
      if (response != null && response is Map<String, dynamic>) {
        return response['message']?.toString() ??
            'Setting updated successfully.';
      }
    } catch (e) {
      errorLog('updateAppNotificationSetting repo', e);
    }
    return null;
  }

  Future<String?> updateWhatsappNotificationSetting(bool enabled) async {
    try {
      var response = await _apiServices.apiPatchServices(
        url: "${_apiEndPoint.toggleWhatsappNotification}?enabled=$enabled",
      );
      if (response != null && response is Map<String, dynamic>) {
        return response['message']?.toString() ??
            'Setting updated successfully.';
      }
    } catch (e) {
      errorLog('updateWhatsappNotificationSetting repo', e);
    }
    return null;
  }
}
