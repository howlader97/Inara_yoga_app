import 'package:flutter/material.dart';
import '../../../../data/app_colors.dart';
import '../../../../data/app_text_styles.dart';
import '../../../../routes/app_pages.dart';
import '../../../../utils/app_size.dart';
import '../../../../widgets/custom_elevated_button.dart';
import 'package:get/get.dart';

import '../../../../widgets/custom_checkbox.dart';
import '../../../../widgets/custom_text_field.dart';
import '../../../../widgets/text_field_label_text.dart';
import '../controllers/log_in_controller.dart';

class LogInForm extends StatelessWidget {
  const LogInForm({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LogInController>(
      init: LogInController(),
      builder: (controller) {
        return Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFieldLabelText(
                label: 'Email or Phone Number',
                showAstric: false,
              ),
              CustomTextField(
                controller: controller.emailController,
                hintText: 'enter your email or phone number',
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email or phone number';
                  }
                  return null;
                },
                onFieldSubmitted: (_) {
                  // FocusManager.instance.primaryFocus?.unfocus();
                  FocusScope.of(context).requestFocus(controller.focusNode);
                },
              ),
              SizedBox(height: 20.h),
              TextFieldLabelText(label: 'Password', showAstric: false),
              Obx(
                () => CustomTextField(
                  controller: controller.passwordController,
                  obscureText: !controller.isPasswordVisible.value,
                  hintText: '**** **** ****',
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.visiblePassword,
                  focusNode: controller.focusNode,
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.isPasswordVisible.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: AppColors.headlineColor,
                    ),
                    onPressed: controller.togglePasswordVisibility,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 10.h),
              Row(
                children: [
                  Obx(() {
                    return SizedBox(
                      height: 24.h,
                      width: 24.w,
                      child: CustomCheckBox(
                        onChanged: (value) => controller.toggleRememberMe(),
                        value: controller.isRememberMe.value,
                      ),
                    );
                  }),
                  SizedBox(width: 8.w),
                  Text(
                    'Remember me',
                    style: AppTextStyles.regular(
                      14,
                      color: AppColors.headlineColor,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(Routes.recoveryPassword);
                    },
                    child: Text(
                      'Forgot password?',
                      style: AppTextStyles.medium(
                        14,
                        color: AppColors.errorColor,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 40.h),

              Obx(
                () => CustomElevetedButton(
                  buttonText: controller.isLoading.value
                      ? "Loading...."
                      : 'Log In',
                  onTap: () {
                    if (!controller.isLoading.value) {
                      controller.login();
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
