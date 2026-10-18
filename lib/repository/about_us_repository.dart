import '../app/data/app_api_end_point.dart';
import '../app/utils/app_log.dart';
import '../models/about_us_model.dart';
import '../services/api/api_services.dart';

class AboutUsRepository {
  ///------Private Constructor------
  AboutUsRepository._privateConstructor();
  static final AboutUsRepository _instance =
      AboutUsRepository._privateConstructor();

  static AboutUsRepository get instance => _instance;

  final ApiServices _apiServices = ApiServices.instance;
  final AppApiEndPoint _api = AppApiEndPoint.instance;

  Future<AboutModel?> getAboutUs() async {
    try {
      var response = await _apiServices.apiGetServices(_api.about);
      if (response != null) {
        return AboutModel.fromJson(response);
      }
    } catch (e) {
      errorLog('GetAboutUs', e);
    }
    return null;
  }
}
