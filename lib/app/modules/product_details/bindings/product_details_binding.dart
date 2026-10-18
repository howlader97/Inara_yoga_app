import 'package:get/get.dart';
import '../controllers/product_details_controller.dart';

class ProductDetailsBinding extends BindingsInterface {
  @override
  void dependencies() {
    Get.lazyPut<ProductDetailsController>(() => ProductDetailsController());
  }
}
