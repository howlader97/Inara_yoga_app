import 'package:get/get.dart';

import '../../../../services/api/api_services.dart';
import '../../../data/app_api_end_point.dart';

class MyPracticeController extends GetxController {
  final selectedTab = 0.obs;
  final isLoading = false.obs;
  final attendanceData = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAttendanceStats();
  }

  void changeTab(int index) {
    selectedTab.value = index;
    fetchAttendanceStats();
  }

  String get periodString {
    if (selectedTab.value == 0) return 'month';
    if (selectedTab.value == 1) return 'year';
    return 'all';
  }

  Future<void> fetchAttendanceStats() async {
    isLoading.value = true;
    final url = AppApiEndPoint.instance.attendanceStats;
    final response = await ApiServices.instance.apiGetServices(
      url,
      queryParameters: {'period': periodString},
    );
    if (response != null) {
      attendanceData.value = response;
    }
    isLoading.value = false;
  }

  Map<String, dynamic> get currentData {
    if (attendanceData.isEmpty) {
      return {
        'classes': 0,
        'hoursOnMat': '0h 0m',
        'mostPractised': '-',
        'mostOftenWith': '-',
        'weeklyAverage': '0 classes',
        'memberSince': '-',
      };
    }
    
    final dateStr = attendanceData['member_since'];
    String formattedDate = '-';
    if (dateStr != null) {
      try {
        final date = DateTime.parse(dateStr);
        final monthNames = [
          'January', 'February', 'March', 'April', 'May', 'June',
          'July', 'August', 'September', 'October', 'November', 'December'
        ];
        formattedDate = '${monthNames[date.month - 1]} ${date.year}';
      } catch (_) {}
    }

    return {
      'classes': attendanceData['total_classes'] ?? 0,
      'hoursOnMat': attendanceData['hours_on_the_mat'] ?? '0h 0m',
      'mostPractised': attendanceData['most_practiced'] ?? '-',
      'mostOftenWith': attendanceData['most_often_with'] ?? '-',
      'weeklyAverage': '${attendanceData['weekly_average'] ?? 0} classes',
      'memberSince': formattedDate,
    };
  }

  List<int> get chartTrendData {
    if (attendanceData.isEmpty) {
      return [0, 0];
    }
    
    if (selectedTab.value == 0) {
      // This Month
      int classes = (attendanceData['total_classes'] as num?)?.toInt() ?? 0;
      return [classes, classes]; // Flat line for a single month
    } else if (selectedTab.value == 1) {
      // This Year
      List<int> yearData = List.filled(12, 0);
      final trendList = attendanceData['monthly_trend'] as List<dynamic>? ?? [];
      final monthNames = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'];
      for (var item in trendList) {
        String month = (item['month'] as String).toUpperCase();
        int count = (item['class_count'] as num?)?.toInt() ?? 0;
        int idx = monthNames.indexOf(month);
        if (idx != -1) {
          yearData[idx] = count;
        }
      }
      return yearData;
    } else {
      // All Time
      int classes = (attendanceData['total_classes'] as num?)?.toInt() ?? 0;
      int yearsCount = xAxisLabels.length;
      if (yearsCount <= 1) return [0, classes];
      
      List<int> allTimeData = [];
      // Create a dummy upward trend for all time
      for (int i = 0; i < yearsCount; i++) {
        allTimeData.add((classes / yearsCount * (i + 1)).toInt());
      }
      return allTimeData;
    }
  }

  String get trendYear {
    if (attendanceData.isEmpty || attendanceData['monthly_trend'] == null) {
      return DateTime.now().year.toString();
    }
    final trendList = attendanceData['monthly_trend'] as List<dynamic>;
    if (trendList.isNotEmpty) {
      return (trendList.last['year'] as int?)?.toString() ?? DateTime.now().year.toString();
    }
    return DateTime.now().year.toString();
  }

  List<String> get xAxisLabels {
    if (selectedTab.value == 0) {
      // This month
      final now = DateTime.now();
      final monthNames = [
        'January', 'February', 'March', 'April', 'May', 'June',
        'July', 'August', 'September', 'October', 'November', 'December'
      ];
      return [monthNames[now.month - 1]];
    } else if (selectedTab.value == 1) {
      // This Year
      return ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    } else {
      // All Time
      final memberSinceString = currentData['memberSince'] as String;
      final parts = memberSinceString.split(' ');
      int startYear = DateTime.now().year;
      if (parts.length == 2) {
        startYear = int.tryParse(parts[1]) ?? startYear;
      }
      final currentYear = DateTime.now().year;
      
      List<String> years = [];
      for (int i = startYear; i <= currentYear; i++) {
        years.add(i.toString());
      }
      if (years.isEmpty) {
        years.add(currentYear.toString());
      }
      return years;
    }
  }
}
