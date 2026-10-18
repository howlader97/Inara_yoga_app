import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../data/image_path.dart';
import '../../../utils/app_size.dart';
import '../../../widgets/app_image/app_image.dart';
import '../../../widgets/image_top_button.dart';
import 'package:get/get.dart';

import '../../../data/app_text_styles.dart';
import '../../../routes/app_pages.dart';
import '../controllers/booking_details_controller.dart';

class BookingDetailsView extends GetView<BookingDetailsController> {
  const BookingDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        final isNotInitialized = !controller.isInitialized.value;

        return Skeletonizer(
          enabled: isNotInitialized,
          child: Stack(
            children: [
              _buildBackgroundImage(),
              ImageTopButton(onTap: () => Get.back()),
              _buildBookingDetailsSheet(),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildBackgroundImage() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: 450.h,
      child: Obx(
        () => AppImage(
          url: controller.imageUrl.value,
          path: "assets/images/network_placeholder_image.jpg", // fallback
          fit: BoxFit.cover,
          width: double.infinity,
          height: 450.h,
        ),
      ),
    );
  }

  Widget _buildBookingDetailsSheet() {
    const Color sheetBg = Color(0xFFF1E9E0);

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
            children: [
              _buildDragHandle(),
              _buildHeaderSection(),
              SizedBox(height: 10.h),
              _buildLevelTag(),
              SizedBox(height: 16.h),
              _buildSpotsSection(),
              SizedBox(height: 24.h),
              _buildInstructorSection(),
              SizedBox(height: 24.h),
              _buildAboutSection(),
              SizedBox(height: 20.h),
              _buildDateTimeSection(),
              SizedBox(height: 24.h),
              _buildLocationSection(),
              SizedBox(height: 24.h),
              _buildCancelButton(),
            ],
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

  Widget _buildHeaderSection() {
    const Color brownColor = Color(0xFF6B5345);
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              controller.title.value,
              style: AppTextStyles.bold(22, color: brownColor),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Icon(Icons.male_outlined, size: 24.r, color: brownColor),
                  Icon(Icons.female_outlined, size: 24.r, color: brownColor),
                ],
              ),
              Text(
                controller.price.value,
                style: AppTextStyles.bold(24, color: brownColor),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLevelTag() {
    const Color brownColor = Color(0xFF6B5345);
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: const Color(0xFFE5D6C9),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Text(
          'Intermediate',
          style: AppTextStyles.medium(12, color: brownColor),
        ),
      ),
    );
  }

  Widget _buildSpotsSection() {
    const Color brownColor = Color(0xFF6B5345);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Available spots 2',
          style: AppTextStyles.regular(
            12,
            color: brownColor.withValues(alpha: 0.6),
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          width: double.infinity,
          height: 10.h,
          decoration: BoxDecoration(
            color: const Color(0xFFD6C8BE),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Stack(
            children: [
              FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: 0.9,
                child: Container(
                  decoration: BoxDecoration(
                    color: brownColor,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              ),
              Align(
                alignment: const Alignment(0.8, 0),
                child: Container(
                  width: 12.r,
                  height: 12.r,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInstructorSection() {
    const Color brownColor = Color(0xFF6B5345);
    return Obx(
      () => Row(
        children: [
          ClipOval(
            child: AppImage(
              url: controller.instructorImage.value,
              path: "assets/images/network_placeholder_image.jpg",
              width: 52.r, // radius * 2
              height: 52.r,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Instructors',
                style: AppTextStyles.regular(
                  10,
                  color: brownColor.withValues(alpha: 0.6),
                ),
              ),
              Text(
                controller.instructorName.value,
                style: AppTextStyles.medium(18, color: brownColor),
              ),
            ],
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () => Get.toNamed(Routes.instructorDetails),
            style: ElevatedButton.styleFrom(
              backgroundColor: brownColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
              elevation: 0,
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            ),
            child: Text(
              'View Profile',
              style: AppTextStyles.bold(12, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    const Color brownColor = Color(0xFF6B5345);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('About Class', style: AppTextStyles.bold(18, color: brownColor)),
        SizedBox(height: 12.h),
        RichText(
          text: TextSpan(
            style: AppTextStyles.regular(
              14,
              color: brownColor.withValues(alpha: 0.8),
            ),
            children: [
              const TextSpan(
                text:
                    'A dynamic flow class to wake up your body and mind.\nSynchronize breath with movement in this energizing session suited for those with some yoga experience.\n',
              ),
              TextSpan(
                text: 'See more',
                style: AppTextStyles.bold(14, color: brownColor),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDateTimeSection() {
    const Color brownColor = Color(0xFF6B5345);
    return Row(
      children: [
        Icon(
          Icons.access_time,
          size: 20.r,
          color: brownColor.withValues(alpha: 0.6),
        ),
        SizedBox(width: 8.w),
        Flexible(
          child: Text(
            '08:00 AM to 08:30 AM',
            style: AppTextStyles.medium(
              14,
              color: brownColor.withValues(alpha: 0.6),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(width: 16.w),
        Icon(
          Icons.calendar_today_outlined,
          size: 20.r,
          color: brownColor.withValues(alpha: 0.6),
        ),
        SizedBox(width: 8.w),
        Flexible(
          child: Text(
            'October 20, 2025',
            style: AppTextStyles.medium(
              14,
              color: brownColor.withValues(alpha: 0.6),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildLocationSection() {
    const Color textColor = Color(0xFF6B5345);
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F2EF),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Location', style: AppTextStyles.bold(18, color: textColor)),
          SizedBox(height: 16.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(15.r),
            child: Obx(
              () => AppImage(
                url: controller.mapImage.value,
                networkPlaceholderImage:
                    "assets/images/network_placeholder_image.jpg",
                height: 160.h,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 16.h),
          _buildLocationButtons(),
        ],
      ),
    );
  }

  Widget _buildLocationButtons() {
    const Color brownColor = Color(0xFF6B5345);
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 50.h,
            decoration: BoxDecoration(
              color: const Color(0xFFDCC8B8),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: brownColor.withValues(alpha: 0.1)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.call_outlined, size: 20.r, color: brownColor),
                SizedBox(width: 8.w),
                const Text(
                  'Call Studio',
                  style: TextStyle(
                    color: brownColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Container(
            height: 50.h,
            decoration: BoxDecoration(
              color: brownColor,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(ImagePath.whatappButton, height: 30.r, width: 30.r),
                SizedBox(width: 8.w),
                const Text(
                  'WhatsApp',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCancelButton() {
    return SizedBox(
      width: double.infinity,
      height: 55.h,
      child: Builder(
        builder: (context) => ElevatedButton(
          onPressed: () => controller.showCancelDialog(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6B5345),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.r),
            ),
            elevation: 0,
          ),
          child: Text(
            'Cancel',
            style: AppTextStyles.bold(18, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
