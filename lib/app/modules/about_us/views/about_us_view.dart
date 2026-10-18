import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../../models/about_us_model.dart';
import '../../../utils/app_size.dart';
import '../../../widgets/app_image/app_image.dart';
import '../../../widgets/image_top_button.dart';
import '../../../widgets/full_screen_map_view.dart';
import 'package:get/get.dart';

import '../../../data/app_colors.dart';
import '../../../data/app_text_styles.dart';
import '../../../methodes/call_studio.dart';
import '../../../methodes/call_whatsapp.dart';
import '../controllers/about_us_controller.dart';

class AboutUsView extends GetView<AboutUsController> {
  const AboutUsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Obx(() {
        final isLoading = controller.isLoading.value;
        final aboutUs = isLoading
            ? AboutModel(
                activeMembers: 1200,
                totalClasses: 45,
                totalInstructors: 15,
                ourStory:
                    'This is a long mockup of our story paragraph that displays placeholder text for about us section layout. It shows how the layout looks when rendering the actual story content from the api.',
                ourMission:
                    'Our mission is to help people live healthy lives and maintain a balanced mind, body, and spirit by offering premium yoga, training, and fitness classes.',
                location: 'Main Studio, West Bay, Doha, Qatar',
                locationMapLink: '',
                latitude: 25.3548,
                longitude: 51.531,
                email: 'studio@inara.com',
                phoneNumber: '+974 5550 5301',
                instagramAccount: '@inara_studio',
                facebookPage: '@inara_studio',
                websiteUrl: 'https://inara.com',
                id: 'mock',
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              )
            : controller.aboutUs.value;

        final ourStory = aboutUs?.ourStory ?? 'Nothing Added';
        final ourMission = aboutUs?.ourMission ?? 'Nothing Added';
        final location = aboutUs?.location ?? 'Nothing location Added';
        final email = aboutUs?.email ?? 'Nothing email Added';
        final phone = aboutUs?.phoneNumber ?? 'Nothing number Added';
        final instaId = aboutUs?.instagramAccount ?? 'Nothing Id Added';
        final activeMember = aboutUs?.activeMembers ?? 0;
        final totalClasses = aboutUs?.totalClasses ?? 0;
        final totalInstructor = aboutUs?.totalInstructors ?? 0;

        return Skeletonizer(
          enabled: isLoading,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStatsRow(
                        activeMember: activeMember,
                        instructor: totalInstructor,
                        totalClasses: totalClasses,
                      ),
                      Text(
                        'About Us',
                        style: AppTextStyles.semiBold24.apply(
                          color: const Color(0xFF6D4C41),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      _buildSectionTitle("Our story"),
                      SizedBox(height: 8.h),
                      Text(
                        ourStory,
                        style: AppTextStyles.regular(14).copyWith(
                          color: const Color(0xFF6D4C41).withValues(alpha: 0.8),
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      _buildSectionTitle("Our Mission"),
                      SizedBox(height: 8.h),
                      Text(
                        ourMission,
                        style: AppTextStyles.regular(14).copyWith(
                          color: const Color(0xFF6D4C41).withValues(alpha: 0.8),
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: 24.h),

                      _buildLocationCard(aboutUs),
                      SizedBox(height: 24.h),
                      _buildContactInfo(
                        email: email,
                        id: instaId,
                        location: location,
                        phone: phone,
                      ),
                      SizedBox(height: 40.h),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildHeader() {
    return Stack(
      children: [
        AppImage(
          url: "https://picsum.photos/seed/yoga_pose/800/600",
          width: AppSize.size.width,
          height: 300.h,
          fit: BoxFit.cover,
          path: "assets/images/network_placeholder_image.jpg",
        ),
        Container(
          width: AppSize.size.width,
          height: 300.h,
          color: Colors.black.withValues(alpha: 0.2),
        ),
        Positioned(
          top: 50.h,
          left: 16.w,
          child: ImageTopButton(onTap: () => Get.back()),
        ),
      ],
    );
  }

  Widget _buildStatsRow({
    required int activeMember,
    required int totalClasses,
    required int instructor,
  }) {
    // The image shows stats cards OVERLAPPING the header image slightly or just below it.
    // The provided design has them floating a bit up. For simplicity I'll put them below the header with a negative offset translation if needed,
    // or just plain below. The image shows them cleanly separated in a row.
    // Actually looking closely at the image, the stats are IN A ROW below the header.
    // Wait, the reference image has stats cards with white background, rounded corners.
    return Transform.translate(
      offset: Offset(0, -40.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStatCard(activeMember, "Active members"),
          _buildStatCard(totalClasses, "Classes"),
          _buildStatCard(instructor, "Instructors"),
        ],
      ),
    );
  }

  Widget _buildStatCard(int value, String label) {
    return Container(
      width: 100.w,
      height: 80.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value.toString(),
            style: AppTextStyles.bold(
              20,
            ).copyWith(color: const Color(0xFF6D4C41)),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: AppTextStyles.regular(
              10,
            ).copyWith(color: const Color(0xFF6D4C41).withValues(alpha: 0.7)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.bold(18).copyWith(color: const Color(0xFF6D4C41)),
    );
  }

  Widget _buildLocationCard(AboutModel? aboutUs) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFD7CCC8).withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Location",
            style: AppTextStyles.bold(
              16,
            ).copyWith(color: const Color(0xFF6D4C41)),
          ),
          SizedBox(height: 12.h),
          _buildMapPreview(aboutUs),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  onPressed: () {
                    final phone = controller.aboutUs.value?.phoneNumber;
                    makePhoneCall(
                      phone != null && phone.isNotEmpty
                          ? phone
                          : '+974 5550 5301',
                    );
                  },
                  "Call Studio",
                  Icons.call,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildActionButton(
                  "WhatsApp",
                  Icons.chat_bubble_outline,
                  onPressed: () {
                    final phone = controller.aboutUs.value?.phoneNumber;
                    openWhatsApp(
                      phone != null && phone.isNotEmpty
                          ? phone
                          : '+974 5550 5301',
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMapPreview(AboutModel? aboutUs) {
    final lat = aboutUs?.latitude;
    final lng = aboutUs?.longitude;

    if (lat == null || lng == null) {
      return Container(
        height: 150.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFEFEBE9),
          borderRadius: BorderRadius.circular(12.r),
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
            title: aboutUs?.location ?? 'Location',
            latitude: lat,
            longitude: lng,
          ),
        );
      },
      child: Container(
        height: 150.h,
        width: double.infinity,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.r)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
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

  Widget _buildActionButton(
    String label,
    IconData icon, {
    VoidCallback? onPressed,
  }) {
    // WhatsApp button is dark in image, Call is light outline/transparent?
    // Actually both look different.
    // Call Studio: Solid outline? Or solid background light brown?
    // WhatsApp: Dark brown solid.
    // Let's approximate based on image.
    final isPrimary = label == "WhatsApp";
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary
            ? const Color(0xFF6D4C41)
            : Colors.transparent,
        side: isPrimary ? null : const BorderSide(color: Color(0xFF6D4C41)),
        elevation: 0,
        padding: EdgeInsets.symmetric(vertical: 12.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 18.sp,
            color: isPrimary ? Colors.white : const Color(0xFF6D4C41),
          ),
          SizedBox(width: 8.w),
          Text(
            label,
            style: AppTextStyles.medium(14).copyWith(
              color: isPrimary ? Colors.white : const Color(0xFF6D4C41),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo({
    required String location,
    required String email,
    required String phone,
    required String id,
  }) {
    return Column(
      children: [
        _buildContactRow(Icons.location_on_outlined, location),
        SizedBox(height: 12.h),
        _buildContactRow(Icons.email_outlined, email),
        SizedBox(height: 12.h),
        _buildContactRow(
          Icons.phone_outlined,
          phone,
        ), // Using generic phone icon
        SizedBox(height: 12.h),
        _buildContactRow(
          Icons.camera_alt_outlined,
          id,
        ), // Instagram icon approximation
      ],
    );
  }

  Widget _buildContactRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20.sp, color: const Color(0xFF6D4C41)),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.regular(
              14,
            ).copyWith(color: const Color(0xFF6D4C41).withValues(alpha: 0.8)),
          ),
        ),
      ],
    );
  }
}
