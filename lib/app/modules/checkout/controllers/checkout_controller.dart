import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../../../models/product_details_model.dart';
import '../../../../models/class_data.dart';
import '../../../../repository/wallet_repository.dart';
import '../../../../repository/booking_repository.dart';
import '../../../utils/app_log.dart';
import '../../../widgets/snack_bar/app_snack_bar.dart';
import '../../wallet/controllers/wallet_controller.dart';
import '../../memberships/controllers/memberships_controller.dart';
import '../../courses/controllers/courses_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../notifications/controllers/notifications_controller.dart';
import '../../../routes/app_pages.dart';

class CheckoutController extends GetxController {
  ProductDetailsModel? product;

  final selectedPaymentMethod = 0.obs;
  final availablePackages = <AvailablePackage>[].obs;

  final cartTotal = "".obs;
  final itemName = "".obs;
  final isFromShop = false.obs;
  final fromMembership = false.obs;
  final fromPackage = false.obs;
  final shouldHideSuggestions = false.obs;

  final checkoutType =
      "".obs; // 'class', 'course', 'membership', 'shop', 'package'
  final instructorName = "".obs;
  final duration = "".obs;
  final location = "".obs;
  final scheduledAt = Rxn<DateTime>();
  final validity = "".obs;
  final subtitle = "".obs;
  final imageUrl = "".obs;

