import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../../models/all_courses_model.dart';
import '../../../data/image_path.dart';
import '../../../methodes/call_studio.dart';
import '../../../methodes/call_whatsapp.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/app_size.dart';
import '../../../widgets/app_image/app_image.dart';
import '../../../widgets/custom_elevated_button.dart';
import '../../../widgets/image_top_button.dart';
import 'package:get/get.dart';
import '../../../utils/duration_formatter.dart';
import '../../../widgets/full_screen_map_view.dart';
import '../../../data/app_text_styles.dart';
import '../../home/widgets/available_spot_indicator.dart';
import '../controllers/course_details_controller.dart';

class CourseDetailsView extends GetView<CourseDetailsController> {
  const CourseDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        final isLoading = controller.isLoading.value;
        final courseItem = isLoading
            ? Course(
                title: 'Hatha Yoga Course',
                slug: 'hatha-yoga-course',
                description:
                    'This is a mock course description text. It has two lines or more of details to show how the course information looks under skeleton loading state.',
                imageUrl: '',
                price: 970.0,
                scheduledAt: DateTime.now(),
                duration: '60 Mins',
                difficulty: 'All Levels',
                language: 'English',
                gender: 'Both',
                location: 'Main Studio',
                phone: '+974 5550 5301',
                locationMapLink: '',
                maxParticipants: 20,
                availableSeat: 8,
                id: 'mock',
                publishedAt: DateTime.now(),
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
                instructor: Instructor(
                  id: 'mock_inst',
                  name: 'Jane Doe',
                  email: 'jane@example.com',
                  avatar: '',
                ),
                latitude: 25.3548,
                longitude: 51.531,
              )
            : controller.course.value;

        if (!isLoading && courseItem == null) {
          return const Center(child: Text("Course not found"));
        }

