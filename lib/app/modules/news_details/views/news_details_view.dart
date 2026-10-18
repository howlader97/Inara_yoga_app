import 'package:flutter/material.dart';
import '../../../utils/app_size.dart';
import '../../../widgets/app_image/app_image.dart';
import '../../../widgets/image_top_button.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../data/app_text_styles.dart';
import '../controllers/news_details_controller.dart';

class NewsDetailsView extends GetView<NewsDetailsController> {
  const NewsDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          _buildBackgroundImage(),
          Positioned(
            top: 50.h,
            left: 16.w,
            child: ImageTopButton(onTap: () => Get.back()),
          ),
          _buildDetailsSheet(),
        ],
      ),
    );
  }

  Widget _buildBackgroundImage() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: 450.h,
      child: Stack(
        fit: StackFit.expand,
        children: [
          AppImage(
            url: controller.item.thumbnail,
            path: "assets/images/network_placeholder_image.jpg",
            fit: BoxFit.cover,
          ),

          // Dark overlay
          Container(color: Colors.black.withValues(alpha: 0.4)),
        ],
      ),
    );
  }

  Widget _buildDetailsSheet() {
    const Color sheetBg = Color(0xFFF1E9E0);
    const Color brownColor = Color(0xFF6B5345);

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.55,
      maxChildSize: 0.95,
      snap: true,
      snapSizes: const [0.6, 0.95],
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: sheetBg,
            borderRadius: BorderRadius.vertical(top: Radius.circular(35.r)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: ListView(
            controller: scrollController,
            padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 30.h),
            children: [_buildDragHandle(), _buildAboutSection(brownColor)],
          ),
        );
      },
    );
  }

  Widget _buildDragHandle() {
    return Center(
      child: Container(
        width: 40.w,
        height: 4.h,
        margin: EdgeInsets.only(bottom: 24.h),
        decoration: BoxDecoration(
          color: Colors.grey.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
    );
  }

  Widget _buildAboutSection(Color brownColor) {
    String formatDate(DateTime dateTime) {
      String formatted = DateFormat('EE MMMM d, yyyy').format(dateTime);
      return formatted;
    }

    final formattedDate = formatDate(controller.item.publishedAt);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(formattedDate),
        SizedBox(height: 12.h),
        Text(
          controller.item.title,
          style: AppTextStyles.bold(18, color: brownColor),
        ),
        SizedBox(height: 12.h),
        Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                controller.item.shortDescription,
                maxLines: controller.isExpanded.value ? null : 3,
                style: AppTextStyles.regular(
                  14,
                  color: brownColor.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
