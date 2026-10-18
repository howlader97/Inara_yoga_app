import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/app_colors.dart';
import '../../../data/app_text_styles.dart';
import '../../../utils/app_size.dart';
import '../controllers/delete_account_controller.dart';

class DeleteAccountView extends GetView<DeleteAccountController> {
  const DeleteAccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Icon(Icons.arrow_back_ios, color: AppColors.headlineColor, size: 24.r),
        ),
        title: Text(
          'Delete Account',
          style: AppTextStyles.bold(20, color: AppColors.headlineColor),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30.h),
              _buildWarningBox(),
              SizedBox(height: 30.h),
              Text(
                'Enter Password',
                style: AppTextStyles.semiBold(16, color: AppColors.headlineColor),
              ),
              SizedBox(height: 10.h),
              _buildPasswordField(),
              const Spacer(),
              _buildDeleteButton(),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWarningBox() {
    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: AppColors.errorColor.withValues(alpha: 0.1),
        border: Border.all(color: AppColors.errorColor.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: AppColors.errorColor,
            size: 28.r,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Warning!',
                  style: AppTextStyles.bold(18, color: AppColors.errorColor),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Deleting your account is permanent. All your data, bookings, and history will be lost and cannot be recovered.',
                  style: AppTextStyles.regular(14, color: AppColors.errorColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField() {
    return Obx(
      () => TextField(
        controller: controller.passwordController,
        obscureText: !controller.isPasswordVisible.value,
        style: AppTextStyles.regular(16, color: AppColors.headlineColor),
        decoration: InputDecoration(
          hintText: 'Your password',
          hintStyle: AppTextStyles.regular(14, color: AppColors.headlineColor.withValues(alpha: 0.5)),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: AppColors.borderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: AppColors.borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: AppColors.headlineColor),
          ),
          suffixIcon: GestureDetector(
            onTap: controller.togglePasswordVisibility,
            child: Icon(
              controller.isPasswordVisible.value ? Icons.visibility : Icons.visibility_off,
              color: AppColors.headlineColor.withValues(alpha: 0.5),
              size: 20.r,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteButton() {
    return SizedBox(
      width: double.infinity,
      height: 55.h,
      child: Obx(
        () => ElevatedButton(
          onPressed: controller.isLoading.value ? null : controller.deleteAccount,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.errorColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.r),
            ),
            elevation: 0,
          ),
          child: controller.isLoading.value
              ? SizedBox(
                  height: 20.h,
                  width: 20.h,
                  child: const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  'Delete My Account',
                  style: AppTextStyles.bold(16, color: Colors.white),
                ),
        ),
      ),
    );
  }
}
