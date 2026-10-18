import 'package:flutter/material.dart';
import '../../custom_bottom_nav/controllers/custom_bottom_nav_controller.dart';
import '../../../utils/app_size.dart';
import '../../../widgets/app_image/app_image.dart';
import 'package:get/get.dart';
import '../../../data/app_colors.dart';
import '../../../data/app_text_styles.dart';
import '../../../routes/app_pages.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              SizedBox(height: 24.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: _buildMenuSection(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.cardBackgroundColor,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30.r)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6D4C41).withValues(alpha: 0.12),
            offset: const Offset(0, 8),
            blurRadius: 16,
          ),
        ],
      ),
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        top: 16.h,
        bottom: 24.h,
      ),
      child: Row(
        children: [
          // Avatar
          GestureDetector(
            // onTap: controller.pickImage,
            child: Stack(
              children: [
                Obx(() {
                  final imagePath = controller.profileImage.value;

                  return Container(
                    width: 70.r,
                    height: 70.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: ClipOval(
                      child: imagePath.isNotEmpty
                          ? AppImage(filePath: imagePath, fit: BoxFit.cover)
                          : AppImage(
                              url: controller.userData.value?.avatar ?? "",
                              path:
                                  "assets/images/network_placeholder_image.jpg",
                              fit: BoxFit.cover,
                            ),
                    ),
                  );
                }),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: EdgeInsets.all(4.r),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.camera_alt,
                      size: 14.r,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 15.w),
          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Obx(
                      () => Text(
                        controller.userData.value?.name ?? "",
                        style: AppTextStyles.bold(
                          18,
                        ).copyWith(color: const Color(0xFF6D4C41)),
                      ),
                    ),
                    SizedBox(width: 8.w),
                  ],
                ),
                SizedBox(height: 4.h),
                Obx(
                  () => Text(
                    controller.userData.value?.email ?? "",
                    style: AppTextStyles.regular(12).copyWith(
                      color: const Color(0xFF6D4C41).withValues(alpha: 0.7),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Edit Icon
          GestureDetector(
            onTap: () => Get.toNamed('/edit-profile'),
            child: Icon(Icons.edit_outlined, size: 24.r, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection() {
    return Column(
      children: [
        _buildMenuItem(
          icon: Icons.edit_note,
          title: "Memberships/Packages",
          onTap: () => Get.toNamed('/memberships'),
        ),
        _buildDivider(),
        Obx(
          () => _buildMenuItem(
            icon: Icons.notifications,
            title: "App Notifications",
            isToggle: true,
            toggleValue: controller.appNotifications.value,
            onToggle: controller.toggleAppNotifications,
          ),
        ),
        _buildDivider(),
        Obx(
          () => _buildMenuItem(
            icon: Icons.chat_bubble_outline,
            title: "WhatsApp Notifications",
            isToggle: true,
            toggleValue: controller.whatsappNotifications.value,
            onToggle: controller.toggleWhatsappNotifications,
          ),
        ),
        _buildDivider(),
        _buildMenuItem(
          icon: Icons.book,
          title: "My Bookings",
          onTap: () => Get.toNamed(Routes.myBookings),
        ),
        _buildDivider(),
        _buildMenuItem(
          icon: Icons.shield_outlined,
          title: "Order History",
          onTap: () => Get.toNamed(Routes.orderHistory),
        ),
        _buildDivider(),
        _buildMenuItem(
          icon: Icons.monitor_heart_outlined,
          title: "My Practice",
          onTap: () => Get.toNamed(Routes.myPractice),
        ),
        _buildDivider(),
        _buildMenuItem(
          icon: Icons.account_balance_wallet_outlined,
          title: "Wallet",
          onTap: () {
            final controller = Get.find<CustomBottomNavController>();
            controller.changeIndex(3);
          },
        ),
        _buildDivider(),
        _buildMenuItem(
          icon: Icons.security,
          title: "Change Password",
          onTap: () => Get.toNamed(Routes.updatePassword),
        ),
        _buildDivider(),
        _buildMenuItem(
          icon: Icons.info_outline,
          title: "About INARA",
          onTap: () => Get.toNamed(Routes.aboutUs),
        ),
        _buildDivider(),
        _buildMenuItem(
          icon: Icons.description_outlined,
          title: "Terms & Conditions",
          onTap: () => Get.toNamed(Routes.termsConditions),
        ),
        _buildDivider(),
        _buildMenuItem(
          icon: Icons.lock_outlined,
          title: "Privacy Policy",
          onTap: () => Get.toNamed(Routes.privacyPolicy),
        ),
        _buildDivider(),
        // _buildMenuItem(
        //   icon: Icons.insert_chart,
        //   title: "Track Progress",
        //   onTap: () => Get.toNamed(Routes.trackProgress),
        // ),
        // _buildDivider(),
        _buildMenuItem(
          icon: Icons.question_mark_outlined,
          title: "FAQ",
          onTap: () => Get.toNamed(Routes.faq),
        ),
        _buildDivider(),
        _buildMenuItem(
          icon: Icons.no_accounts_outlined,
          title: "Delete Account",
          onTap: () => Get.toNamed(Routes.deleteAccount),
        ),
        _buildDivider(),
        _buildMenuItem(
          icon: Icons.logout,
          title: "Log Out",
          onTap: () {
            Get.dialog(
              Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Container(
                  padding: EdgeInsets.all(20.r),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Log Out',
                        style: AppTextStyles.bold(
                          20,
                          color: const Color(0xFF6B5345),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        'Are you sure you want to log out?',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.regular(
                          14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(Get.context!);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFDCC8B8),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                              ),
                              child: Text(
                                'No',
                                style: AppTextStyles.bold(
                                  16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => controller.logout(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF6B5345),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                              ),
                              child: Text(
                                'Yes',
                                style: AppTextStyles.bold(
                                  16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          showArrow: false,
        ),
        _buildDivider(),
        SizedBox(height: 100.h),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
    bool isToggle = false,
    bool toggleValue = false,
    Function(bool)? onToggle,
    bool showArrow = true,
  }) {
    return InkWell(
      onTap: isToggle ? null : onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Row(
          children: [
            Icon(icon, size: 20.r, color: Colors.grey[600]),
            SizedBox(width: 15.w),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.medium(
                  16,
                ).copyWith(color: const Color(0xFF6D4C41)),
              ),
            ),
            if (isToggle)
              Switch(
                value: toggleValue,
                onChanged: onToggle,
                activeThumbColor: const Color(0xFF6D4C41),
              )
            else if (showArrow)
              Icon(
                Icons.arrow_forward_ios,
                size: 16.r,
                color: const Color(0xFF6D4C41),
              )
            else if (!showArrow && onTap != null && icon == Icons.logout)
              Container(),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: const Color(0xFF6D4C41).withValues(alpha: 0.2),
      height: 1,
    );
  }
}
