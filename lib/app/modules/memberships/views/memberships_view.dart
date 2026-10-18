import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../utils/app_size.dart';
import '../../../widgets/custom_appbar.dart';
import '../../../widgets/app_refresh_indicator.dart';
import '../../../../models/active_membership_model.dart';
import '../../../../models/membership_catalogue_model.dart';
import '../../../../models/package_model.dart';
import 'package:get/get.dart';

import '../../../data/app_colors.dart';
import '../../../data/app_text_styles.dart';
import '../../../routes/app_pages.dart';
import '../controllers/memberships_controller.dart';

class MembershipsView extends GetView<MembershipsController> {
  const MembershipsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Obx(
          () => CustomAppBar(
            title: controller.currentTab.value == 0 ? "Membership" : "Package",
          ),
        ),
      ),
      body: SafeArea(
        child: AppRefreshIndicator(
          onRefresh: () async {
            if (controller.currentTab.value == 0) {
              await Future.wait([
                controller.getMembershipCatalogue(),
                controller.getActiveMemberships(),
              ]);
            } else {
              await Future.wait([
                controller.getPackageCatalogue(),
                controller.getActivePackages(),
              ]);
            }
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTabs(),
                SizedBox(height: 24.h),
                Obx(
                  () => controller.currentTab.value == 0
                      ? _buildMembershipsContent()
                      : _buildPackagesContent(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      width: double.infinity,
      height: 50.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Obx(
        () => Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => controller.setTab(0),
                child: Container(
                  decoration: BoxDecoration(
                    color: controller.currentTab.value == 0
                        ? const Color(0xFF6D4C41)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "Membership",
                    style: AppTextStyles.bold(16).copyWith(
                      color: controller.currentTab.value == 0
                          ? Colors.white
                          : const Color(0xFF6D4C41),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => controller.setTab(1),
                child: Container(
                  decoration: BoxDecoration(
                    color: controller.currentTab.value == 1
                        ? const Color(0xFF6D4C41)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "Package",
                    style: AppTextStyles.bold(16).copyWith(
                      color: controller.currentTab.value == 1
                          ? Colors.white
                          : const Color(0xFF6D4C41),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMembershipsContent() {
    final isLoading = controller.isLoading.value;
    final isActiveLoading = controller.isActiveLoading.value;

    final membershipModel =
        (controller.membershipDataModel.value?.memberships ?? [])
            .where((m) => m.status.toUpperCase() == 'ACTIVE')
            .toList();
    final length = membershipModel.length;
    final activeMemberships =
        controller.activeMembershipsModel.value?.memberships ?? [];

    if (!isLoading &&
        length == 0 &&
        !isActiveLoading &&
        activeMemberships.isEmpty) {
      return SizedBox(
        height: Get.height * 0.75,
        width: Get.width,
        child: const Center(child: Text("No memberships available")),
      );
    }

    final displayActiveList = isActiveLoading
        ? [
            ActiveMembershipModel(
              id: 'mock_active',
              name: 'Trial Week Membership',
              description: 'Access to regular classes',
              price: 150.0,
              durationDays: 7,
              allowedClasses: const [],
              excludedClasses: const [],
              timeRestriction: null,
              autoRenew: false,
              status: 'ACTIVE',
              totalClasses: 5,
              classDetails: const [],
              excludedClassDetails: const [],
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
              userId: 'mock_user',
              progress: 0.0,
              startDate: DateTime.now(),
              endDate: DateTime.now().add(const Duration(days: 7)),
              enrolledAt: DateTime.now(),
              daysRemaining: 7,
              isExpired: false,
            ),
          ]
        : activeMemberships;

    final displayCatalogList = isLoading
        ? List.generate(
            2,
            (index) => MembershipModel(
              id: 'mock_memb_$index',
              name: 'Standard Monthly Pass',
              description: 'Unlimited access to regular classes',
              price: 970.0,
              durationDays: 30,
              allowedClasses: const [],
              excludedClasses: const [],
              timeRestriction: null,
              autoRenew: false,
              status: 'ACTIVE',
              totalClasses: 30,
              classDetails: const [],
              excludedClassDetails: const [],
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
          )
        : membershipModel;

    return Column(
      children: [
        if (isActiveLoading || activeMemberships.isNotEmpty) ...[
          Skeletonizer(
            enabled: isActiveLoading,
            child: Column(
              children: displayActiveList.map((active) {
                final expireDate =
                    "${active.endDate.year}-${active.endDate.month.toString().padLeft(2, '0')}-${active.endDate.day.toString().padLeft(2, '0')}";
                final startDateStr =
                    "${active.startDate.year}-${active.startDate.month.toString().padLeft(2, '0')}-${active.startDate.day.toString().padLeft(2, '0')}";
                final endDateStr = expireDate;
                return GestureDetector(
                  onTap: isActiveLoading
                      ? null
                      : () {
                          Get.toNamed(
                            Routes.membershipDetails,
                            arguments: {
                              'type': 'Membership',
                              'title': active.name,
                              'subtitle': active.description,
                              'validity': 'Expires on $expireDate',
                              'price': 'QAR ${active.price.round()}',
                              'startDate': startDateStr,
                              'endDate': endDateStr,
                              'isActive': true,
                              'daysRemaining': active.daysRemaining,
                              'classDetails': active.classDetails,
                              'excludedClassDetails':
                                  active.excludedClassDetails,
                              'timeRestriction': active.timeRestriction,
                              'isFromSuggestions': Get.arguments != null
                                  ? Get.arguments['isFromSuggestions']
                                  : false,
                            },
                          );
                        },
                  child: _buildActiveMembershipCard(active),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 20.h),
        ],
        Skeletonizer(
          enabled: isLoading,
          child: ListView.builder(
            itemCount: displayCatalogList.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (_, index) {
              final model = displayCatalogList[index];
              return GestureDetector(
                onTap: isLoading
                    ? null
                    : () {
                        Get.toNamed(
                          Routes.membershipDetails,
                          arguments: {
                            'type': 'Membership',
                            'title': model.name,
                            'price': 'QAR ${model.price.round()}',
                            'validity': 'Valid for ${model.durationDays} days',
                            'subtitle': model.description,
                            'membershipModel': model,
                            'classDetails': model.classDetails,
                            'excludedClassDetails': model.excludedClassDetails,
                            'timeRestriction': model.timeRestriction,
                            'isFromSuggestions': Get.arguments != null
                                ? Get.arguments['isFromSuggestions']
                                : false,
                          },
                        );
                      },
                child: _buildMembershipOptionCard(
                  type: "Membership",
                  title: model.name,
                  price: "QAR ${model.price.round()}",
                  subtitle: model.description,
                  validity: "Valid for ${model.durationDays} days",
                  isAutoRenew: controller.getAutoRenewRx(model.id),
                  model: model,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPackagesContent() {
    final isPackageLoading = controller.isPackageLoading.value;
    final isActivePackageLoading = controller.isActivePackageLoading.value;

    final packages = (controller.packageDataModel.value?.packages ?? [])
        .where((p) => p.isActive)
        .toList();
    final activePackages = controller.activePackagesModel.value?.packages ?? [];

    if (!isPackageLoading &&
        packages.isEmpty &&
        !isActivePackageLoading &&
        activePackages.isEmpty) {
      return const SizedBox(
        height: 100,
        child: Center(child: Text("No packages available")),
      );
    }

    final displayActiveList = isActivePackageLoading
        ? [
            PackageModel(
              id: 'mock_active_pkg',
              name: '1 Month Membership Pack',
              description: 'Access to regular classes',
              price: 970.0,
              durationDays: 30,
              allowedClasses: const [],
              excludedClasses: const [],
              timeRestriction: null,
              autoRenew: false,
              isActive: true,
              totalClasses: 30,
              classDetails: const [],
              excludedClassDetails: const [],
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
              numberOfSessions: 10,
              sessionsUsed: 2,
              sessionsRemaining: 8,
            ),
          ]
        : activePackages;

    final displayCatalogList = isPackageLoading
        ? List.generate(
            2,
            (index) => PackageModel(
              id: 'mock_pkg_$index',
              name: '1 Month Membership Pack',
              description: 'Access to regular classes',
              price: 970.0,
              durationDays: 30,
              allowedClasses: const [],
              excludedClasses: const [],
              timeRestriction: null,
              autoRenew: false,
              isActive: true,
              totalClasses: 30,
              classDetails: const [],
              excludedClassDetails: const [],
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
              numberOfSessions: 10,
            ),
          )
        : packages;

    return Column(
      children: [
        if (isActivePackageLoading || activePackages.isNotEmpty) ...[
          Skeletonizer(
            enabled: isActivePackageLoading,
            child: Column(
              children: displayActiveList.map((active) {
                final expireDateTime = active.createdAt.add(
                  Duration(days: active.durationDays),
                );
                final expireDate =
                    "${expireDateTime.year}-${expireDateTime.month.toString().padLeft(2, '0')}-${expireDateTime.day.toString().padLeft(2, '0')}";
                final startDateStr =
                    "${active.createdAt.year}-${active.createdAt.month.toString().padLeft(2, '0')}-${active.createdAt.day.toString().padLeft(2, '0')}";
                final endDateStr = expireDate;
                final daysRemaining = expireDateTime
                    .difference(DateTime.now())
                    .inDays;
                return GestureDetector(
                  onTap: isActivePackageLoading
                      ? null
                      : () {
                          Get.toNamed(
                            Routes.membershipDetails,
                            arguments: {
                              'type': 'Package',
                              'title': active.name,
                              'subtitle': active.description,
                              'validity': 'Expires on $expireDate',
                              'price': 'QAR ${active.price.round()}',
                              'startDate': startDateStr,
                              'endDate': endDateStr,
                              'isActive': true,
                              'daysRemaining': daysRemaining < 0
                                  ? 0
                                  : daysRemaining,
                              'classDetails': active.classDetails,
                              'excludedClassDetails':
                                  active.excludedClassDetails,
                              'membershipModel': active.toMembershipModel(),
                              'timeRestriction': active.timeRestriction,
                              'numberOfSessions': active.numberOfSessions,
                              'sessionsRemaining': active.sessionsRemaining,
                              'isFromSuggestions': Get.arguments != null
                                  ? Get.arguments['isFromSuggestions']
                                  : false,
                            },
                          );
                        },
                  child: _buildActivePackCard(active),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 20.h),
        ],
        Skeletonizer(
          enabled: isPackageLoading,
          child: ListView.builder(
            itemCount: displayCatalogList.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (_, index) {
              final package = displayCatalogList[index];
              return GestureDetector(
                onTap: isPackageLoading
                    ? null
                    : () {
                        Get.toNamed(
                          Routes.membershipDetails,
                          arguments: {
                            'type': 'Package',
                            'title': package.name,
                            'price': 'QAR ${package.price.round()}',
                            'validity':
                                'Valid for ${package.durationDays} days',
                            'subtitle': package.description,
                            'membershipModel': package.toMembershipModel(),
                            'classDetails': package.classDetails,
                            'excludedClassDetails':
                                package.excludedClassDetails,
                            'timeRestriction': package.timeRestriction,
                            'numberOfSessions': package.numberOfSessions,
                            'isFromSuggestions': Get.arguments != null
                                ? Get.arguments['isFromSuggestions']
                                : false,
                          },
                        );
                      },
                child: _buildMembershipOptionCard(
                  type: "Package",
                  title: package.name,
                  price: "QAR ${package.price.round()}",
                  subtitle: package.description,
                  validity: "Valid for ${package.durationDays} days",
                  isAutoRenew: controller.getAutoRenewRx(package.id),
                  model: package,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActivePackCard(PackageModel active) {
    final expireDateTime = active.createdAt.add(
      Duration(days: active.durationDays),
    );
    final expireDate =
        "${expireDateTime.year}-${expireDateTime.month.toString().padLeft(2, '0')}-${expireDateTime.day.toString().padLeft(2, '0')}";
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFF6D4C41),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Stack(
        children: [
          // decorative circle
          Positioned(
            right: -30,
            top: -30,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Active Package",
                  style: AppTextStyles.regular(
                    12,
                  ).copyWith(color: Colors.white.withValues(alpha: 0.8)),
                ),
                SizedBox(height: 8.h),
                Text(
                  active.name,
                  style: AppTextStyles.bold(22).copyWith(color: Colors.white),
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Expires",
                          style: AppTextStyles.regular(12).copyWith(
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                        Text(
                          expireDate,
                          style: AppTextStyles.medium(
                            14,
                          ).copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                    if (active.sessionsRemaining != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Sessions",
                            style: AppTextStyles.regular(12).copyWith(
                              color: Colors.white.withValues(alpha: 0.8),
                            ),
                          ),
                          Text(
                            "${active.sessionsRemaining} / ${active.numberOfSessions ?? 0}",
                            style: AppTextStyles.medium(
                              14,
                            ).copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveMembershipCard(ActiveMembershipModel active) {
    final expireDate =
        "${active.endDate.year}-${active.endDate.month.toString().padLeft(2, '0')}-${active.endDate.day.toString().padLeft(2, '0')}";
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        color: const Color(0xFF6D4C41),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Stack(
        children: [
          // decorative circle
          Positioned(
            right: -30,
            top: -30,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Active Membership",
                  style: AppTextStyles.regular(
                    12,
                  ).copyWith(color: Colors.white.withValues(alpha: 0.8)),
                ),
                SizedBox(height: 8.h),
                Text(
                  active.name,
                  style: AppTextStyles.bold(22).copyWith(color: Colors.white),
                ),
                SizedBox(height: 20.h),
                Text(
                  "Expires",
                  style: AppTextStyles.regular(
                    12,
                  ).copyWith(color: Colors.white.withValues(alpha: 0.8)),
                ),
                Text(
                  expireDate,
                  style: AppTextStyles.medium(14).copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMembershipOptionCard({
    required String type,
    required String title,
    required String price,
    String? subtitle,
    required String validity,
    required RxBool isAutoRenew,
    required dynamic model,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFFEBE3D9),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: const Color(0xFF6D4C41).withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  model.name,
                  style: AppTextStyles.bold(
                    18,
                  ).copyWith(color: const Color(0xFF6D4C41)),
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                'QAR ${model.price.round()}',
                style: AppTextStyles.bold(
                  18,
                ).copyWith(color: const Color(0xFF6D4C41)),
              ),
            ],
          ),
          if (subtitle != null) ...[
            SizedBox(height: 8.h),
            Text(
              model.description,
              style: AppTextStyles.regular(
                14,
              ).copyWith(color: const Color(0xFF6D4C41).withValues(alpha: 0.7)),
            ),
          ],
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        size: 18.sp,
                        color: const Color(0xFF6D4C41),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        '${model.durationDays} Day${model.durationDays == 1 ? '' : 's'} | ${model.numberOfSessions} Session${model.numberOfSessions == 1 ? '' : 's'}',
                        style: AppTextStyles.medium(
                          14,
                        ).copyWith(color: const Color(0xFF6D4C41)),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  // GestureDetector(
                  //   behavior: HitTestBehavior.opaque,
                  //   onTap: () {
                  //     isAutoRenew.value = !isAutoRenew.value;
                  //   },
                  //   child: Row(
                  //     children: [
                  //       Obx(
                  //         () => Transform.scale(
                  //           scale: 0.8,
                  //           child: Switch(
                  //             value: isAutoRenew.value,
                  //             onChanged: (val) => isAutoRenew.value = val,
                  //             activeThumbColor: const Color(0xFF6D4C41),
                  //             activeTrackColor: Colors.white,
                  //             inactiveThumbColor: Colors.white,
                  //             inactiveTrackColor: Colors.grey.withValues(
                  //               alpha: 0.3,
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //       Text(
                  //         "Auto Renew",
                  //         style: AppTextStyles.medium(
                  //           14,
                  //         ).copyWith(color: const Color(0xFF6D4C41)),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),

              ElevatedButton(
                onPressed: () => Get.toNamed(
                  Routes.checkout,
                  arguments: {
                    'itemName': title,
                    'itemPrice': price,
                    'fromMembership': type == 'Membership',
                    'fromPackage': type == 'Package',
                    'type': type.toLowerCase(),
                    'membership_plan_id': type == 'Membership'
                        ? model.id
                        : null,
                    'package_id': type == 'Package' ? model.id : null,
                    'auto_renew': isAutoRenew.value,
                    'isFromSuggestions': Get.arguments != null
                        ? Get.arguments['isFromSuggestions']
                        : false,
                  },
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6D4C41),
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 10.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  "Buy",
                  style: AppTextStyles.bold(14).copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
