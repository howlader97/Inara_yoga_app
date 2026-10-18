import '../app/data/app_api_end_point.dart';
import '../app/utils/app_log.dart';
import '../models/terms_and_conditions_model.dart';
import '../services/api/api_services.dart';

class TermsAndConditonsRepository {
  ////////////// Contractures
  TermsAndConditonsRepository._privetContractures();
  static final TermsAndConditonsRepository _instance =
      TermsAndConditonsRepository._privetContractures();
  static TermsAndConditonsRepository get instance => _instance;

  /////////////// object
  final ApiServices _apiServices = ApiServices.instance;
  final AppApiEndPoint _api = AppApiEndPoint.instance;

  Future<TermsConditions?> getTermsAndConditons() async {
    try {
      var response = await _apiServices.apiGetServices(_api.termsAndConditions);
      if (response != null) {
        return TermsConditions.fromJson(response);
      }
    } catch (e) {
      errorLog("getTermsAndConditons repo", e);
    }
    return null;
  }
}
