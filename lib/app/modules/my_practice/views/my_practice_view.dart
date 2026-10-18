import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/app_colors.dart';
import '../../../data/app_text_styles.dart';
import '../../../utils/app_size.dart';
import '../../../widgets/app_image/app_image.dart';
import '../../profile/controllers/profile_controller.dart';
import '../controllers/my_practice_controller.dart';

class MyPracticeView extends GetView<MyPracticeController> {
  const MyPracticeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              SizedBox(height: 24.h),
              _buildTabs(),
              SizedBox(height: 24.h),
              _buildStatsArea(),
              SizedBox(height: 100.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.cardBackgroundColor,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30.r)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6D4C41).withValues(alpha: 0.12),
            offset: const Offset(0, 8),
            blurRadius: 16,
          ),
        ],
      ),
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        top: 16.h,
        bottom: 24.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Get.back(),
                child: Icon(
                  Icons.arrow_back_ios,
                  color: AppColors.headlineColor,
                  size: 24.r,
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                'My Practice',
                style: AppTextStyles.bold(24, color: AppColors.headlineColor),
              ),
            ],
          ),
          // User Avatar (using ProfileController if available, or placeholder)
          Builder(
            builder: (context) {
              if (Get.isRegistered<ProfileController>()) {
                final profileCtrl = Get.find<ProfileController>();
                return Obx(() {
                  final imagePath = profileCtrl.profileImage.value;
                  return _buildAvatar(
                    imagePath,
                    profileCtrl.userData.value?.avatar,
                  );
                });
              }
              return _buildAvatar('', null);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(String imagePath, String? networkUrl) {
    return Container(
      width: 50.r,
      height: 50.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: ClipOval(
        child: imagePath.isNotEmpty
            ? AppImage(filePath: imagePath, fit: BoxFit.cover)
            : AppImage(
                url: networkUrl ?? "",
                path: "assets/images/network_placeholder_image.jpg",
                fit: BoxFit.cover,
              ),
      ),
    );
  }

  Widget _buildTabs() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.headlineColor, width: 1.5),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          children: [
            _buildTabItem(0, 'This month'),
            Container(width: 1.5, height: 30.h, color: AppColors.headlineColor),
            _buildTabItem(1, 'This Year'),
            Container(width: 1.5, height: 30.h, color: AppColors.headlineColor),
            _buildTabItem(2, 'All Time'),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem(int index, String title) {
    return Expanded(
      child: Obx(() {
        final isSelected = controller.selectedTab.value == index;
        return GestureDetector(
          onTap: () => controller.changeTab(index),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.headlineColor.withValues(alpha: 0.1)
                  : Colors.transparent,
              borderRadius: _getTabBorderRadius(index),
            ),
            alignment: Alignment.center,
            child: Text(
              title,
              style: AppTextStyles.medium(14, color: AppColors.headlineColor),
            ),
          ),
        );
      }),
    );
  }

  BorderRadius? _getTabBorderRadius(int index) {
    if (index == 0) return BorderRadius.horizontal(left: Radius.circular(18.r));
    if (index == 2) {
      return BorderRadius.horizontal(right: Radius.circular(18.r));
    }
    return null;
  }

  Widget _buildStatsArea() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Obx(() {
        if (controller.isLoading.value) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 100.h),
            child: const Center(
              child: CircularProgressIndicator(color: AppColors.headlineColor),
            ),
          );
        }

        final data = controller.currentData;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${data['classes']} Classes',
              style: AppTextStyles.bold(22, color: AppColors.headlineColor),
            ),
            SizedBox(height: 16.h),
            _buildChartArea(data),
            SizedBox(height: 32.h),
            _buildStatList(data),
          ],
        );
      }),
    );
  }

  Widget _buildChartArea(Map<String, dynamic> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Year text placeholder like in sketch "2026"
        Text(
          controller.trendYear,
          style: AppTextStyles.medium(16, color: AppColors.headlineColor),
        ),
        SizedBox(height: 4.h),
        Container(height: 1, width: 50.w, color: AppColors.headlineColor),
        SizedBox(height: 16.h),
        // Chart graphics
        SizedBox(
          height: 100.h,
          width: double.infinity,
          child: CustomPaint(
            painter: LineChartPainter(controller.chartTrendData, 30.w),
          ),
        ),
        SizedBox(height: 16.h),
        Divider(color: AppColors.headlineColor, thickness: 1),
        SizedBox(height: 8.h),
        // X-axis labels
        Padding(
          padding: EdgeInsets.only(left: 30.w),
          child: Row(
            mainAxisAlignment: controller.xAxisLabels.length == 1
                ? MainAxisAlignment.center
                : MainAxisAlignment.spaceBetween,
            children: controller.xAxisLabels
                .map(
                  (label) => Text(
                    label,
                    style: AppTextStyles.bold(
                      controller.selectedTab.value == 0 ? 16 : 10,
                      color: AppColors.headlineColor,
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildStatList(Map<String, dynamic> data) {
    return Column(
      children: [
        _buildStatItem('Hours on the mat', data['hoursOnMat']),
        _buildStatItem('Most practised', data['mostPractised']),
        _buildStatItem('Most often with', data['mostOftenWith']),
        _buildStatItem('Weekly average', data['weeklyAverage']),
        _buildStatItem('Member since', data['memberSince'], isLast: true),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, {bool isLast = false}) {
    return Column(
      children: [
        Divider(
          color: AppColors.headlineColor.withValues(alpha: 0.2),
          thickness: 1,
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: AppTextStyles.regular(
                  14,
                  color: AppColors.headlineColor.withValues(alpha: 0.7),
                ),
              ),
              Text(
                value,
                style: AppTextStyles.medium(14, color: AppColors.headlineColor),
              ),
            ],
          ),
        ),
        if (isLast)
          Divider(
            color: AppColors.headlineColor.withValues(alpha: 0.2),
            thickness: 1,
          ),
      ],
    );
  }
}

class LineChartPainter extends CustomPainter {
  final List<int> data;
  final double leftPadding;

  LineChartPainter(this.data, this.leftPadding);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    int maxVal = data.reduce((a, b) => a > b ? a : b);

    int yMax;
    int stepY;
    if (maxVal <= 5) {
      yMax = 5;
      stepY = 5;
    } else if (maxVal <= 10) {
      yMax = 10;
      stepY = 5;
    } else if (maxVal <= 20) {
      yMax = 20;
      stepY = 10;
    } else if (maxVal <= 50) {
      yMax = ((maxVal / 10).ceil() * 10);
      stepY = 10;
    } else {
      yMax = ((maxVal / 20).ceil() * 20);
      stepY = 20;
    }

    if (yMax == 0) yMax = 5; // Fallback

    // Draw Y-axis labels and grid lines
    final textStyle = AppTextStyles.medium(
      10,
      color: AppColors.headlineColor.withValues(alpha: 0.5),
    );
    final gridPaint = Paint()
      ..color = AppColors.headlineColor.withValues(alpha: 0.1)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    for (int i = 0; i <= yMax; i += stepY) {
      double y = size.height - (i / yMax * size.height * 0.8);

      // Draw grid line (except for 0 since we have a divider below)
      if (i > 0) {
        canvas.drawLine(
          Offset(leftPadding, y),
          Offset(size.width, y),
          gridPaint,
        );
      }

      // Draw label
      final textSpan = TextSpan(text: i.toString(), style: textStyle);
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout(minWidth: 0, maxWidth: leftPadding);
      // Center the text vertically, align to the left side
      textPainter.paint(canvas, Offset(0, y - textPainter.height / 2));
    }

    final paint = Paint()
      ..color = AppColors.headlineColor
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    final double stepX =
        (size.width - leftPadding) / (data.length > 1 ? data.length - 1 : 1);

    for (int i = 0; i < data.length; i++) {
      double x = leftPadding + (i * stepX);
      double y = size.height - (data[i] / yMax * size.height * 0.8);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);

    // Draw dot at the last point
    final dotPaint = Paint()
      ..color = AppColors.headlineColor
      ..style = PaintingStyle.fill;

    if (data.isNotEmpty) {
      double lastX = leftPadding + ((data.length - 1) * stepX);
      double lastY = size.height - (data.last / yMax * size.height * 0.8);
      canvas.drawCircle(Offset(lastX, lastY), 4, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant LineChartPainter oldDelegate) {
    if (oldDelegate.leftPadding != leftPadding) return true;
    if (oldDelegate.data.length != data.length) return true;
    for (int i = 0; i < data.length; i++) {
      if (oldDelegate.data[i] != data[i]) return true;
    }
    return false;
  }
}
