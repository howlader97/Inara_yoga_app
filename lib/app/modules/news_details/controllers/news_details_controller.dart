import '../../../../models/news_model.dart';
import 'package:get/get.dart';

class NewsDetailsController extends GetxController {
  final NewsModel item = Get.arguments;
  var isExpanded = false.obs;

  void toggleExpanded() {
    isExpanded.value = !isExpanded.value;
  }

  void bookNow() {
    Get.toNamed('/checkout');
  }
}
