import 'package:flutter/material.dart';
import '../widgets/change_pass_form.dart';
import '../widgets/pass_req_info.dart';
import '../../../widgets/custom_appbar.dart';
import 'package:get/get.dart';

import '../../../data/app_colors.dart';
import '../../../data/app_text_styles.dart';
import '../../../utils/app_size.dart';
import '../../../widgets/custom_elevated_button.dart';
import '../controllers/update_password_controller.dart';

class UpdatePasswordView extends GetView<UpdatePasswordController> {
  const UpdatePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Update Password'),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Change your Password',
                style: AppTextStyles.bold(
                  32,
                  color: AppColors.headlineColor,
                  fontFamily: 'Times New Roman',
                ),
              ),
              SizedBox(height: 40.h),

              // Password Requirements Info
              PassReqInfo(),

              SizedBox(height: 30.h),

              // Current Password
              ChangePasswordForm(),
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
                    controller.updatePassword();
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
}
