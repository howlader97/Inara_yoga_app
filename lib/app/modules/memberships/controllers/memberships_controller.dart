import 'package:flutter/cupertino.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/app_log.dart';
import '../../../../models/membership_catalogue_model.dart';
import '../../../../models/active_membership_model.dart';
import '../../../../models/package_model.dart';
import '../../../../repository/membership_catalogue_repository.dart';
import 'package:get/get.dart';

class MembershipsController extends GetxController {
  final currentTab = 0.obs; // 0 for Membership, 1 for Package
  final RxMap<String, RxBool> autoRenewMap = <String, RxBool>{}.obs;

  RxBool getAutoRenewRx(String id) {
    if (!autoRenewMap.containsKey(id)) {
      autoRenewMap[id] = false.obs;
    }
    return autoRenewMap[id]!;
  }

  final RxBool isLoading = false.obs;
  final RxBool isActiveLoading = false.obs;
  final RxBool isPackageLoading = false.obs;
  final RxBool isActivePackageLoading = false.obs;

  Rxn<MembershipResponseModel> membershipDataModel =
      Rxn<MembershipResponseModel>();
  Rxn<ActiveMembershipResponseModel> activeMembershipsModel =
      Rxn<ActiveMembershipResponseModel>();
  Rxn<PackageResponseModel> packageDataModel = Rxn<PackageResponseModel>();
  Rxn<PackageResponseModel> activePackagesModel = Rxn<PackageResponseModel>();

  final MembershipCatalogueRepository _catalogueRepository =
      MembershipCatalogueRepository.instance;

  void setTab(int index) {
    currentTab.value = index;
  }

  Future<void> getMembershipCatalogue() async {
    try {
      isLoading.value = true;

      membershipDataModel.value = await _catalogueRepository
          .getMembershipCatalogue();
    } catch (e) {
      errorLog('MembershipCatalogue', e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getActiveMemberships() async {
    try {
      isActiveLoading.value = true;
      activeMembershipsModel.value = await _catalogueRepository
          .getActiveMemberships();
    } catch (e) {
      errorLog('ActiveMemberships', e);
    } finally {
      isActiveLoading.value = false;
    }
  }

  Future<void> getPackageCatalogue() async {
    try {
      isPackageLoading.value = true;
      packageDataModel.value = await _catalogueRepository.getPackageCatalogue();
    } catch (e) {
      errorLog('PackageCatalogue', e);
    } finally {
      isPackageLoading.value = false;
    }
  }

  Future<void> getActivePackages() async {
    try {
      isActivePackageLoading.value = true;
      activePackagesModel.value = await _catalogueRepository
          .getActivePackages();
    } catch (e) {
      errorLog('ActivePackages', e);
    } finally {
      isActivePackageLoading.value = false;
    }
  }

  void onInitialize() {
    try {
      getMembershipCatalogue();
      getActiveMemberships();
      getPackageCatalogue();
      getActivePackages();
    } catch (e) {
      errorLog('Membership error', e);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.toNamed(Routes.errorScreen);
      });
    }
  }

  @override
  void onInit() {
    if (Get.arguments != null && Get.arguments is Map) {
      final tab = Get.arguments['tab'];
      if (tab is int) {
        currentTab.value = tab;
      } else if (tab is String) {
        currentTab.value = int.tryParse(tab) ?? 0;
      }
    }
    onInitialize();
    super.onInit();
  }
}