  final classId = "".obs;
  final courseId = "".obs;
  final membershipPlanId = "".obs;
  final packageId = "".obs;
  final walletBalance = 0.0.obs;
  final isPaying = false.obs;
  final autoRenew = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is Map) {
      final args = Get.arguments as Map;
      if (args.containsKey('product')) {
        product = args['product'];
        checkoutType.value = 'shop';
        imageUrl.value = product?.thumbnail ?? "";
      } else {
        checkoutType.value =
            args['type'] ??
            (args['fromMembership'] == true
                ? 'membership'
                : (args['fromPackage'] == true ? 'package' : ''));
        imageUrl.value = args['imageUrl'] ?? "";
      }
      itemName.value = args['title'] ?? args['name'] ?? args['itemName'] ?? "";
      cartTotal.value = args['price'] ?? args['itemPrice'] ?? "QAR 0";
      isFromShop.value = args['isFromShop'] ?? (checkoutType.value == 'shop');
      fromMembership.value =
          args['fromMembership'] ?? (checkoutType.value == 'membership');
      fromPackage.value =
          args['fromPackage'] ??
          (checkoutType.value == 'package' || checkoutType.value == 'Package');

      instructorName.value = args['instructor'] ?? "";
      duration.value = args['duration'] ?? "";
      location.value = args['location'] ?? "";
      validity.value = args['validity'] ?? "";
      subtitle.value = args['subtitle'] ?? "";

      if (args['scheduledAt'] is DateTime) {
        scheduledAt.value = args['scheduledAt'];
      } else if (args['scheduledAt'] is String) {
        scheduledAt.value = DateTime.tryParse(args['scheduledAt']);
      }

      if (args.containsKey('class_id')) {
        classId.value = args['class_id'] ?? "";
      }

      if (args.containsKey('course_id')) {
        courseId.value = args['course_id'] ?? "";
      }

      if (args.containsKey('membership_plan_id')) {
        membershipPlanId.value = args['membership_plan_id'] ?? "";
      }

      if (args.containsKey('package_id')) {
        packageId.value = args['package_id'] ?? "";
      }

      if (args.containsKey('auto_renew')) {
        autoRenew.value = args['auto_renew'] ?? false;
      }

      if (args.containsKey('available_packages')) {
        final pkgs = args['available_packages'];
        if (pkgs is List<AvailablePackage>) {
          availablePackages.value = pkgs;
        } else if (pkgs is List) {
          availablePackages.value = pkgs.cast<AvailablePackage>();
        }
      }

      // Hide suggestions ONLY if coming from a previous checkout's suggested list
      shouldHideSuggestions.value = args['isFromSuggestions'] ?? false;
    } else {
      cartTotal.value = "QAR 970";
    }

    final type = checkoutType.value.toLowerCase();
    if (type == 'membership' || type == 'package') {
      if (!Get.isRegistered<MembershipsController>()) {
        Get.put(MembershipsController());
      }
    } else if (type == 'course') {
      if (!Get.isRegistered<CoursesController>()) {
        Get.put(CoursesController());
      }
    } else if (type == 'class') {
      if (!Get.isRegistered<HomeController>()) {
        Get.put(HomeController());
      }
    }

    fetchWalletBalance();
  }

  Future<void> fetchWalletBalance() async {
    try {
      final res = await WalletRepository.instance.getBalance();
      if (res != null) {
        walletBalance.value = res.balance;
      }
    } catch (e) {
      errorLog('fetchWalletBalance checkout controller', e);
    }
  }

  final firstNameCtrl = TextEditingController();
  final lastNameCtrl = TextEditingController();
  final routingNumberCtrl = TextEditingController();
  final accountNumberCtrl = TextEditingController();
  final verifyAccountNumberCtrl = TextEditingController();

  @override
  void onClose() {
    firstNameCtrl.dispose();
    lastNameCtrl.dispose();
    routingNumberCtrl.dispose();
    accountNumberCtrl.dispose();
    verifyAccountNumberCtrl.dispose();
    super.onClose();
  }

  final suggestedMemberships = <Map<String, dynamic>>[
    {
      "title": "3 month Membership",
      "price": "QAR 2750",
      "validity": "Valid for 3 months",
      "autoRenew": false,
    },
    {
      "title": "10 Class Pack",
      "price": "QAR 750",
      "validity": "Valid for 3 months",
      "autoRenew": false,
    },
  ].obs;

  void toggleAutoRenew(int index) {
    var item = suggestedMemberships[index];
    item['autoRenew'] = !item['autoRenew'];
    suggestedMemberships[index] = item;
  }

  void selectPaymentMethod(int index) {
    selectedPaymentMethod.value = index;
  }

  void _showInsufficientFundsDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () => Navigator.pop(Get.context!),
                  child: const Icon(Icons.close, color: Colors.brown),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Not enough funds",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF5D4037),
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Please top up your wallet first",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF5D4037),
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(Get.context!),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5D4037),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    "Close",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }

  Future<void> processPayment() async {
    if (selectedPaymentMethod.value == 0) {
      double priceVal = 0.0;
      try {
        final cleanPrice = cartTotal.value.replaceAll(RegExp(r'[^0-9.]'), '');
        priceVal = double.tryParse(cleanPrice) ?? 0.0;
      } catch (_) {}

      if (walletBalance.value < priceVal) {
        _showInsufficientFundsDialog();
        return;
      }
    }

    final isCourse = checkoutType.value == 'course';
    final isShop = checkoutType.value == 'shop';
    final isMembership =
        checkoutType.value == 'membership' || fromMembership.value;
    final isPackage = checkoutType.value == 'package' || fromPackage.value;

    if (isShop) {
      if (product == null || product!.id.isEmpty) {
        AppSnackBar.error('Error: Product is missing.');
        return;
      }
    } else if (isMembership) {
      if (membershipPlanId.value.isEmpty) {
        AppSnackBar.error('Error: Membership Plan ID is missing.');
        return;
      }
    } else if (isPackage) {
      if (packageId.value.isEmpty) {
        AppSnackBar.error('Error: Package ID is missing.');
        return;
      }
    } else if (isCourse) {
      if (courseId.value.isEmpty) {
        AppSnackBar.error('Error: Course ID is missing.');
        return;
      }
    } else {
      if (classId.value.isEmpty) {
        AppSnackBar.error('Error: Class ID is missing.');
        return;
      }
    }

    isPaying.value = true;
    try {
      // Show loading dialog
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(color: Color(0xff5d4037)),
        ),
        barrierDismissible: false,
      );

      final isPackagePayment = selectedPaymentMethod.value >= 2;
      String? selectedMembershipId;
      if (isPackagePayment) {
        final pkgIndex = selectedPaymentMethod.value - 2;
        if (pkgIndex < availablePackages.length) {
          selectedMembershipId = availablePackages[pkgIndex].membershipId;
        }
      }

      final paymentMethod = isPackagePayment
          ? 'PACKAGE'
          : (selectedPaymentMethod.value == 1 ? 'GATEWAY' : 'WALLET');

      final Map<String, dynamic>? response;
      if (isShop) {
        response = await BookingRepository.instance.checkoutOrder(
          productId: product!.id,
          quantity: product!.quantity,
          paymentMethod: paymentMethod,
        );
      } else if (isMembership) {
        response = await BookingRepository.instance.buyMembership(
          membershipPlanId: membershipPlanId.value,
          paymentMethod: paymentMethod,
          autoRenew: autoRenew.value,
        );
      } else if (isPackage) {
        response = await BookingRepository.instance.buyPackage(
          packageId: packageId.value,
          paymentMethod: paymentMethod,
          autoRenew: autoRenew.value,
        );
      } else if (isCourse) {
        response = await BookingRepository.instance.payCourse(
          courseId: courseId.value,
          paymentMethod: paymentMethod,
        );
      } else {
        response = await BookingRepository.instance.payBooking(
          classId: classId.value,
          paymentMethod: paymentMethod,
          membershipId: selectedMembershipId,
        );
      }

      if (Get.isDialogOpen == true) {
        Navigator.pop(Get.context!);
      }

      if (response != null) {
        final status = response['status'] ?? '';
        final message = response['message'] ?? 'Booking processed';

        if ((paymentMethod == 'WALLET' || paymentMethod == 'PACKAGE') &&
            (status == 'CONFIRMED' || status == 'PAID' || status == 'ACTIVE')) {
          AppSnackBar.success(message);
          if (Get.isRegistered<HomeController>()) {
            final homeCtrl = Get.find<HomeController>();
            homeCtrl.fetchBookedItems();
            homeCtrl.fetchClasses(homeCtrl.currentDate.value);
          }
          if (Get.isRegistered<NotificationsController>()) {
            Get.find<NotificationsController>().fetchNotifications();
          }
          Get.toNamed(
            Routes.bookingConfirmed,
            arguments: {
              'message': message,
              'fromMembership': fromMembership.value,
              'fromPackage': fromPackage.value,
            },
          );
        } else if (paymentMethod == 'GATEWAY' &&
            (status == 'PENDING' ||
                status == 'CONFIRMED' ||
                status == 'ACTIVE')) {
          final paymentUrl = response['payment_url'] ?? '';
          if (paymentUrl.isNotEmpty) {
            await _openPaymentBrowser(paymentUrl);
          } else {
            if (status == 'CONFIRMED' || status == 'ACTIVE') {
              AppSnackBar.success(message);
              if (Get.isRegistered<HomeController>()) {
                final homeCtrl = Get.find<HomeController>();
                homeCtrl.fetchBookedItems();
                homeCtrl.fetchClasses(homeCtrl.currentDate.value);
              }
              if (Get.isRegistered<NotificationsController>()) {
                Get.find<NotificationsController>().fetchNotifications();
              }
              Get.toNamed(
                Routes.bookingConfirmed,
                arguments: {
                  'message': message,
                  'fromMembership': fromMembership.value,
                  'fromPackage': fromPackage.value,
                },
              );
            } else {
              AppSnackBar.error('Payment URL not found in gateway response.');
            }
          }
        } else {
          AppSnackBar.error(message);
        }
      } else {
        // Handled by ApiServices
      }
    } catch (e) {
      if (Get.isDialogOpen == true) {
        Navigator.pop(Get.context!);
      }
      AppSnackBar.error('Payment error: $e');
    } finally {
      isPaying.value = false;
    }
  }

  Future<void> _openPaymentBrowser(String url) async {
    // Close previous active browser if any
    if (WalletController.activeBrowser != null) {
      try {
        await WalletController.activeBrowser?.close();
      } catch (_) {}
    }

    final MyChromeSafariBrowser browser = MyChromeSafariBrowser();
    WalletController.activeBrowser = browser;

    appLog("[CheckoutController] Opening booking payment browser: $url");

    await browser.open(
      url: WebUri(url),
      settings: ChromeSafariBrowserSettings(
        shareState: CustomTabsShareState.SHARE_STATE_OFF,
        barCollapsingEnabled: true,
        isSingleInstance: true,
      ),
    );
  }
}
