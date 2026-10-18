import '../app/data/app_api_end_point.dart';
import '../app/utils/app_log.dart';
import '../models/class_data.dart';
import '../services/api/api_services.dart';

class HomeRepository {
  ////////////// Contractures
  HomeRepository._privetContractures();
  static final HomeRepository _instance = HomeRepository._privetContractures();
  static HomeRepository get instance => _instance;

  /////////////// object
  final ApiServices _apiServices = ApiServices.instance;
  final AppApiEndPoint _api = AppApiEndPoint.instance;

  Future<ClassesResponse?> fetchClasses({
    required String date,
    String instructor = '',
    String gender = '',
    String difficulty = '',
    String className = '',
    int page = 1,
  }) async {
    try {
      Map<String, dynamic> queryParameter = {
        'scheduledAt': date,
        'page': page,
        "sortBy": "scheduledAt",
        "sortOrder": 'asc',
      };

      if (instructor.isNotEmpty) {
        queryParameter['search'] = instructor;
      }
      if (gender.isNotEmpty) {
        queryParameter['gender'] = gender;
      }
      if (difficulty.isNotEmpty) {
        queryParameter['difficulty'] = difficulty;
      }
      if (className.isNotEmpty) {
        queryParameter['search'] = className;
      }

      final response = await _apiServices.apiGetServices(
        _api.allClasses,
        queryParameters: queryParameter,
      );

      if (response != null) {
        return ClassesResponse.fromJson(response);
      } else {
        throw Exception("Response is null");
      }
    } catch (e) {
      errorLog('FetchClassesRep', e);
      rethrow;
    }
  }

  Future<ClassModel> fetchClassById({required String id}) async {
    try {
      var response = await _apiServices.apiGetServices('${_api.allClasses}$id');
      if (response != null) {
        return ClassModel.fromJson(response);
      } else {
        throw Exception("Instructor data is null");
      }
    } catch (e) {
      errorLog('FetchClassesRep', e);
      rethrow;
    }
  }
}
