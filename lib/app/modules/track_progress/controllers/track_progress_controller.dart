import 'package:get/get.dart';

class TrackProgressController extends GetxController {
  final attendanceData = <Map<String, dynamic>>[].obs;
  void generateAttendanceData() {
    final months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];
    attendanceData.value = List.generate(12, (index) {
      return {
        "month": months[index],
        "total": 20,
        "attended": (index % 5) + 10,
        "classes_label": "${(index % 5) + 15} classes",
      };
    });
  }

  @override
  void onInit() {
    super.onInit();
    generateAttendanceData(); // Call this when controller initializes
  }
}
