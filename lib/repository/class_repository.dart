import '../app/data/app_api_end_point.dart';
import '../app/utils/app_log.dart';
import '../models/all_class_model.dart';
import '../services/api/api_services.dart';

class ClassRepository {
  ////////////// Contractures
  ClassRepository._privetContractures();
  static final ClassRepository _instance =
      ClassRepository._privetContractures();
  static ClassRepository get instance => _instance;

  /////////////// object
  final ApiServices _apiServices = ApiServices.instance;
  final AppApiEndPoint _api = AppApiEndPoint.instance;

  Future<AllClassModel?> getAllCourses() async {
    try {
      var response = await _apiServices.apiGetServices(_api.allCourses);
      if (response != null) {
        return AllClassModel.fromJson(response);
      }
    } catch (e) {
      errorLog("getAllClasses repo", e);
    }
    return null;
  }
}
