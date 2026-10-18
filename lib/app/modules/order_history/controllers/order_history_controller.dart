import 'package:get/get.dart';
import '../../../../repository/order_repository.dart';
import '../../../../app/utils/app_log.dart';

class OrderHistoryController extends GetxController {
  final orderHistory = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrderHistory();
  }

  Future<void> fetchOrderHistory({bool isRefresh = false}) async {
    if (!isRefresh) isLoading(true);
    try {
      final response = await OrderRepository.instance.getOrderHistory();
      if (response != null) {
        final List<dynamic> items = response['items'] ?? [];
        final List<Map<String, dynamic>> formattedList = items.map((item) {
          final List<dynamic> orderItems = item['items'] ?? [];
          final String productNames = orderItems
              .map((oi) => oi['product_name'] ?? '')
              .join(', ');
          final String firstImage = orderItems.isNotEmpty
              ? (orderItems.first['product_image'] ?? '')
              : '';
          final double total = (item['total'] as num?)?.toDouble() ?? 0.0;
          final String currency = item['currency'] ?? 'QAR';

          // Format date: e.g. "2026-06-07T08:54:14.861000+00:00" -> "07 Jun 2026"
          String formattedDate = '';
          try {
            final createdAtStr = item['created_at'] ?? '';
            if (createdAtStr.isNotEmpty) {
              final dateTime = DateTime.parse(createdAtStr);
              final months = [
                'Jan',
                'Feb',
                'Mar',
                'Apr',
                'May',
                'Jun',
                'Jul',
                'Aug',
                'Sep',
                'Oct',
                'Nov',
                'Dec',
              ];
              formattedDate =
                  "${dateTime.day} ${months[dateTime.month - 1]} ${dateTime.year}";
            }
          } catch (e) {
            formattedDate = item['created_at'] ?? '';
          }

          String status = item['status'] ?? 'PENDING';
          if (status.isNotEmpty) {
            status =
                status[0].toUpperCase() + status.substring(1).toLowerCase();
          }

          return {
            'orderId': '#${item['order_number'] ?? ''}',
            'date': formattedDate,
            'amount': '$currency ${total.toStringAsFixed(2)}',
            'status': status,
            'items': productNames,
            'image': firstImage,
          };
        }).toList();

        orderHistory.assignAll(formattedList);
      }
    } catch (e) {
      errorLog('fetchOrderHistory controller error', e);
    } finally {
      isLoading(false);
    }
  }
}
