import '../app/data/app_api_end_point.dart';
import '../services/api/api_services.dart';
import '../models/change_pass_model.dart';

class ChangePasswordRepository {
  ChangePasswordRepository._privateConstructor();

  static final ChangePasswordRepository _instance =
      ChangePasswordRepository._privateConstructor();

  static ChangePasswordRepository get instance => _instance;

  final ApiServices _services = ApiServices.instance;
  final AppApiEndPoint _apiEndPoint = AppApiEndPoint.instance;

  Future<dynamic> updatePassword({
    required String currentPass,
    required String newPass,
    required String confirmPass,
  }) async {
    try {
      final body = UpdatePasswordRequest(
        currentPassword: currentPass,
        newPassword: newPass,
        confirmPassword: confirmPass,
      );

      final response = await _services.apiPatchServices(
        url: _apiEndPoint.updatePassword,
        body: body.toJson(),
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }
}
