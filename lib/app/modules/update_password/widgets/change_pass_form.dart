import 'package:flutter/material.dart';
import '../../../data/app_colors.dart';
import '../../../data/app_text_styles.dart';
import '../controllers/update_password_controller.dart';
import '../../../utils/app_size.dart';
import '../../../widgets/custom_text_field.dart';
import '../../../widgets/text_field_label_text.dart';
import 'package:get/get.dart';

class ChangePasswordForm extends StatelessWidget {
  const ChangePasswordForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UpdatePasswordController>();
    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFieldLabelText(
            label: 'Current Password',
            showAstric: true,
            textStyle: AppTextStyles.bold(
              16,
            ).copyWith(color: const Color(0xFF6D4C41)),
          ),
          Obx(
            () => CustomTextField(
              controller: controller.passwordController,
              hintText: "Enter current password",
              obscureText: controller.showCurrentPassword.value,
              keyboardType: TextInputType.visiblePassword,
              suffixIcon: IconButton(
                icon: Icon(
                  controller.showCurrentPassword.value
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: AppColors.headlineColor,
                ),
                onPressed: controller.toggleCurrentPassword,
              ),
              validator: (value) => controller.validatePassword(value),
            ),
          ),

          SizedBox(height: 16.h),

          // New Password
          TextFieldLabelText(
            label: 'New Password',
            showAstric: true,
            textStyle: AppTextStyles.bold(
              16,
            ).copyWith(color: const Color(0xFF6D4C41)),
          ),
          Obx(
            () => CustomTextField(
              controller: controller.newPasswordController,
              hintText: "Enter new password",
              obscureText: controller.showNewPassword.value,
              keyboardType: TextInputType.visiblePassword,
              suffixIcon: IconButton(
                icon: Icon(
                  controller.showNewPassword.value
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: AppColors.headlineColor,
                ),
                onPressed: controller.toggleNewPassword,
              ),
              validator: (value) => controller.validateNewPassword(value),
            ),
          ),

          SizedBox(height: 16.h),

          // Confirm Password
          TextFieldLabelText(
            label: 'Confirm Password',
            showAstric: true,
            textStyle: AppTextStyles.bold(
              16,
            ).copyWith(color: const Color(0xFF6D4C41)),
          ),
          Obx(
            () => CustomTextField(
              controller: controller.confirmPasswordController,
              hintText: "Confirm new password",
              obscureText: controller.showConfirmPassword.value,
              keyboardType: TextInputType.visiblePassword,
              suffixIcon: IconButton(
                icon: Icon(
                  controller.showConfirmPassword.value
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: AppColors.headlineColor,
                ),
                onPressed: controller.toggleConfirmPassword,
              ),
              validator: (value) => controller.validateConfirmPassword(value),
            ),
          ),
        ],
      ),
    );
  }
}
