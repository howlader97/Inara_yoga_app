import 'dart:io';
import 'package:dio/dio.dart';
import '../app/data/app_api_end_point.dart';
import '../app/utils/app_log.dart';
import '../models/app_user_data.dart';
import '../services/api/api_services.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class EditProfileRepository {
  EditProfileRepository._privateConstructor();
  static final EditProfileRepository _instance =
      EditProfileRepository._privateConstructor();
  static EditProfileRepository get instance => _instance;

  final ApiServices _apiServices = ApiServices.instance;
  final AppApiEndPoint _apiEndPoint = AppApiEndPoint.instance;

  Future<AppUserData> updateProfile({
    required Map<String, dynamic> body,
    String? profileImage,
  }) async {
    try {
      FormData formData = FormData.fromMap(body);

      if (profileImage != null && profileImage.isNotEmpty) {
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

      final dynamic response = await _apiServices.apiPatchServices(
        url: _apiEndPoint.userUpdate,
        body: formData,
      );

      if (response != null && response is Map<String, dynamic>) {
        return AppUserData.fromJson(response);
      }
      return AppUserData.empty();
    } catch (e) {
      errorLog('Update error:', e);
      return AppUserData.empty();
    }
  }
}