        return Skeletonizer(
          enabled: isLoading,
          child: Stack(
            children: [
              _buildBackgroundImage(courseItem),
              Positioned(
                top: 50.h,
                left: 16.w,
                child: ImageTopButton(onTap: () => Get.back()),
              ),
              _buildBookingDetailsSheet(courseItem),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildBackgroundImage(Course? courseItem) {
    final coverImage = courseItem?.imageUrl ?? '';

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: 450.h,
      child: Stack(
        children: [
          AppImage(
            url: coverImage,
            width: AppSize.size.width,
            height: AppSize.size.width,
            fit: BoxFit.cover,
            path: "assets/images/network_placeholder_image.jpg",
          ),
          Container(
            width: AppSize.size.width,
            height: AppSize.size.width,
            color: Colors.black.withValues(alpha: 0.2),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingDetailsSheet(Course? courseItem) {
    const Color sheetBg = Color(0xFFF1E9E0);

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.6,
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
            padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 30.h),
            children: [
              _buildDragHandle(),
              _buildHeaderSection(courseItem),
              SizedBox(height: 10.h),
              _buildLevelTag(courseItem),
              SizedBox(height: 16.h),
              _buildSpotsSection(courseItem),
              SizedBox(height: 24.h),
              _buildInstructorSection(courseItem),
              SizedBox(height: 24.h),
              _buildAboutSection(courseItem),
              SizedBox(height: 20.h),
              _buildDateTimeSection(courseItem),
              SizedBox(height: 24.h),
              _buildLocationSection(courseItem),
              Obx(() {
                if (controller.fromHistory.value == false) {
                  return Column(
                    children: [
                      SizedBox(height: 24.h),
                      CustomElevetedButton(
                        buttonText: 'Book Now',
                        onTap: () {
                          if (courseItem?.id == 'mock') return;
                          controller.bookNow();
                        },
                      ),
                    ],
                  );
                }
                return const SizedBox.shrink();
              }),
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

  Widget _buildHeaderSection(Course? courseItem) {
    const Color brownColor = Color(0xFF6B5345);
    final gender = courseItem?.gender ?? '';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                courseItem?.title ?? '',
                style: AppTextStyles.bold(22, color: brownColor),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                if (gender.toLowerCase() == 'male' ||
                    gender.toLowerCase() == 'both')
                  Icon(Icons.male_outlined, size: 24.r, color: brownColor),
                if (gender.toLowerCase() == 'female' ||
                    gender.toLowerCase() == 'both')
                  Icon(Icons.female_outlined, size: 24.r, color: brownColor),
              ],
            ),
            Text(
              controller.isLoading.value
                  ? 'QAR ${courseItem?.price}'
                  : controller.displayPrice.value,
              style: AppTextStyles.bold(24, color: brownColor),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLevelTag(Course? courseItem) {
    const Color brownColor = Color(0xFF6B5345);
    final level = courseItem?.difficulty ?? '';
    final isFree = (courseItem?.price ?? 0.0) == 0.0;

    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          if (level.isNotEmpty)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: const Color(0xFFE5D6C9),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                level,
                style: AppTextStyles.medium(12, color: brownColor),
              ),
            ),
          if (isFree)
            Padding(
              padding: EdgeInsets.only(left: 10.w),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFE5D6C9),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  'Membership',
                  style: AppTextStyles.medium(12, color: brownColor),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSpotsSection(Course? courseItem) {
    final available = courseItem?.availableSeat ?? 0;
    final max = courseItem?.maxParticipants ?? 1;
    final percentage = max > 0 ? (max - available) / max : 0.0;

    return SizedBox(
      width: 100.w,
      child: AvailableSpotsIndicator(
        availableSeats: available,
        progress: percentage,
      ),
    );
  }

  Widget _buildInstructorSection(Course? courseItem) {
    const Color brownColor = Color(0xFF6B5345);
    final instructor = courseItem?.instructor;
    final name = instructor?.name ?? '';
    final image = instructor?.avatar ?? '';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipOval(
          child: AppImage(
            url: image,
            path: "assets/images/network_placeholder_image.jpg",
            width: 52.r,
            height: 52.r,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Instructor',
                style: AppTextStyles.regular(
                  10,
                  color: brownColor.withValues(alpha: 0.6),
                ),
              ),
              Text(name, style: AppTextStyles.medium(18, color: brownColor)),
            ],
          ),
        ),
        GestureDetector(
          onTap: () async {
            if (courseItem?.id == 'mock') return;
            final result = await Get.toNamed(
              Routes.courseInstructorDetails,
              arguments: courseItem?.instructor.id,
            );
            if (result != null && result is String) {
              controller.refreshData(result);
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            margin: const EdgeInsets.only(left: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF6B5345),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Text(
              'View Profile',
              style: AppTextStyles.bold12.apply(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAboutSection(Course? courseItem) {
    const Color brownColor = Color(0xFF6B5345);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('About Course', style: AppTextStyles.bold(18, color: brownColor)),
        SizedBox(height: 12.h),
        Obx(() {
          final desc = courseItem?.description ?? '';
          final expanded = controller.isAboutExpanded.value;
          final half = desc.length ~/ 2;
          final showFull = expanded || desc.length <= half;

          return GestureDetector(
            onTap: () => controller.isAboutExpanded.value =
                !controller.isAboutExpanded.value,
            child: RichText(
              text: TextSpan(
                style: AppTextStyles.regular(
                  14,
                  color: brownColor.withValues(alpha: 0.8),
                ),
                children: [
                  TextSpan(
                    text: showFull ? desc : '${desc.substring(0, half)}... ',
                  ),
                  TextSpan(
                    text: expanded ? '  See less' : '  See more',
                    style: AppTextStyles.bold(14, color: brownColor),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildLocationSection(Course? courseItem) {
    const Color textColor = Color(0xFF6B5345);
    final locationName = courseItem?.location ?? '';
    final mapLink = courseItem?.locationMapLink ?? '';
    final phone = courseItem?.phone ?? '';

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
          if (locationName.isNotEmpty) ...[
            SizedBox(height: 8.h),
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 16.r,
                  color: textColor.withValues(alpha: 0.7),
                ),
                SizedBox(width: 6.w),
                Expanded(
                  child: Text(
                    locationName,
                    style: AppTextStyles.regular(
                      13,
                      color: textColor.withValues(alpha: 0.8),
                    ),
                  ),
                ),
              ],
            ),
          ],
          SizedBox(height: 16.h),
          _buildMapPreview(courseItem),
          SizedBox(height: 16.h),
          _buildLocationButtons(phone: phone, mapLink: mapLink),
        ],
      ),
    );
  }

  Widget _buildMapPreview(Course? courseItem) {
    final lat = courseItem?.latitude;
    final lng = courseItem?.longitude;

    if (lat == null || lng == null) {
      return Container(
        height: 160.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFEFEBE9),
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: const Center(
          child: Text(
            'Map view not available',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        Get.to(
          () => FullScreenMapView(
            title: courseItem?.location ?? 'Location',
            latitude: lat,
            longitude: lng,
          ),
        );
      },
      child: Container(
        height: 160.h,
        width: double.infinity,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.r)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.r),
          child: AbsorbPointer(
            child: FlutterMap(
              options: MapOptions(
                initialCenter: LatLng(lat, lng),
                initialZoom: 15.0,
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.none,
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://mt1.google.com/vt/lyrs=m&hl=en&x={x}&y={y}&z={z}',
                  userAgentPackageName: 'com.example.george',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: LatLng(lat, lng),
                      width: 50.r,
                      height: 50.r,
                      child: Icon(
                        Icons.location_on,
                        color: const Color(0xFFC62828),
                        size: 36.r,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLocationButtons({
    required String phone,
    required String mapLink,
  }) {
    const Color brownColor = Color(0xFF6B5345);

    return Row(
      children: [
        // Call Studio
        Expanded(
          child: GestureDetector(
            onTap: () async {
              makePhoneCall(phone.isNotEmpty ? phone : '+974 5550 5301');
            },
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
        ),
        SizedBox(width: 12.w),
        // WhatsApp
        Expanded(
          child: GestureDetector(
            onTap: () async {
              openWhatsApp(phone.isNotEmpty ? phone : '+974 5550 5301');
            },
            child: Container(
              height: 50.h,
              decoration: BoxDecoration(
                color: brownColor,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    ImagePath.whatappButton,
                    height: 30.r,
                    width: 30.r,
                  ),
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
        ),
      ],
    );
  }

  Widget _buildDateTimeSection(Course? courseItem) {
    final scheduledAt = courseItem?.scheduledAt;
    if (scheduledAt == null) return const SizedBox.shrink();

    final localStart = scheduledAt.toQatarTime();
    final localEnd = courseItem?.endDate?.toQatarTime();

    const Color brownColor = Color(0xFF6B5345);

    if (localEnd == null ||
        (localStart.year == localEnd.year &&
            localStart.month == localEnd.month &&
            localStart.day == localEnd.day)) {
      // Same day -> show Time range and Date
      final durationStr = courseItem?.duration ?? '';

      // Parse duration minutes (e.g. "60 Mins" -> 60)
      int durationMinutes = 0;
      if (durationStr.toLowerCase().contains('hour') ||
          durationStr.toLowerCase().contains('hr')) {
        final regex = RegExp(r'(\d+)');
        final match = regex.firstMatch(durationStr);
        if (match != null) {
          durationMinutes = int.parse(match.group(1)!) * 60;
        }
      } else {
        final regex = RegExp(r'(\d+)');
        final match = regex.firstMatch(durationStr);
        if (match != null) {
          durationMinutes = int.parse(match.group(1)!);
        }
      }

      final endTime = localStart.add(Duration(minutes: durationMinutes));

      final timeFormat = DateFormat('h:mm a');
      final dateFormat = DateFormat('MMMM d, yyyy');

      final startTimeStr = timeFormat.format(localStart);
      final endTimeStr = timeFormat.format(endTime);
      final dateStr = dateFormat.format(localStart);

      return FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.watch_later_outlined, size: 20, color: brownColor),
            const SizedBox(width: 6),
            Text(
              '$startTimeStr - $endTimeStr',
              style: AppTextStyles.medium(14, color: brownColor),
            ),
            const SizedBox(width: 16),
            Icon(Icons.calendar_month_outlined, size: 20, color: brownColor),
            const SizedBox(width: 6),
            Text(dateStr, style: AppTextStyles.medium(14, color: brownColor)),
          ],
        ),
      );
    } else {
      // Different days -> show Date range only
      final dateFormat = DateFormat('MMMM d, yyyy');
      final startStr = dateFormat.format(localStart);
      final endStr = dateFormat.format(localEnd);

      return Row(
        children: [
          Icon(Icons.calendar_month_outlined, size: 22.r, color: brownColor),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              '$startStr - $endStr',
              style: AppTextStyles.medium(14, color: brownColor),
            ),
          ),
        ],
      );
    }
  }
}
