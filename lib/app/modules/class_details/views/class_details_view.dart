import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../../models/class_data.dart';
import '../../../data/image_path.dart';
import '../../../methodes/call_studio.dart';
import '../../../utils/app_size.dart';
import '../../../widgets/custom_progress.dart';
import '../../../widgets/image_top_button.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../utils/duration_formatter.dart';

import '../../../data/app_text_styles.dart';
import '../../../methodes/call_whatsapp.dart';
import '../../../widgets/app_image/app_image.dart';
import '../../../widgets/full_screen_map_view.dart';
import '../controllers/class_details_controller.dart';

class ClassDetailsView extends GetView<ClassDetailsController> {
  const ClassDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        final isLoading = controller.isLoading.value;
        final classItem = isLoading
            ? ClassModel(
                title: 'Hatha Yoga Flow',
                description:
                    'This is a mock yoga class description text that is long enough to cover two lines of details and show how the layout looks in skeleton loading state.',
                type: 'CLASS',
                duration: '60 Mins',
                scheduledAt: DateTime.now(),
                maxParticipants: 20,
                isFree: false,
                id: 'mock',
                status: 'ACTIVE',
                courseId: '',
                instructorId: '',
                order: 1,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
                bookedSeats: 12,
                availableSeats: 8,
                difficulty: 'All Levels',
                gender: 'Both',
                price: 75.0,
                location: 'Main Studio',
                locationMapLink: '',
                phone: '+974 5550 5301',
                instructor: Instructor(
                  id: 'mock_inst',
                  name: 'Jane Doe',
                  email: 'jane@example.com',
                  avatar: '',
                ),
                latitude: 25.3548,
                longitude: 51.531,
              )
            : controller.classByID.value;

        if (!isLoading && classItem == null) {
          return const Center(child: Text("No data found"));
        }

