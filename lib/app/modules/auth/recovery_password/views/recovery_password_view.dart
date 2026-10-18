import 'package:flutter/material.dart';
import '../widgets/recover_pass_form.dart';
import '../../../../utils/app_size.dart';
import '../../../../widgets/header_sub_text.dart';
import '../../../../widgets/header_text.dart';
import 'package:get/get.dart';

import '../../../../data/app_colors.dart';
import '../controllers/recovery_password_controller.dart';

class RecoveryPasswordView extends GetView<RecoveryPasswordController> {
  const RecoveryPasswordView({super.key});
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
              HeaderText(text: 'Recover Password'),
              SizedBox(height: 20.h),
              HeaderSubText(
                text:
                    'Enter the Email Address that you used when register to recover your password, You will receive a Verification code.',
              ),
              SizedBox(height: 40.h),

              //Recover Password Form
              RcoverPassForm(),
            ],
          ),
        ),
      ),
    );
  }
}
