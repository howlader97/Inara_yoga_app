import '../app/data/app_api_end_point.dart';
import '../app/utils/app_log.dart';
import '../services/api/api_services.dart';

class OrderRepository {
  OrderRepository._privateConstructor();

  static final OrderRepository _instance =
      OrderRepository._privateConstructor();

  static OrderRepository get instance => _instance;

  final ApiServices _apiServices = ApiServices.instance;
  final AppApiEndPoint _apiEndPoint = AppApiEndPoint.instance;

  Future<Map<String, dynamic>?> getOrderHistory({
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await _apiServices.apiGetServices(
        "${_apiEndPoint.orderHistory}?page=$page&page_size=$pageSize",
      );

      if (response != null && response is Map<String, dynamic>) {
        return response;
      }
    } catch (e) {
      errorLog('OrderHistory error', e);
    }
    return null;
  }
}
