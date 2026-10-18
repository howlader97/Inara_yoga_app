import 'package:george/models/package_model.dart';

import '../../../../models/membership_catalogue_model.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../memberships/controllers/memberships_controller.dart';

class MembershipDetailsController extends GetxController {
  final RxString type = "".obs;

  final RxString title = "".obs;
  final RxString subtitle = "".obs;
  final RxString validity = "".obs;
  final RxString timeRestriction = "".obs;

  final RxString startDate = "".obs;
  final RxString endDate = "".obs;

  final RxString price = "".obs;
  final RxString walletBalance = "".obs;
  final RxBool isFromSuggestions = false.obs;
  final Rx<MembershipModel?> membershipModel = Rx<MembershipModel?>(null);

  final RxBool isActive = false.obs;
  final RxInt daysRemaining = 0.obs;
  final RxList<ClassInfoModel> classDetails = <ClassInfoModel>[].obs;
  final RxList<ClassInfoModel> excludedClassDetails = <ClassInfoModel>[].obs;
  final RxBool autoRenew = false.obs;
  final RxnInt numberOfSessions = RxnInt();
  final RxnInt sessionsRemaining = RxnInt();

  @override
  void onInit() {
    super.onInit();
    _loadArguments();
  }

  void _loadArguments() {
    final Map<String, dynamic>? args = Get.arguments;
    if (args == null) return;

    type.value = _getValue(args, 'type', type.value);
    title.value = _getValue(args, 'title', title.value);
    subtitle.value = _getValue(args, 'subtitle', subtitle.value);
    validity.value = _getValue(args, 'validity', validity.value);
    timeRestriction.value = _getValue(
      args,
      'timeRestriction',
      timeRestriction.value,
    );
    price.value = _getValue(args, 'price', price.value);
    startDate.value = _getValue(args, 'startDate', startDate.value);
    endDate.value = _getValue(args, 'endDate', endDate.value);
    walletBalance.value = _getValue(args, 'walletBalance', walletBalance.value);
    isFromSuggestions.value = args['isFromSuggestions'] ?? false;
    membershipModel.value = args['membershipModel'] as MembershipModel?;
    isActive.value = args['isActive'] ?? false;
    daysRemaining.value = args['daysRemaining'] ?? 0;
    numberOfSessions.value = args['numberOfSessions'];
    sessionsRemaining.value = args['sessionsRemaining'];
    if (args['classDetails'] != null) {
      classDetails.assignAll(List<ClassInfoModel>.from(args['classDetails']));
    }
    if (args['excludedClassDetails'] != null) {
      excludedClassDetails.assignAll(
        List<ClassInfoModel>.from(args['excludedClassDetails']),
      );
    }
  }

  String _getValue(Map<String, dynamic> args, String key, String defaultValue) {
    final value = args[key];
    if (value != null && value.toString().isNotEmpty) {
      return value.toString();
    }
    return defaultValue;
  }

  void refreshData(String newId) {
    if (newId.isEmpty) return;

    final membershipsCtrl = Get.isRegistered<MembershipsController>()
        ? Get.find<MembershipsController>()
        : Get.put(MembershipsController());

    if (type.value == 'Membership') {
      final list = membershipsCtrl.membershipDataModel.value?.memberships ?? [];
      final match = list.firstWhereOrNull((m) => m.id == newId);
      if (match != null) {
        membershipModel.value = match;
        title.value = match.name;
        price.value = 'QAR ${match.price.round()}';
        validity.value = 'Valid for ${match.durationDays} days';
        subtitle.value = match.description;
        classDetails.assignAll(match.classDetails);
        excludedClassDetails.assignAll(match.excludedClassDetails);
        timeRestriction.value = match.timeRestriction ?? "";
        numberOfSessions.value = match.numberOfSessions;
        sessionsRemaining.value = match.sessionsRemaining;
      }
    } else if (type.value == 'Package') {
      final list = membershipsCtrl.packageDataModel.value?.packages ?? [];
      final match = list.firstWhereOrNull((p) => p.id == newId);
      if (match != null) {
        final converted = match.toMembershipModel();
        membershipModel.value = converted;
        title.value = match.name;
        price.value = 'QAR ${match.price.round()}';
        validity.value = 'Valid for ${match.durationDays} days';
        subtitle.value = match.description;
        classDetails.assignAll(match.classDetails);
        excludedClassDetails.assignAll(match.excludedClassDetails);
        timeRestriction.value = match.timeRestriction ?? "";
        numberOfSessions.value = match.numberOfSessions;
        sessionsRemaining.value = match.sessionsRemaining;
      }
    }
  }

  Future<void> proceedToPayment() async {
    final result = await Get.toNamed(
      Routes.checkout,
      arguments: {
        'itemName': title.value,
        'itemPrice': price.value,
        'fromMembership': type.value == 'Membership',
        'fromPackage': type.value == 'Package',
        'type': type.value,
        'membership_plan_id': type.value == 'Membership'
            ? membershipModel.value?.id
            : null,
        'package_id': type.value == 'Package'
            ? membershipModel.value?.id
            : null,
        'auto_renew': autoRenew.value,
      },
    );
    if (result != null && result is String) {
      refreshData(result);
    }
  }
}
