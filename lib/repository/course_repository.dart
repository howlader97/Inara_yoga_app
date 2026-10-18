import '../app/data/app_api_end_point.dart';
import '../app/utils/app_log.dart';
import '../models/all_courses_model.dart';
import '../services/api/api_services.dart';

class CourseRepository {
  ////////////// Contractures
  CourseRepository._privetContractures();
  static final CourseRepository _instance =
      CourseRepository._privetContractures();
  static CourseRepository get instance => _instance;

  /////////////// object
  final ApiServices _apiServices = ApiServices.instance;
  final AppApiEndPoint _api = AppApiEndPoint.instance;

  Future<AllCoursesModel?> getAllCourses({int page = 1}) async {
    try {
      Map<String, dynamic> queryParameter = {
        'page': page,
        "sortBy": "createdAt",
        "sortOrder": 'asc',
      };
      var response = await _apiServices.apiGetServices(
        _api.allCourses,
        queryParameters: queryParameter,
      );
      if (response != null) {
        return AllCoursesModel.fromJson(response);
      }
    } catch (e) {
      errorLog("getAllCourses repo", e);
    }
    return null;
  }

  Future<Course?> getCourseDetails(String courseId) async {
    try {
      var response = await _apiServices.apiGetServices(
        _api.courseDetails(courseId),
      );
      if (response != null) {
        final courseData = response.containsKey('course')
            ? response['course']
            : response;
        return Course.fromJson(courseData);
      }
    } catch (e) {
      errorLog("getCourseDetails repo", e);
    }
    return null;
  }
}
