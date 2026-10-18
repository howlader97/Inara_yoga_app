import '../app/data/app_api_end_point.dart';
import '../app/utils/app_log.dart';
import '../models/news_model.dart';
import '../services/api/api_services.dart';

class NewsRepository {
  //---------Private Constructor-------
  NewsRepository._privateConstructor();

  static final NewsRepository _instance = NewsRepository._privateConstructor();

  static NewsRepository get instance => _instance;

  final ApiServices _apiServices = ApiServices.instance;
  final AppApiEndPoint _apiEndPoint = AppApiEndPoint.instance;

  Future<NewsResponseModel?> getNews() async {
    try {
      var response = await _apiServices.apiGetServices(_apiEndPoint.news);

      if (response != null) {
        return NewsResponseModel.fromJson(response);
      }
    } catch (e) {
      errorLog('News error', e);
    }
    return null;
  }
}
