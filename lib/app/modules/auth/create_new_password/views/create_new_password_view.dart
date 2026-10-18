import 'package:flutter/material.dart';
import '../widgets/new_pass_form.dart';
import '../../../../utils/app_size.dart';
import '../../../../widgets/header_sub_text.dart';
import '../../../../widgets/header_text.dart';
import 'package:get/get.dart';

import '../../../../data/app_colors.dart';
import '../controllers/create_new_password_controller.dart';

class CreateNewPasswordView extends GetView<CreateNewPasswordController> {
  const CreateNewPasswordView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(left: 24.w, right: 24.w, top: 50.h),
          child: Column(
            children: [
              // Header Section
              HeaderText(text: 'Create New Password'),
              SizedBox(height: 20.h),
              HeaderSubText(
                text: 'Type and confirm a secure new password for your amount,',
              ),
              SizedBox(height: 40.h),

              // New password form
              NewPassForm(),
            ],
          ),
        ),
      ),
    );
  }
}
