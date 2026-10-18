import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../models/terms_and_conditions_model.dart';
import '../../../utils/app_size.dart';
import '../../../widgets/custom_appbar.dart';
import 'package:get/get.dart';
import '../../../data/app_colors.dart';
import '../../../data/app_text_styles.dart';
import '../controllers/terms_conditions_controller.dart';

class TermsConditionsView extends GetView<TermsConditionsController> {
  const TermsConditionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: const CustomAppBar(title: 'Terms & Conditions'),
      body: Obx(() {
        final isLoading = controller.isLoading.value;
        final terms = isLoading
            ? TermsConditions(
                id: 'mock',
                type: 'TERMS_CONDITIONS',
                content:
                    'This is a long mockup of our Terms & Conditions. By accessing and using our application, you agree to comply with and be bound by these terms. Please read them carefully.\n\n1. Booking & Cancellations\nAll class bookings are subject to availability. Cancellations must be made at least 12 hours prior to the scheduled class time to receive a full refund or credit. Failure to cancel on time will result in forfeiture of the class fee.',
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              )
            : controller.termsCondition.value;

        if (!isLoading && (terms == null || terms.content.isEmpty)) {
          return Center(
            child: Text(
              "No Terms & Conditions available.",
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
              terms!.content,
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
