import 'package:flutter/foundation.dart';
import '../utils/app_log.dart';

class AppApiEndPoint {
  AppApiEndPoint._privateConstructor();
  static final AppApiEndPoint _instance = AppApiEndPoint._privateConstructor();
  static AppApiEndPoint get instance => _instance;

  //app use base
  final String domain = _getDomain();
  final String baseUrl = "${_getDomain()}/api/v1";
  final String termsAndConditions = "/terms-conditions";
  final String about = "/about-us";
  final String privacyPolicy = "/privacy-policy";
  final String login = "/auth/login";
  final String refreshToken = "/auth/refresh";
  final String signUP = "/auth/register";
  final String signUpOtpVerify = "/auth/verify-otp";
  final String userDelete = "/users";
  final String userMe = "/users/me";
  final String attendanceStats = "/users/attendance_stats";
  final String userUpdate = "/users/update";
  final String changePassword = "login";
  final String userResendOtp = "/auth/resend-otp";
  final String authOtpVerify = "login";
  final String authForgotPassword = "/auth/forgot-password";
  final String authVerifyEmail = "/auth/verify-otp";
  final String authResetPassword = "/auth/reset-password";
  final String allClasses = '/classes/';
  final String storeProduct = '/store/products';
  final String allCourses = '/courses/';
  String courseDetails(String courseId) => '/courses/$courseId';
  final String instructors = '/instructors';
  final String news = '/news';
  final String faq = '/faq';
  final String membershipCatalogue = '/memberships/catalogue';
  final String activeMembership = '/memberships/info-me';
  final String packageCatalogue = '/packages/catalogue';
  final String activePackage = '/packages/info-me';
  final String updatePassword = '/users/update-password';
  final String notifications = '/notifications';
  final String markRead = '/notifications/mark-read';
  final String walletBalance = '/payments/wallet/balance';
  final String walletHistory = '/payments/wallet/history';
  final String walletTopUp = '/payments/wallet/topup';
  final String bookingPay = '/payments/bookings/pay';
  final String coursePay = '/payments/courses/pay';
  final String orderPay = '/payments/orders/checkout';
  final String membershipPay = '/payments/memberships/buy';
  final String packagePay = '/payments/packages/buy';
  final String orderHistory = '/payments/orders/history';
  final String bookingHistory = '/payments/bookings/history';
  final String upcomingBookings = '/settings/bookings/upcoming';
  final String cancelBooking = '/payments/bookings/cancel';
  final String toggleAppNotification = '/settings/notifications/app';
  final String toggleWhatsappNotification = '/settings/notifications/whatsapp';
}

String _getDomain() {
  String liveServer = "https://api.inarayoga.com";
  String localServer = "https://api.inarayoga.com";

  try {
    if (kDebugMode) {
      localServer;
      // return localServer;
    }
    return liveServer;
  } catch (e) {
    errorLog("_getDomain", e);
    return liveServer;
  }
}
