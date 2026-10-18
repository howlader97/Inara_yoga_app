import 'package:flutter/material.dart';
import '../../../../models/all_courses_model.dart';
import '../../../../models/class_data.dart';
import 'package:get/get.dart';
import '../../../../repository/booking_repository.dart';
import '../../../../repository/course_repository.dart';
import '../../../../repository/home_repository.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/app_log.dart';
import '../../../widgets/snack_bar/app_snack_bar.dart';
import '../../home/controllers/home_controller.dart';

class CourseDetailsController extends GetxController {
  final CourseRepository _service = CourseRepository.instance;
  final HomeRepository _homeRepository = HomeRepository.instance;
  final RxBool isLoading = true.obs;
  final Rxn<Course> course = Rxn<Course>();
  final RxBool isAboutExpanded = false.obs;
  final RxBool fromHistory = false.obs;
  final RxString displayPrice = ''.obs;
  final RxString id = ''.obs;
  Rxn<ClassModel> classById = Rxn<ClassModel>();

  @override
  void onInit() {
    super.onInit();
    _loadArguments();
    _fetchCourseDetails();
  }

  void _loadArguments() {
    final args = Get.arguments;
    if (args is String) {
      id.value = args;
    } else if (args is Map<String, dynamic>) {
      id.value = args['id']?.toString() ?? '';
      fromHistory.value = args['fromHistory'] ?? false;
      if (args['price'] != null) {
        displayPrice.value = args['price'];
      }
    }
  }

  void refreshData(String newId) {
    if (newId.isNotEmpty && newId != id.value) {
      id.value = newId;
      displayPrice.value = '';
      _fetchCourseDetails();
    }
  }

  String? get _courseId {
    if (id.value.isNotEmpty) return id.value;
    final args = Get.arguments;
    if (args is String) return args;
    if (args is Map<String, dynamic>) return args['id']?.toString();
    return null;
  }

  Future<void> _fetchCourseDetails() async {
    try {
      isLoading(true);

      final id = _courseId;
      if (id == null || id.isEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.offAndToNamed(Routes.notFoundScreen);
        });
        return;
      }

      final result = await _service.getCourseDetails(id);

