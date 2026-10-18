import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../controllers/registration_controller.dart';
import '../../../../utils/app_size.dart';
import '../../../../widgets/custom_text_field.dart';
import '../../../../widgets/text_field_label_text.dart';
import 'package:get/get.dart';

import '../../../../data/app_colors.dart';
import '../../../../data/app_text_styles.dart';
import '../../../../routes/app_pages.dart';
import '../../../../widgets/custom_checkbox.dart';
import '../../../../widgets/custom_elevated_button.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RegistrationController>(
      init: RegistrationController(),
      builder: (controller) {
        return Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFieldLabelText(label: 'Full Name'),
              CustomTextField(
                controller: controller.fullNameController,
                hintText: 'Enter full name',

                validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
              ),
              // Row(
              //   children: [
              //     Expanded(
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           TextFieldLabelText(label: 'First name'),
              //           CustomTextField(
              //             controller: controller.firstNameController,
              //             hintText: 'First name',
              //             validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
              //           ),
              //         ],
              //       ),
              //     ),
              //     SizedBox(width: 16.w),
              //     Expanded(
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           TextFieldLabelText(label: 'Last name'),
              //           CustomTextField(
              //             controller: controller.lastNameController,
              //             hintText: 'Last name',
              //             validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
              //           ),
              //         ],
              //       ),
              //     ),
              //   ],
              // ),
              SizedBox(height: 20.h),

              // Phone Number
              TextFieldLabelText(label: 'Phone number'),
              CustomTextField(
                controller: controller.phoneController,
                hintText: 'phone number',
                keyboardType: TextInputType.phone,
                validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
              ),
              SizedBox(height: 20.h),

              // Email
              TextFieldLabelText(label: 'Email'),
              CustomTextField(
                controller: controller.emailController,
                hintText: 'example@gmail.com',
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v?.isEmpty ?? true) return 'Required';
                  if (!GetUtils.isEmail(v!)) return 'Invalid email';
                  return null;
                },
              ),
              SizedBox(height: 20.h),

              // Gender
              TextFieldLabelText(label: 'Gender'),
              Obx(
                () => DropdownButtonFormField<String>(
                  initialValue: controller.selectedGender.value,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.buttonSecondaryColor.withValues(
                      alpha: 0.3,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: const BorderSide(
                        color: AppColors.borderColor,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: const BorderSide(
                        color: AppColors.borderColor,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: const BorderSide(
                        color: AppColors.borderColor,
                      ),
                    ),
                  ),
                  dropdownColor: AppColors.backgroundColor,
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: AppColors.headlineColor,
                  ),
                  items: ['Male', 'Female'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: AppTextStyles.regular(
                          14,
                          color: AppColors.headlineColor,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: controller.setGender,
                ),
              ),
              SizedBox(height: 20.h),

              // Password
              TextFieldLabelText(label: 'Password'),
              Obx(
                () => CustomTextField(
                  controller: controller.passwordController,
                  hintText: '**** ****',
                  obscureText: !controller.isPasswordVisible.value,
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.isPasswordVisible.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: controller.togglePasswordVisibility,
                  ),
                  validator: (v) => (v?.length ?? 0) < 6 ? 'Min 6 chars' : null,
                ),
              ),
              SizedBox(height: 20.h),

              // Confirm Password
              TextFieldLabelText(label: 'Confirm password'),
              Obx(
                () => CustomTextField(
                  controller: controller.confirmPasswordController,
                  hintText: '**** ****',
                  obscureText: !controller.isConfirmPasswordVisible.value,
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.isConfirmPasswordVisible.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.grey,
                    ),
                    onPressed: controller.toggleConfirmPasswordVisibility,
                  ),
                  validator: (v) => v != controller.passwordController.text
                      ? 'Passwords do not match'
                      : null,
                ),
              ),
              SizedBox(height: 30.h),

              // Terms and Conditions Checkbox
              Obx(
                () => Row(
                  children: [
                    CustomCheckBox(
                      value: controller.isTermsAccepted.value,
                      onChanged: (v) {
                        if (!controller.isLoading.value) {
                          controller.isTermsAccepted.value = v ?? false;
                        }
                      },
                    ),

                    Flexible(
                      child: RichText(
                        text: TextSpan(
                          text: "I agree to the ",
                          style: AppTextStyles.regular(
                            14,
                            color: AppColors.headlineColor,
                          ),
                          children: [
                            TextSpan(
                              text: "Terms of services",
                              style: AppTextStyles.bold(
                                14,
                                color: AppColors.headlineColor,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Get.toNamed(Routes.termsConditions);
                                },
                            ),
                            TextSpan(text: " & "),
                            TextSpan(
                              text: "Privacy and Policy",
                              style: AppTextStyles.bold(
                                14,
                                color: AppColors.headlineColor,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Get.toNamed(Routes.termsConditions);
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),

              // Register Button
              Obx(
                () => CustomElevetedButton(
                  buttonText: controller.isLoading.value
                      ? "Loading.."
                      : 'Register',
                  onTap: controller.isTermsAccepted.value
                      ? () {
                          if (!controller.isLoading.value) {
                            controller.signUp();
                          }
                          // if (controller.formKey.currentState?.validate() ?? false) {
                          //   Get.toNamed(Routes.recoveryOtp, arguments: {'isRegistering': true});
                          // }
                        }
                      : null,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
