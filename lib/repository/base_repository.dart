import '../app/data/app_api_end_point.dart';
import '../app/utils/app_log.dart';
import '../services/api/api_services.dart';

class BaseRepository {
  /////////////// constructor
  BaseRepository._privateConstructor();
  static final BaseRepository _instance = BaseRepository._privateConstructor();
  static BaseRepository get instance => _instance;

  /////////////// object
  final ApiServices _apiServices = ApiServices.instance;
  final AppApiEndPoint _api = AppApiEndPoint.instance;

  //////////////// function
  Future<String> termsAndConditions() async {
    try {
      var response = await _apiServices.apiGetServices(_api.termsAndConditions);
      if (response != null) {
        if (response["data"] != null && response["data"] is Map) {
          var data = response["data"];
          if (data["content"] != null && data["content"] is String) {
            return data["content"].toString()
              ..replaceAll('white-space:pre-wrap;', '')
                  .replaceAll('\u00A0', ' ')
                  .replaceAll(RegExp(r'\s+'), ' ')
                  .trim();
          }
        }
      }
    } catch (e) {
      errorLog("termsAndConditions repo", e);
    }
    return "";
  }

  Future<String> aboutUs() async {
    try {
      var response = await _apiServices.apiGetServices(_api.about);
      if (response != null) {
        if (response["data"] != null && response["data"] is Map) {
          var data = response["data"];
          if (data["content"] != null && data["content"] is String) {
            return data["content"].toString()
              ..replaceAll('white-space:pre-wrap;', '')
                  .replaceAll('\u00A0', ' ')
                  .replaceAll(RegExp(r'\s+'), ' ')
                  .trim();
          }
        }
      }
    } catch (e) {
      errorLog("aboutUs repo", e);
    }
    return "";
  }

  Future<String> privacyPolicy() async {
    try {
      var response = await _apiServices.apiGetServices(_api.privacyPolicy);
      if (response != null) {
        if (response["data"] != null && response["data"] is Map) {
          var data = response["data"];
          if (data["content"] != null && data["content"] is String) {
            return data["content"].toString()
              ..replaceAll('white-space:pre-wrap;', '')
                  .replaceAll('\u00A0', ' ')
                  .replaceAll(RegExp(r'\s+'), ' ')
                  .trim();
          }
        }
      }
    } catch (e) {
      errorLog("privacyPolicy repo", e);
    }
    return "";
  }

  // Future<List<FAQScreenDataModel>> getAllFaq() async {
  //   List<FAQScreenDataModel> listOfFaqData = [];
  //   try {
  //     var response = await _apiServices.getServices(_api.faq);
  //     if (response != null) {
  //       if (response["data"] is List) {
  //         for (var element in response["data"]) {
  //           listOfFaqData.add(FAQScreenDataModel.fromJson(element));
  //         }
  //       }
  //     }
  //   } catch (e) {
  //     errorLog("getAllFaq", e);
  //   }
  //   return listOfFaqData;
  // }
}
