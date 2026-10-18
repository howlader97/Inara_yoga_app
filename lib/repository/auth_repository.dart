import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import '../app/data/app_api_end_point.dart';
import '../app/utils/app_log.dart';
import '../models/app_user_data.dart';
import '../services/api/api_services.dart';
import '../services/api/non_auth_api.dart';
import '../services/storage_services/get_storage_services.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class AuthRepository {
  ////////////// Contractures
  AuthRepository._privetContractures();
  static final AuthRepository _instance = AuthRepository._privetContractures();
  static AuthRepository get instance => _instance;

  /////////////// object
  ApiServices apiServices = ApiServices.instance;
  NonAuthApi nonAuthApi = NonAuthApi();
  AppApiEndPoint api = AppApiEndPoint.instance;
  GetStorageServices storageServices = GetStorageServices.instance;
  /////////////// function
  Future<bool> login({
    required String email,
    required String password,
    String fcmToken = "",
    String deviceId = "",
  }) async {
    try {
      Map<String, String> bodyData = {
        "username": email.trim().toLowerCase(),
        "password": password.trim(),
        // "deviceId": deviceId.trim(),
        // "fcmToken": fcmToken.trim(),
      };

      var response = await apiServices.apiPostServices(
        url: api.login,
        body: bodyData,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
      if (response != null) {
        if (response["access_token"] is String) {
          await storageServices.setToken(response["access_token"].toString());
        }

        if (response["refresh_token"] is String) {
          await storageServices.setRefreshToken(
            response["refresh_token"].toString(),
          );
        }
        return true;
      }
    } catch (e) {
      errorLog("login function repo", e);
    }
    return false;
  }

  Future<AppUserData?> getUser() async {
    try {
      var response = await apiServices.apiGetServices(api.userMe);
      if (response != null) {
        if (response is Map<String, dynamic>) {
          return AppUserData.fromJson(response);
        }
      }
    } catch (e) {
      errorLog("getUser", e);
    }
    return null;
  }

  Future<bool> accountDelete({required String password}) async {
    try {
      Map<String, String> body = {"password": password};
      var response = await apiServices.apiDeleteServices(
        url: api.userDelete,
        body: body,
      );
      if (response != null) {
        return true;
      }
    } catch (e) {
      errorLog("accountDelete AuthRepository", e);
    }
    return false;
  }

  Future<bool> updateProfile({
    required String profileImage,
    required Map<String, String> body,
  }) async {
    try {
      FormData formData = FormData.fromMap(body);
      if (profileImage.isNotEmpty) {
        final file = File(profileImage);
        if (await file.exists()) {
          String fileName = file.path.split('/').last;
          var mimeType = lookupMimeType(file.path);
          formData.files.add(
            MapEntry(
              "avatar",
              await MultipartFile.fromFile(
                file.path,
                filename: fileName,
                contentType: MediaType.parse(
                  mimeType ?? "application/octet-stream",
                ),
              ),
            ),
          );
        }
      }
      var response = await apiServices.apiPatchServices(
        url: api.userUpdate,
        body: formData,
      );
      if (response != null) {
        return true;
      }
    } catch (e) {
      errorLog("updateProfile repo", e);
    }
    return false;
  }

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      Map<String, String> body = {
        "currentPassword": currentPassword,
        "newPassword": newPassword,
        "confirmPassword": confirmPassword,
      };

      var response = await apiServices.apiPostServices(
        url: api.changePassword,
        body: body,
      );
      if (response != null) {
        return true;
      }
    } catch (e) {
      errorLog("changePassword repo", e);
    }
    return false;
  }

  Future<bool> signUp({
    required String name,
    required String email,
    required String phoneNumber,
    required String gender,
    required String password,
  }) async {
    try {
      Map<String, dynamic> bodyData = {
        "email": email,
        "password": password,
        "name": name,
        "phone": phoneNumber,
        "gender": gender,
      };

      var response = await apiServices.apiPostServices(
        url: api.signUP,
        body: jsonEncode(bodyData),
      );
      if (response != null) {
        return true;
      }
    } catch (e) {
      errorLog("signUp repo", e);
    }
    return false;
  }

  Future<bool> authResendOTP({required String email}) async {
    try {
      var response = await apiServices.apiPostServices(
        url: api.userResendOtp,
        query: {"email": email},
      );
      if (response != null) {
        return true;
      }
    } catch (e) {
      errorLog("authResendOTP", e);
    }
    return false;
  }

  Future<bool> authOtpVerify({
    required String email,
    required String otp,
  }) async {
    try {
      Map<String, dynamic> bodyData = {"email": email, "code": otp};
      var response = await apiServices.apiPostServices(
        url: api.signUpOtpVerify,
        body: bodyData,
      );
      if (response != null) {
        return true;
      }
    } catch (e) {
      errorLog("authOtpVerify", e);
    }
    return false;
  }

  ////////// forgot
  Future<bool> forgotPassword({required String email}) async {
    try {
      Map<String, String> bodyData = {"email": email};
      var response = await apiServices.apiPostServices(
        url: api.authForgotPassword,
        body: bodyData,
      );
      if (response != null) {
        return true;
      }
    } catch (e) {
      errorLog("forgotPassword repo", e);
    }
    return false;
  }

  Future<bool> forgotVerifyEmail({
    required String email,
    required String otp,
  }) async {
    try {
      Map<String, dynamic> bodyData = {"email": email, "code": otp};
      var response = await apiServices.apiPostServices(
        url: api.authVerifyEmail,
        body: bodyData,
      );
      if (response != null) {
        return true;
      }
    } catch (e) {
      errorLog("forgotPassword repo", e);
    }
    return false;
  }

  Future<bool> forgotResetPassword({
    required String email,
    required String newPassword,
  }) async {
    try {
      Map<String, dynamic> bodyData = {
        "email": email,
        "new_password": newPassword,
      };
      var response = await nonAuthApi.sendRequest.post(
        api.authResetPassword,
        data: bodyData,
      );

      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      errorLog("forgotPassword repo", e);
    }
    return false;
  }
}