        return Skeletonizer(
          enabled: isLoading,
          child: Stack(
            children: [
              _buildBackgroundImage(classItem),
              Positioned(
                top: 50.h,
                left: 16.w,
                child: ImageTopButton(onTap: () => Get.back()),
              ),
              _buildBookingDetailsSheet(classItem),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildBackgroundImage(ClassModel? classItem) {
    final image = classItem?.imageUrl;
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: 450.h,
      child: Stack(
        children: [
          AppImage(
            url: image,
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

  Widget _buildBookingDetailsSheet(ClassModel? classItem) {
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
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            children: [
              _buildDragHandle(),
              _buildHeaderSection(classItem),
              SizedBox(height: 10.h),
              _buildLevelTag(classItem),
              SizedBox(height: 16.h),
              _buildSpotsSection(classItem),
              SizedBox(height: 24.h),
              _buildInstructorSection(classItem),
              SizedBox(height: 24.h),
              _buildAboutSection(classItem),
              SizedBox(height: 20.h),
              _buildDateTimeSection(classItem),
              SizedBox(height: 24.h),
              _buildLocationSection(classItem),
              // Only show Book Now button if not from history
              if (controller.fromHistory.value == false) ...[
                SizedBox(height: 24.h),
                _buildBookNowButton(),
              ],
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

  Widget _buildHeaderSection(ClassModel? classItem) {
    const Color brownColor = Color(0xFF6B5345);
    final title = classItem?.title;
    final gender = classItem?.gender;
    final classGender = (gender ?? '').trim().toLowerCase();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                title ?? "",
                style: AppTextStyles.bold(20, color: brownColor),
              ),
            ],
          ),
        ),
        SizedBox(width: 10.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                if (classGender == 'male' || classGender == 'both')
                  Icon(Icons.male_outlined, size: 24.r, color: brownColor),
                if (classGender == 'female' || classGender == 'both')
                  Icon(Icons.female_outlined, size: 24.r, color: brownColor),
              ],
            ),
            Text(
              classItem?.coverageType?.toLowerCase() == 'membership'
                  ? "QAR ${(classItem?.effectivePrice ?? 0.0).toStringAsFixed((classItem?.effectivePrice ?? 0.0) % 1 == 0 ? 0 : 1)}"
                  : "QAR ${(classItem?.price ?? 0.0).toStringAsFixed((classItem?.price ?? 0.0) % 1 == 0 ? 0 : 1)}",
              style: AppTextStyles.semiBold24.apply(color: brownColor),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLevelTag(ClassModel? classItem) {
    const Color brownColor = Color(0xFF6B5345);
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: const Color(0xFFE5D6C9),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              classItem?.difficulty ?? '',
              style: AppTextStyles.medium(12, color: brownColor),
            ),
          ),
          Obx(() {
            if (controller.price.value == 'QAR 0') {
              return Padding(
                padding: EdgeInsets.only(left: 10.w),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5D6C9),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    'Membership',
                    style: AppTextStyles.medium(12, color: brownColor),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  Widget _buildSpotsSection(ClassModel? classItem) {
    const Color brownColor = Color(0xFF6B5345);
    final maxParticipants = classItem?.maxParticipants ?? 1;
    final availableSeat = classItem?.availableSeats ?? 0;
    final bookedSeats = maxParticipants - availableSeat;
    double progress = maxParticipants > 0
        ? (bookedSeats / maxParticipants)
        : 0.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Available spots $availableSeat',
          style: AppTextStyles.regular(
            12,
            color: brownColor.withValues(alpha: 0.6),
          ),
        ),
        SizedBox(height: 8.h),
        CustomProgress(
          progress: progress,
          backgroundColor: const Color(0xFFD6C8BE),
          progressColor: brownColor,
        ),
      ],
    );
  }

  Widget _buildInstructorSection(ClassModel? classItem) {
    const Color brownColor = Color(0xFF6B5345);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipOval(
          child: AppImage(
            url: classItem?.instructor.avatar,
            path: "assets/images/network_placeholder_image.jpg",
            width: 52.r,
            height: 52.r,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
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
                classItem?.instructor.name ?? '',
                style: AppTextStyles.medium(18, color: brownColor),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () async {
            if (classItem?.id == 'mock') return;
            final result = await Get.toNamed(
              '/instructor-details',
              arguments: classItem?.instructor.id,
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

  Widget _buildAboutSection(ClassModel? classItem) {
    const Color brownColor = Color(0xFF6B5345);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('About Class', style: AppTextStyles.bold(18, color: brownColor)),
        SizedBox(height: 12.h),
        Obx(() {
          final description = classItem?.description ?? '';
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
                    text: description.isNotEmpty
                        ? controller.isAboutExpanded.value
                              ? description
                              : '${description.substring(0, description.length ~/ 2)}... '
                        : 'No description added.',
                  ),
                  TextSpan(
                    text: controller.isAboutExpanded.value
                        ? 'See less'
                        : 'See more',
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

  Widget _buildLocationSection(ClassModel? classItem) {
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
          _buildMapPreview(classItem),
          SizedBox(height: 16.h),
          _buildLocationButtons(classItem),
        ],
      ),
    );
  }

  Widget _buildMapPreview(ClassModel? classItem) {
    final lat = classItem?.latitude;
    final lng = classItem?.longitude;

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
            title: classItem?.location ?? 'Location',
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

  Widget _buildLocationButtons(ClassModel? classItem) {
    const Color brownColor = Color(0xFF6B5345);
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              final phone = classItem?.phone ?? '';
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
        Expanded(
          child: GestureDetector(
            onTap: () {
              final phone = classItem?.phone ?? '';
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

  Widget _buildDateTimeSection(ClassModel? classItem) {
    if (classItem == null) return const SizedBox.shrink();

    final scheduledAt = classItem.scheduledAt.toQatarTime();
    final durationStr = classItem.duration;

    // Parse duration minutes (e.g. "60 Mins" -> 60, "3600" (seconds) -> 60)
    int durationMinutes = 0;
    final lowerStr = durationStr.toLowerCase();
    int parsedValue = 0;
    final regex = RegExp(r'(\d+)');
    final match = regex.firstMatch(durationStr);
    if (match != null) {
      parsedValue = int.parse(match.group(1)!);
    }

    if (lowerStr.contains('hour') || lowerStr.contains('hr')) {
      durationMinutes = parsedValue * 60;
    } else if (lowerStr.contains('min')) {
      durationMinutes = parsedValue;
    } else {
      // Raw number: treat as seconds
      durationMinutes = parsedValue ~/ 60;
    }

    final endTime = scheduledAt.add(Duration(minutes: durationMinutes));

    final timeFormat = DateFormat('h:mm a');
    final dateFormat = DateFormat('MMMM d, yyyy');

    final startTimeStr = timeFormat.format(scheduledAt);
    final endTimeStr = timeFormat.format(endTime);
    final dateStr = dateFormat.format(scheduledAt);

    const Color brownColor = Color(0xFF6B5345);

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
  }

  Widget _buildBookNowButton() {
    return SizedBox(
      width: double.infinity,
      height: 55.h,
      child: ElevatedButton(
        onPressed: () {
          if (controller.classByID.value == null) return;
          controller.bookNow();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6B5345),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r),
          ),
          elevation: 0,
        ),
        child: Text(
          'Book Now',
          style: AppTextStyles.bold(18, color: Colors.white),
        ),
      ),
    );
  }
}
