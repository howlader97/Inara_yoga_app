import '../app/utils/app_log.dart';
import '../models/instructor_data.dart';

import '../app/data/app_api_end_point.dart';
import '../services/api/api_services.dart';

class InstructorRepository {
  ////private Constructor
  InstructorRepository._privetContractures();
  static final InstructorRepository _instance =
      InstructorRepository._privetContractures();
  static InstructorRepository get instance => _instance;

  ////Api instances
  final ApiServices _apiServices = ApiServices.instance;
  final AppApiEndPoint _api = AppApiEndPoint.instance;

  Future<InstructorModel> fetchInstructorModel({required String id}) async {
    try {
      final response = await _apiServices.apiGetServices(
        "${_api.instructors}/$id",
      );

      if (response != null) {
        return InstructorModel.fromJson(response);
      } else {
        throw Exception("Instructor data is null");
      }
    } catch (e) {
      errorLog('FetchInstructor', e);
      rethrow;
    }
  }
}
