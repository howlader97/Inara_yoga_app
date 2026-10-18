import 'dart:async';
import 'package:get/get.dart';
import 'package:app_links/app_links.dart';
import '../app/routes/app_pages.dart';
import '../app/utils/app_log.dart';
import '../app/modules/wallet/controllers/wallet_controller.dart';
import '../app/widgets/snack_bar/app_snack_bar.dart';
import 'storage_services/get_storage_services.dart';

class DeepLinkService extends GetxService {
  static DeepLinkService get instance => Get.find();

  final _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;

  Future<DeepLinkService> init() async {
    appLog("[DeepLinkService] Initializing DeepLinkService...");

    // 1. Handle the initial link if the app was opened from a terminated state
    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        appLog("[DeepLinkService] Received initial deep link: $initialUri");
        // Delay slightly to ensure GetX navigation is ready
        Future.delayed(const Duration(milliseconds: 1200), () {
          _handleDeepLink(initialUri);
        });
      }
    } catch (e) {
      errorLog("DeepLinkService.initInitialLink", e);
    }

    // 2. Handle incoming links when the app is in the background or foreground
    _linkSubscription = _appLinks.uriLinkStream.listen(
      (Uri uri) {
        appLog("[DeepLinkService] Received incoming deep link stream: $uri");
        _handleDeepLink(uri);
      },
      onError: (err) {
        errorLog("DeepLinkService.uriLinkStream", err);
      },
    );

    return this;
  }

  void _closeActiveBrowser() {
    try {
      if (WalletController.activeBrowser != null) {
        appLog(
          "[DeepLinkService] Found active ChromeSafariBrowser. Closing inline tab...",
        );
        WalletController.activeBrowser?.close();
        WalletController.activeBrowser = null;
      }
    } catch (e) {
      errorLog("DeepLinkService._closeActiveBrowser", e);
    }
  }

  void _handleDeepLink(Uri uri) {
    try {
      final scheme = uri.scheme.toLowerCase();
      final host = uri.host.toLowerCase();
      final path = uri.path.toLowerCase();

      appLog(
        "[DeepLinkService] Processing deep link -> Scheme: $scheme, Host: $host, Path: $path",
      );

      if (scheme == 'inaraa') {
        final uriString = uri.toString();
        final lastProcessed = GetStorageServices.instance.box.read(
          'last_processed_link',
        );

        if (lastProcessed == uriString) {
          appLog(
            "[DeepLinkService] Deep link $uriString has already been processed. Skipping to avoid duplicate routing.",
          );
          return;
        }

        if (path.contains('success') || host.contains('success')) {
          // Save the processed link to prevent duplicate launches on restart/resume
          GetStorageServices.instance.box.write(
            'last_processed_link',
            uriString,
          );

          // Safely close the inline ChromeSafariBrowser tab first
          _closeActiveBrowser();

          // Refresh the wallet balance and transaction list immediately
          if (Get.isRegistered<WalletController>()) {
            Get.find<WalletController>().fetchWalletData(isRefresh: true);
          }

          final referenceId = (uri.queryParameters['reference_id'] ?? '')
              .toUpperCase();
          final module = (uri.queryParameters['module'] ?? '').toUpperCase();
          final ampModule = (uri.queryParameters['amp;module'] ?? '')
              .toUpperCase();

          final isBooking =
              referenceId.contains('BOOKING') ||
              module.contains('BOOKING') ||
              ampModule.contains('BOOKING');
          final isOrder =
              referenceId.contains('ORDER') ||
              module.contains('ORDER') ||
              ampModule.contains('ORDER');
          final isMembership =
              referenceId.contains('MEMBERSHIP') ||
              module.contains('MEMBERSHIP') ||
              ampModule.contains('MEMBERSHIP');
          final isPackage =
              referenceId.contains('PACKAGE') ||
              module.contains('PACKAGE') ||
              ampModule.contains('PACKAGE');

          if (isBooking || isOrder || isMembership || isPackage) {
            String message = 'Payment Confirmed!';
            if (isMembership) {
              message = 'Membership activated successfully!';
            } else if (isPackage) {
              message = 'Package purchased successfully!';
            } else if (isOrder) {
              message = 'Order placed and payment confirmed.';
            } else if (isBooking) {
              message = 'Booking confirmed. Enjoy your class!';
            }

            appLog(
              "[DeepLinkService] Payment successful! Navigating to BookingConfirmedView...",
            );
            if (Get.currentRoute != Routes.bookingConfirmed) {
              Get.toNamed(
                Routes.bookingConfirmed,
                arguments: {
                  'message': message,
                  'fromMembership': isMembership,
                  'fromPackage': isPackage,
                },
              );
            }
          } else {
            appLog(
              "[DeepLinkService] Wallet top-up successful! Navigating to TopUpSuccessView...",
            );
            if (Get.currentRoute != Routes.topUpSuccess) {
              Get.toNamed(Routes.topUpSuccess);
            }
          }
        } else if (path.contains('error') ||
            host.contains('error') ||
            path.contains('failed') ||
            host.contains('failed')) {
          appLog(
            "[DeepLinkService] Top-up failed deep link received. Showing failure dialogue/toast.",
          );

          // Save the processed link to prevent duplicate alerts
          GetStorageServices.instance.box.write(
            'last_processed_link',
            uriString,
          );

          // Safely close the inline ChromeSafariBrowser tab first
          _closeActiveBrowser();

          AppSnackBar.error(
            'Your wallet top-up transaction was unsuccessful. Please check your card details and try again.',
          );
        }
      }
    } catch (e) {
      errorLog("DeepLinkService._handleDeepLink", e);
    }
  }

  @override
  void onClose() {
    _linkSubscription?.cancel();
    super.onClose();
  }
}
