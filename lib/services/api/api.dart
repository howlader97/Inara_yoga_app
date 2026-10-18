import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../app/data/app_api_end_point.dart';
import '../../app/routes/app_pages.dart';
import '../../app/utils/app_log.dart';
import 'non_auth_api.dart';
import '../storage_services/get_storage_services.dart';
import 'package:get/get.dart';

import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class AppApi {
  final Dio _dio = Dio();
  AppApi._privateConstructor();
  static final AppApi _instance = AppApi._privateConstructor();
  static AppApi get instance => _instance;
  var storageServices = GetStorageServices.instance;
  AppApi() {
    _dio.options.baseUrl = AppApiEndPoint.instance.baseUrl;
    _dio.options.sendTimeout = const Duration(seconds: 120);
    _dio.options.connectTimeout = const Duration(seconds: 120);
    _dio.options.receiveTimeout = const Duration(seconds: 120);
    _dio.options.followRedirects = false;

    _dio.interceptors.addAll({
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          options.baseUrl = AppApiEndPoint.instance.baseUrl;
          options.headers["Accept"] = "application/json";

          String token = GetStorageServices.instance.getToken();

          if (token.isNotEmpty &&
              !options.path.contains("/auth/login") &&
              !options.path.contains("/auth/refresh")) {
            options.headers["Authorization"] = "Bearer $token";
          }

          options.contentType ??= Headers.jsonContentType;

          return handler.next(options);
        },
        onError: (error, handler) async {
          appLog("""

API error occurred:

Status code: ${error.response?.statusCode}

Error message: ${error.message}

""");

          if (error.response?.statusCode == 401 &&
              !error.requestOptions.path.contains("/auth/refresh")) {
            try {
              String newToken = await _refreshNewAccessToken();

              if (newToken.isNotEmpty) {
                /// update token
                error.requestOptions.headers["Authorization"] =
                    "Bearer $newToken";

                /// retry failed request
                final response = await _dio.fetch(error.requestOptions);

                return handler.resolve(response);
              } else {
                await GetStorageServices.instance.logout();
                Get.offAllNamed(Routes.logIn);
              }
            } catch (e) {
              errorLog("Refresh token error", e);
            }
          }

          return handler.next(error); // Continue with error
        },
      ),
      if (kDebugMode)
        PrettyDioLogger(
          requestHeader: true,
          request: true,
          compact: true,
          error: true,
          requestBody: true,
          responseHeader: true,
          responseBody: true,
        ),
    });
  }
  Dio get sendRequest => _dio;
}

// // Token refresh logic
// Future<String> _reFreshNewAccessToken() async {
//   try {
//     var refreshToken = GetStorageServices.instance.getRefreshToken();
//     final response = await NonAuthApi().sendRequest.post(
//       AppApiEndPoint.instance.refreshToken,
//       data: {"refresh_token": refreshToken},
//     );
//     if (response.statusCode == 200) {
//       if (response.data["access_token"] is String) {
//         await GetStorageServices.instance.setToken(
//           response.data["access_token"],
//         );
//         await GetStorageServices.instance.setRefreshToken(
//           response.data["refresh_token"],
//         );
//         return response.data["access_token"].toString();
//       }
//     } else {
//       await GetStorageServices.instance.logout();
//     }
//   } catch (e) {
//     errorLog("reFreshNewAccessToken", e);
//   }
//   return "";
// }

Future<String> _refreshNewAccessToken() async {
  try {
    var storage = GetStorageServices.instance;
    var refreshToken = storage.getRefreshToken();

    if (refreshToken.isEmpty) {
      return "";
    }

    final response = await NonAuthApi().sendRequest.post(
      AppApiEndPoint.instance.refreshToken,
      data: {"refresh_token": refreshToken},
    );

    if (response.statusCode == 200) {
      String accessToken = response.data["access_token"];
      String newRefreshToken = response.data["refresh_token"];

      await storage.setToken(accessToken);
      await storage.setRefreshToken(newRefreshToken);

      return accessToken;
    }
  } catch (e) {
    errorLog("refresh token error", e);
  }

  return "";
}
