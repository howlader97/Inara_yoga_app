import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookingDetailsController extends GetxController {
  final RxBool isInitialized = false.obs;
  final RxString imageUrl = ''.obs;
  final RxString instructorImage = ''.obs;
  final RxString mapImage = ''.obs;
  final RxString title = 'No title added'.obs;
  final RxString price = 'N/A'.obs;
  final RxString instructorName = 'No name added'.obs;

  @override
  void onInit() {
    super.onInit();

    // Safely get arguments or use defaults
    final args = Get.arguments as Map<String, dynamic>?;

    if (args != null) {
      imageUrl.value = args['imageUrl'] ?? imageUrl.value;
      instructorImage.value = args['instructorImage'] ?? instructorImage.value;
      mapImage.value = args['mapImage'] ?? mapImage.value;
      title.value = args['title'] ?? title.value;
      price.value = args['price'] ?? price.value;
      instructorName.value = args['instructorName'] ?? instructorName.value;
    }

    Future.delayed(const Duration(milliseconds: 300), () {
      isInitialized.value = true;
    });
  }

  void showCancelDialog(BuildContext context) {
    _showCancelConfirmationDialog(context);
  }

  void _showCancelConfirmationDialog(BuildContext context) {
    _showCustomDialog(
      context,
      title: 'Cancel Booking?',
      subtitle: 'Do you really want to cancel this booking?',
      onYes: () => _showCancellationRuleDialog(context),
    );
  }

  void _showCancellationRuleDialog(BuildContext context) {
    _showCustomDialog(
      context,
      title: 'Cancellation Rule',
      subtitle:
          'Cancellations made within 3 hours of the class start time are non refundable.',
      onYes: () => _showClassCancelledDialog(context),
    );
  }

  void _showClassCancelledDialog(BuildContext context) {
    _showCustomDialog(
      context,
      title: 'Class Cancelled',
      subtitle:
          'Your class has been cancelled successfully. If you need any help, feel free to contact us.',
      onYes: () => Get.back(),
    );
  }

  void _showCustomDialog(
    BuildContext context, {
    required String title,
    required String subtitle,
    required VoidCallback onYes,
  }) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () => Get.back(),
                  child: const Icon(Icons.close, size: 24, color: Colors.grey),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.cancel_outlined,
                  color: Colors.red,
                  size: 40,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6B5345),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Get.back(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFDCC8B8),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        'No',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        onYes();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6B5345),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        'Yes',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
