import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../models/privacy_policy_model.dart';
import '../../../data/app_colors.dart';
import '../../../data/app_text_styles.dart';
import '../../../utils/app_size.dart';
import '../../../widgets/custom_appbar.dart';

import 'package:get/get.dart';

import '../controllers/privacy_policy_controller.dart';

class PrivacyPolicyView extends GetView<PrivacyPolicyController> {
  const PrivacyPolicyView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Privacy Policy'),
      body: Obx(() {
        final isLoading = controller.isLoading.value;
        final privacyPolicy = isLoading
            ? PrivacyPolicy(
                id: 'mock',
                type: 'PRIVACY_POLICY',
                content:
                    'This is a long mockup of our privacy policy text. It contains paragraphs of mock legal details to demonstrate the layout. It shows how the text wraps and displays under the skeleton loading state. We care about your privacy and safety.\n\nWe collect information that you provide directly to us when you register for an account, subscribe to our newsletter, or book yoga classes. This may include your name, email address, phone number, and payment information.',
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              )
            : controller.privacyPolicy.value;

        if (!isLoading &&
            (privacyPolicy == null || privacyPolicy.content.isEmpty)) {
          return Center(
            child: Text(
              "No Privacy Policy available.",
              style: AppTextStyles.regular(
                14,
              ).copyWith(color: AppColors.bodyTextColor),
            ),
          );
        }

        return Skeletonizer(
          enabled: isLoading,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: Text(
              privacyPolicy!.content,
              style: AppTextStyles.regular(14).copyWith(
                color: AppColors.bodyTextColor.withValues(alpha: 0.8),
                height: 1.5,
              ),
            ),
          ),
        );
      }),
    );
  }
}
