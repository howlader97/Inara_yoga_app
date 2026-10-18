import '../app/data/app_api_end_point.dart';
import '../app/utils/app_log.dart';
import '../models/membership_catalogue_model.dart';
import '../models/active_membership_model.dart';
import '../models/package_model.dart';
import '../services/api/api_services.dart';

class MembershipCatalogueRepository {
  MembershipCatalogueRepository._privateConstructor();

  static final MembershipCatalogueRepository _instance =
      MembershipCatalogueRepository._privateConstructor();

  static MembershipCatalogueRepository get instance => _instance;

  final ApiServices _apiServices = ApiServices.instance;
  final AppApiEndPoint _apiEndPoint = AppApiEndPoint.instance;

  Future<MembershipResponseModel?> getMembershipCatalogue() async {
    try {
      var reponse = await _apiServices.apiGetServices(
        _apiEndPoint.membershipCatalogue,
      );
      if (reponse != null) {
        return MembershipResponseModel.fromJson(reponse);
      }
    } catch (e) {
      errorLog("Membership Catalogue", e);
    }
    return null;
  }

  Future<ActiveMembershipResponseModel?> getActiveMemberships() async {
    try {
      var response = await _apiServices.apiGetServices(
        _apiEndPoint.activeMembership,
        queryParameters: {'page': 1, 'pageSize': 10},
      );
      if (response != null) {
        return ActiveMembershipResponseModel.fromJson(response);
      }
    } catch (e) {
      errorLog("Active Memberships", e);
    }
    return null;
  }

  Future<PackageResponseModel?> getPackageCatalogue() async {
    try {
      var response = await _apiServices.apiGetServices(
        _apiEndPoint.packageCatalogue,
        queryParameters: {
          'page': 1,
          'pageSize': 10,
          'sortBy': 'order',
          'sortOrder': 'asc',
        },
      );
      if (response != null) {
        return PackageResponseModel.fromJson(response);
      }
    } catch (e) {
      errorLog("Package Catalogue", e);
    }
    return null;
  }

  Future<PackageResponseModel?> getActivePackages() async {
    try {
      var response = await _apiServices.apiGetServices(
        _apiEndPoint.activePackage,
        queryParameters: {
          'page': 1,
          'pageSize': 10,
          'sortBy': 'order',
          'sortOrder': 'asc',
        },
      );
      if (response != null) {
        return PackageResponseModel.fromJson(response);
      }
    } catch (e) {
      errorLog("Active Packages", e);
    }
    return null;
  }
}
