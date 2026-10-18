import 'package:get/get.dart';
import '../controllers/news_controller.dart';

class NewsBinding extends BindingsInterface {
  @override
  void dependencies() {
    Get.lazyPut<NewsController>(() => NewsController());
  }
}
