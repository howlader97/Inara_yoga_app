import 'package:flutter/material.dart';
import '../../../utils/app_size.dart';
import '../../../widgets/app_image/app_image.dart';
import '../../../widgets/custom_appbar.dart';
import '../../../widgets/custom_elevated_button.dart';
import '../../../widgets/text_field_label_text.dart';
import 'package:get/get.dart';

import 'package:image_picker/image_picker.dart';
import '../../../data/app_colors.dart';
import '../../../data/app_text_styles.dart';
import '../../../widgets/custom_text_field.dart';
import '../controllers/edit_profile_controller.dart';

class EditProfileView extends GetView<EditProfileController> {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(title: 'Edit Profile'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileImage(context),
              SizedBox(height: 30.h),
              _buildForm(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 30.h),
        child: Obx(
          () => CustomElevetedButton(
            buttonText: controller.isLoading.value ? '' : 'Save',
            onTap: controller.isLoading.value
                ? null
                : () {
                    controller.updateProfile();
                  },
            child: controller.isLoading.value
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  )
                : null,
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage(BuildContext context) {
    return GestureDetector(
      onTap: () => _showImageSourceBottomSheet(context),
      child: Stack(
        children: [
          Obx(() {
            return SizedBox(
              width: 100.r,
              height: 100.r,
              child: ClipOval(
                child: AppImage(
                  filePath: controller.profileImage.value.isNotEmpty
                      ? controller.profileImage.value
                      : null,
                  url: controller.profileImage.value.isEmpty
                      ? controller.userData.value?.avatar
                      : null,
                  path: "assets/images/network_placeholder_image.jpg",
                  fit: BoxFit.cover,
                ),
              ),
            );
          }),
          Positioned(
            right: 0,
            bottom: 5.h,
            child: Container(
              padding: EdgeInsets.all(6.r),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.camera_alt_outlined,
                size: 18.r,
                color: const Color(0xFF6D4C41),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFieldLabelText(
          label: 'Name',
          showAstric: false,
          textStyle: AppTextStyles.bold(
            16,
          ).copyWith(color: const Color(0xFF6D4C41)),
        ),
        CustomTextField(
          controller: controller.nameController,
          hintText: "User name",
        ),
        SizedBox(height: 16.h),
        TextFieldLabelText(
          label: 'Email',
          showAstric: false,
          textStyle: AppTextStyles.bold(
            16,
          ).copyWith(color: const Color(0xFF6D4C41)),
        ),
        CustomTextField(
          controller: controller.emailController,
          hintText: "example@gmail.com",
          isReadOnly: true,
        ),
        SizedBox(height: 16.h),
        TextFieldLabelText(
          label: 'Phone number',
          showAstric: false,
          textStyle: AppTextStyles.bold(
            16,
          ).copyWith(color: const Color(0xFF6D4C41)),
        ),
        CustomTextField(
          controller: controller.phoneController,
          hintText: "•••• •••• ••••",
        ),
      ],
    );
  }

  void _showImageSourceBottomSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Select Image Source", style: AppTextStyles.bold(18)),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSourceOption(
                  icon: Icons.camera_alt_outlined,
                  label: "Camera",
                  onTap: () {
                    Navigator.pop(context);
                    controller.pickImage(ImageSource.camera);
                  },
                ),
                _buildSourceOption(
                  icon: Icons.photo_library_outlined,
                  label: "Gallery",
                  onTap: () {
                    Navigator.pop(context);
                    controller.pickImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSourceOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: AppColors.backgroundColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 30.r, color: const Color(0xFF6D4C41)),
          ),
          SizedBox(height: 8.h),
          Text(label, style: AppTextStyles.medium(14)),
        ],
      ),
    );
  }
}