      if (result != null) {
        course.value = result;
        if (displayPrice.value.isEmpty) {
          displayPrice.value = 'QAR ${result.price.toStringAsFixed(0)}';
        }
      }
    } catch (e) {
      errorLog("CourseDetailsController Error:", e);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAndToNamed(Routes.errorScreen);
      });
    } finally {
      isLoading(false);
    }
  }

  double get seatPercentage {
    final c = course.value;
    if (c == null || c.maxParticipants == 0) return 0.0;
    return ((c.maxParticipants - c.availableSeat) / c.maxParticipants).clamp(
      0.0,
      1.0,
    );
  }

  String get formattedDate {
    final date = course.value?.scheduledAt;
    if (date == null) return '—';
    return "${date.day}-${date.month}-${date.year}";
  }

  Future<void> bookNow() async {
    final homeController = Get.find<HomeController>();
    // If price is QAR 0, book directly
    if (displayPrice.value == 'QAR 0' || displayPrice.value == '0') {
      try {
        Get.dialog(
          const Center(
            child: CircularProgressIndicator(color: Color(0xff5d4037)),
          ),
          barrierDismissible: false,
        );

        final response = await BookingRepository.instance.payCourse(
          courseId: course.value?.id ?? '',
          paymentMethod: 'WALLET',
        );

        if (Get.isDialogOpen == true) {
          Navigator.pop(Get.context!);
        }

        if (response != null) {
          final status = response['status'] ?? '';
          final message = response['message'] ?? 'Booking processed';

          if (status == 'CONFIRMED' || status == 'PAID' || status == 'ACTIVE') {
            AppSnackBar.success(message);
            final result = await Get.toNamed(
              Routes.bookingConfirmed,
              arguments: {
                'message': message,
                'fromMembership': false,
                'fromPackage': false,
              },
            );
            if (result != null && result is String) {
              refreshData(result);
            }
          } else {
            AppSnackBar.error(message);
          }
        }
      } catch (e) {
        if (Get.isDialogOpen == true) {
          Navigator.pop(Get.context!);
        }
        AppSnackBar.error('Booking error: $e');
      }
      return;
    }

    if (homeController.sessionsLeft.value > 0) {
      _showPaymentMethodDialog();
    } else {
      final result = await Get.toNamed(
        Routes.checkout,
        arguments: {
          'course_id': course.value?.id,
          'title': course.value?.title ?? '',
          'price': displayPrice.value,
          'type': 'course',
          'instructor': course.value?.instructor.name ?? '',
          'imageUrl': course.value?.imageUrl ?? '',
          'duration': course.value?.duration ?? '',
          'scheduledAt': course.value?.scheduledAt,
          'location': course.value?.location ?? '',
        },
      );
      if (result != null && result is String) {
        refreshData(result);
      }
    }
  }

  void _showPaymentMethodDialog() {
    // final homeController = Get.find<HomeController>();
    final context = Get.context;
    if (context == null) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Color(0xffF3EFE9),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Select Payment Method",
                style: TextStyle(
                  color: Color(0xFF5D4037),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              // _buildPaymentOption(
              //   title: "Class Pack Session",
              //   subtitle:
              //       "${homeController.sessionsLeft.value} sessions remaining",
              //   icon: Icons.confirmation_number_outlined,
              //   onTap: () {
              //     Navigator.pop(context);
              //     _useClassPackSession();
              //   },
              // ),
              // const SizedBox(height: 16),
              _buildPaymentOption(
                title: "Pay with Wallet / Card",
                subtitle: "Proceed to checkout",
                icon: Icons.payment_outlined,
                onTap: () async {
                  Navigator.pop(context);
                  final result = await Get.toNamed(
                    Routes.checkout,
                    arguments: {
                      'course_id': course.value?.id,
                      'title': course.value?.title ?? '',
                      'price': displayPrice.value,
                      'type': 'course',
                      'instructor': course.value?.instructor.name ?? '',
                      'imageUrl': course.value?.imageUrl ?? '',
                      'duration': course.value?.duration ?? '',
                      'scheduledAt': course.value?.scheduledAt,
                      'location': course.value?.location ?? '',
                    },
                  );
                  if (result != null && result is String) {
                    refreshData(result);
                  }
                },
              ),
              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPaymentOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF6D4C41).withValues(alpha: 0.1),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF6D4C41).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: const Color(0xFF6D4C41)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFF5D4037),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  // void _useClassPackSession() {
  //   final homeController = Get.find<HomeController>();
  //   if (homeController.sessionsLeft.value > 0) {
  //     homeController.sessionsLeft.value -= 1;
  //     _showBookingConfirmation();
  //   }
  // }

  // void _showBookingConfirmation() {
  //   Get.dialog(
  //     Dialog(
  //       backgroundColor: Colors.transparent,
  //       insetPadding: const EdgeInsets.symmetric(horizontal: 40),
  //       child: Container(
  //         padding: const EdgeInsets.all(24),
  //         decoration: BoxDecoration(
  //           color: const Color(0xffF3EFE9),
  //           borderRadius: BorderRadius.circular(24),
  //         ),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             Container(
  //               width: 80,
  //               height: 80,
  //               decoration: const BoxDecoration(
  //                 color: Color(0xFF6D4C41),
  //                 shape: BoxShape.circle,
  //               ),
  //               child: const Icon(
  //                 Icons.check_rounded,
  //                 color: Colors.white,
  //                 size: 50,
  //               ),
  //             ),
  //             const SizedBox(height: 24),
  //             const Text(
  //               "Booking Confirmed!",
  //               textAlign: TextAlign.center,
  //               style: TextStyle(
  //                 color: Color(0xFF5D4037),
  //                 fontSize: 22,
  //                 fontWeight: FontWeight.bold,
  //               ),
  //             ),
  //             const SizedBox(height: 12),
  //             Obx(
  //               () => Text(
  //                 "You have successfully booked\n${course.value?.title ?? ''}",
  //                 textAlign: TextAlign.center,
  //                 style: const TextStyle(
  //                   color: Color(0xFF8D6E63),
  //                   fontSize: 14,
  //                 ),
  //               ),
  //             ),
  //             const SizedBox(height: 32),
  //             SizedBox(
  //               width: double.infinity,
  //               height: 50,
  //               child: ElevatedButton(
  //                 onPressed: () {
  //                   Get.back();
  //                   Get.back();
  //                 },
  //                 style: ElevatedButton.styleFrom(
  //                   backgroundColor: const Color(0xFF6D4C41),
  //                   shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(12),
  //                   ),
  //                   elevation: 0,
  //                 ),
  //                 child: const Text(
  //                   'Back To Home',
  //                   style: TextStyle(
  //                     fontSize: 16,
  //                     fontWeight: FontWeight.bold,
  //                     color: Colors.white,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //     barrierDismissible: false,
  //   );
  // }

  Future<void> fetchClassById(String id) async {
    try {
      isLoading.value = true;

      classById.value = null;

      classById.value = await _homeRepository.fetchClassById(id: id);
    } catch (e) {
      errorLog("fetchClasses", e);
    } finally {
      isLoading.value = false;
    }
  }

  void cancelBooking() => Get.back();
}
