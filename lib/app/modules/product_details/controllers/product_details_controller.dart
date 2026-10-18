import '../../../../models/product_details_model.dart';
import '../../../../repository/productdetails_repository.dart';
import 'package:get/get.dart';
import '../../../utils/app_log.dart';
import '../../../widgets/snack_bar/app_snack_bar.dart';

class ProductDetailsController extends GetxController {
  RxString productId = ''.obs;

  RxBool isLoading = false.obs;

  final ProductDetailsRepository _productDetailsRepository =
      ProductDetailsRepository.instance;

  Rxn<ProductDetailsModel> productDetails = Rxn<ProductDetailsModel>();

  void increment() {
    try {
      var product = productDetails.value;
      if (product == null) return;
      var quantity = product.quantity;
      var stockQuantity = product.stockQuantity;
      if ((quantity + 1) < stockQuantity) {
        quantity = quantity + 1;
        var totalPrice = product.price * quantity;
        productDetails.value = product.copyWith(
          quantity: quantity,
          totalPrice: totalPrice,
        );
      } else {
        AppSnackBar.error("Insufficient Quantity: Need to order less.");
      }
    } catch (e) {
      errorLog("Error is", e);
    }
  }

  void decrement() {
    try {
      var product = productDetails.value;
      if (product == null) return;
      var currentQuantity = product.quantity;
      if (currentQuantity > 1) {
        var newQuantity = currentQuantity - 1;
        var totalPrice = product.price * newQuantity;
        productDetails.value = product.copyWith(
          quantity: newQuantity,
          totalPrice: totalPrice,
        );
      } else {
        AppSnackBar.error("Minimum Quantity: Quantity cannot be less than 1");
      }
    } catch (e) {
      errorLog("Error is", e);
    }
  }

  void refreshData(String newId) {
    if (newId.isNotEmpty && newId != productId.value) {
      productId.value = newId;
      fetchProductDetails(newId);
    }
  }

  @override
  void onInit() {
    super.onInit();
    productId.value = Get.arguments;
    fetchProductDetails(productId.value);
  }

  Future<void> fetchProductDetails(String id) async {
    try {
      isLoading.value = true;
      final result = await _productDetailsRepository.fetchProductDetails(
        id: id,
      );
      productDetails.value = result;
    } catch (e) {
      errorLog("ProductDetailsController", e);
    } finally {
      isLoading.value = false;
    }
  }
}
