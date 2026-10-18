import 'package:flutter/material.dart';
import '../../../../routes/app_pages.dart';
import '../../../../utils/app_size.dart';
import '../../../../widgets/auth_option_text.dart';
import '../../../../widgets/header_text.dart';
import 'package:get/get.dart';

import '../../../../data/app_colors.dart';
import '../controllers/registration_controller.dart';
import '../widgets/sign_up_form.dart';

class RegistrationView extends GetView<RegistrationController> {
  const RegistrationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(top: 50.h, left: 24.w, right: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Header Text
              HeaderText(text: 'Create Your\nAccount'),
              SizedBox(height: 30.h),

              // Sign Up Form
              SignUpForm(),
              SizedBox(height: 20.h),

              // Footer
              AuthOptions(
                seconds: 0.obs,
                titleText: 'Already have an account? ',
                optionText: 'Log In',
                onTap: () {
                  Get.toNamed(Routes.logIn);
                },
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
