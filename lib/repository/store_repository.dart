import '../app/data/app_api_end_point.dart';
import '../app/utils/app_log.dart';
import '../services/api/api_services.dart';

import '../models/store_product_model.dart';

class StoreRepository {
  ////////////// Contractures
  StoreRepository._privetContractures();
  static final StoreRepository _instance =
      StoreRepository._privetContractures();
  static StoreRepository get instance => _instance;

  /////////////// object
  final ApiServices _apiServices = ApiServices.instance;
  final AppApiEndPoint _api = AppApiEndPoint.instance;

  Future<(List<StoreProductModel>, bool)> storeClasses(int page) async {
    List<StoreProductModel> listOfData = [];
    bool hasPagination = false;
    try {
      Map<String, dynamic> queryParameter = {
        'pageSize': 10,
        'page': page,
        "sortBy": "createdAt",
        "sortOrder": 'desc',
      };

      var response = await _apiServices.apiGetServices(
        _api.storeProduct,
        queryParameters: queryParameter,
      );

      if (response != null) {
        if (response['products'] is List) {
          for (var element in response['products']) {
            listOfData.add(StoreProductModel.fromJson(element));
          }
        }
        hasPagination = (int.tryParse("${response["totalPages"]}") ?? 0) > page
            ? true
            : false;
      }
    } catch (e) {
      errorLog('FetchClassesRep', e);
    }
    return (listOfData, hasPagination);
  }
}
