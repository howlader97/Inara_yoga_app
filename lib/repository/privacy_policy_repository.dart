import '../app/data/app_api_end_point.dart';
import '../app/utils/app_log.dart';
import '../models/privacy_policy_model.dart';
import '../services/api/api_services.dart';

class PrivacyPolicyRepository {
  //----Private constructor
  PrivacyPolicyRepository._privateConstructor();
  static final PrivacyPolicyRepository _instance =
      PrivacyPolicyRepository._privateConstructor();
  static PrivacyPolicyRepository get instance => _instance;

  /////////////// object
  final ApiServices _apiServices = ApiServices.instance;
  final AppApiEndPoint _api = AppApiEndPoint.instance;

  Future<PrivacyPolicy?> getPrivacyPolicy() async {
    try {
      var response = await _apiServices.apiGetServices(_api.privacyPolicy);
      if (response != null) {
        return PrivacyPolicy.fromJson(response);
      }
    } catch (e) {
      errorLog("getPrivacyPolicy repo", e);
    }
    return null;
  }
}
