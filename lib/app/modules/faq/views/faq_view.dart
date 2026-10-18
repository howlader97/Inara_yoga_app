import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../models/faq_model.dart';
import '../../../data/app_colors.dart';
import '../../../data/app_text_styles.dart';
import '../../../utils/app_size.dart';
import '../../../widgets/custom_appbar.dart';

import 'package:get/get.dart';

import '../controllers/faq_controller.dart';

class FaqView extends GetView<FaqController> {
  const FaqView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'FAQ'),
      body: Obx(() {
        final isLoading = controller.isLoading.value;
        final faq = isLoading
            ? FAQModel(
                id: 'mock',
                type: 'FAQ',
                content:
                    'This is a long mockup of our FAQ details. Here are answers to common questions about using our app, membership renewals, and class bookings.\n\nQ: How do I book a class?\nA: Go to the home or courses screen, choose a class, and select Book Now.\n\nQ: Can I cancel a booking?\nA: Yes, cancellations are allowed up to 12 hours before the class begins.',
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              )
            : controller.faq.value;

        if (!isLoading && (faq == null || faq.content.isEmpty)) {
          return Center(
            child: Text(
              "No FAQ available.",
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
              faq!.content,
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
