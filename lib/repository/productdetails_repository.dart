import '../app/data/app_api_end_point.dart';
import '../app/utils/app_log.dart';
import '../services/api/api_services.dart';

import '../models/product_details_model.dart';

class ProductDetailsRepository {
  ////////////// Contractures
  ProductDetailsRepository._privetContractures();
  static final ProductDetailsRepository _instance =
      ProductDetailsRepository._privetContractures();
  static ProductDetailsRepository get instance => _instance;

  /////////////// object
  final ApiServices _apiServices = ApiServices.instance;
  final AppApiEndPoint _api = AppApiEndPoint.instance;

  Future<ProductDetailsModel> fetchProductDetails({required String id}) async {
    try {
      var response = await _apiServices.apiGetServices(
        "${_api.storeProduct}/$id",
      );

      if (response != null) {
        return ProductDetailsModel.fromJson(response);
      } else {
        throw Exception("Product not found");
      }
    } catch (e) {
      errorLog('FetchProductDetails', e);
      rethrow;
    }
  }
}
