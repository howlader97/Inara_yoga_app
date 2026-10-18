import 'package:flutter/material.dart';
import '../../../../data/app_colors.dart';
import '../controllers/recovery_password_controller.dart';
import '../../../../utils/app_size.dart';
import '../../../../widgets/custom_elevated_button.dart';
import '../../../../widgets/custom_text_field.dart';
import '../../../../widgets/text_field_label_text.dart';
import 'package:get/get.dart';

class RcoverPassForm extends StatelessWidget {
  const RcoverPassForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RecoveryPasswordController>();
    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFieldLabelText(label: 'Email', showAstric: false),
          SizedBox(height: 8.h),
          CustomTextField(
            controller: controller.emailController,
            hintText: 'example@gmail.com',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!GetUtils.isEmail(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          SizedBox(height: 50.h),

          // Buttons Row
          Obx(
            () => Row(
              children: [
                Expanded(
                  child: CustomElevetedButton(
                    buttonText: 'Back',
                    backgroundColor: AppColors.buttonSecondaryColor,
                    buttonTextColor: AppColors.headlineColor,
                    onTap: () => Get.back(),
                  ),
                ),
                SizedBox(width: 20.w),
                Expanded(
                  child: CustomElevetedButton(
                    buttonText: controller.isLoading.value
                        ? 'loading..'
                        : 'Next',
                    onTap: () {
                      controller.checkAndSendOtp();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
