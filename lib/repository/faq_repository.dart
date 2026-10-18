import '../app/data/app_api_end_point.dart';
import '../app/utils/app_log.dart';
import '../models/faq_model.dart';
import '../services/api/api_services.dart';

class FAQRepository {
  FAQRepository._privateConstructor();

  static final FAQRepository _instance = FAQRepository._privateConstructor();

  static FAQRepository get instance => _instance;

  final ApiServices _apiServices = ApiServices.instance;
  final AppApiEndPoint _api = AppApiEndPoint.instance;

  Future<FAQModel?> getFAQ() async {
    try {
      var response = await _apiServices.apiGetServices(_api.faq);
      if (response != null) {
        return FAQModel.fromJson(response);
      }
    } catch (e) {
      errorLog("getFAQ repo", e);
    }
    return null;
  }
}
