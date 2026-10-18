import 'package:get/get.dart';

class CustomBottomNavController extends GetxController {
  final RxInt currentIndex = 5.obs; // Default to Home

  void changeIndex(int index) {
    currentIndex.value = index;
    update();
  }
}
