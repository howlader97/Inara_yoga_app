import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/snack_bar/app_snack_bar.dart';

import '../modules/about_us/bindings/about_us_binding.dart';
import '../modules/about_us/views/about_us_view.dart';
import '../modules/auth/create_new_password/bindings/create_new_password_binding.dart';
import '../modules/auth/create_new_password/views/create_new_password_view.dart';
import '../modules/auth/log_in/bindings/log_in_binding.dart';
import '../modules/auth/log_in/views/log_in_view.dart';
import '../modules/auth/onboarding/bindings/onboarding_binding.dart';
import '../modules/auth/onboarding/views/onboarding_view.dart';
import '../modules/auth/recovery_otp/bindings/recovery_otp_binding.dart';
import '../modules/auth/recovery_otp/views/recovery_otp_view.dart';
import '../modules/auth/recovery_password/bindings/recovery_password_binding.dart';
import '../modules/auth/recovery_password/views/recovery_password_view.dart';
import '../modules/auth/registration/bindings/registration_binding.dart';
import '../modules/auth/registration/views/registration_view.dart';
import '../modules/auth/splash_screen/bindings/splash_screen_binding.dart';
import '../modules/auth/splash_screen/views/splash_screen_view.dart';
import '../modules/booking_confirmed/bindings/booking_confirmed_binding.dart';
import '../modules/booking_confirmed/views/booking_confirmed_view.dart';
import '../modules/booking_details/bindings/booking_details_binding.dart';
import '../modules/booking_details/views/booking_details_view.dart';
import '../modules/checkout/bindings/checkout_binding.dart';
import '../modules/checkout/views/checkout_view.dart';
import '../modules/class_details/bindings/class_details_binding.dart';
import '../modules/class_details/views/class_details_view.dart';
import '../modules/course_details/bindings/course_details_binding.dart';
import '../modules/course_details/views/course_details_view.dart';
import '../modules/course_instructor_details/bindings/course_instructor_details_binding.dart';
import '../modules/course_instructor_details/views/course_instructor_details_view.dart';
import '../modules/courses/bindings/courses_binding.dart';
import '../modules/courses/bindings/filter_binding.dart';
import '../modules/courses/views/courses_view.dart';
import '../modules/courses/views/filter_view.dart';
import '../modules/custom_bottom_nav/bindings/custom_bottom_nav_binding.dart';
import '../modules/custom_bottom_nav/views/custom_bottom_nav_view.dart';
import '../modules/edit_profile/bindings/edit_profile_binding.dart';
import '../modules/edit_profile/views/edit_profile_view.dart';
import '../modules/error_screen/bindings/error_screen_binding.dart';
import '../modules/error_screen/views/error_screen_view.dart';
import '../modules/faq/bindings/faq_binding.dart';
import '../modules/faq/views/faq_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/instructor_details/bindings/instructor_details_binding.dart';
import '../modules/instructor_details/views/instructor_details_view.dart';
import '../modules/membership_details/bindings/membership_details_binding.dart';
import '../modules/membership_details/views/membership_details_view.dart';
import '../modules/memberships/bindings/memberships_binding.dart';
import '../modules/memberships/views/memberships_view.dart';
import '../modules/my_bookings/bindings/my_bookings_binding.dart';
import '../modules/my_bookings/views/my_bookings_view.dart';
import '../modules/news/bindings/news_binding.dart';
import '../modules/news/views/news_view.dart';
import '../modules/news_details/bindings/news_details_binding.dart';
import '../modules/news_details/views/news_details_view.dart';
import '../modules/not_found_screen/bindings/not_found_screen_binding.dart';
import '../modules/not_found_screen/views/not_found_screen_view.dart';
import '../modules/notifications/bindings/notifications_binding.dart';
import '../modules/notifications/views/notifications_view.dart';
import '../modules/order_history/bindings/order_history_binding.dart';
import '../modules/order_history/views/order_history_view.dart';
import '../modules/privacy_policy/bindings/privacy_policy_binding.dart';
import '../modules/privacy_policy/views/privacy_policy_view.dart';
import '../modules/product_details/bindings/product_details_binding.dart';
import '../modules/product_details/views/product_details_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/terms_conditions/bindings/terms_conditions_binding.dart';
import '../modules/terms_conditions/views/terms_conditions_view.dart';
import '../modules/track_progress/bindings/track_progress_binding.dart';
import '../modules/track_progress/views/track_progress_view.dart';
import '../modules/update_password/bindings/update_password_binding.dart';
import '../modules/update_password/views/update_password_view.dart';
import '../modules/wallet/bindings/wallet_binding.dart';
import '../modules/wallet/views/top_up_success_view.dart';
import '../modules/wallet/views/wallet_view.dart';
import '../modules/my_practice/bindings/my_practice_binding.dart';
import '../modules/my_practice/views/my_practice_view.dart';
import '../modules/delete_account/bindings/delete_account_binding.dart';
import '../modules/delete_account/views/delete_account_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.splashScreen;

  static final routes = [
    GetPage(
      name: _Paths.courses,
      page: () => const CoursesView(),
      binding: CoursesBinding(),
    ),
    GetPage(
      name: _Paths.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.profile,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.customBottomNav,
      page: () => const CustomBottomNavView(),
      binding: CustomBottomNavBinding(),
    ),
    GetPage(
      name: _Paths.splashScreen,
      page: () => const SplashScreenView(),
      binding: SplashScreenBinding(),
    ),
    GetPage(
      name: _Paths.logIn,
      page: () => const LogInView(),
      binding: LogInBinding(),
    ),
    GetPage(
      name: _Paths.registration,
      page: () => const RegistrationView(),
      binding: RegistrationBinding(),
    ),
    GetPage(
      name: _Paths.recoveryOtp,
      page: () => const RecoveryOtpView(),
      binding: RecoveryOtpBinding(),
    ),
    GetPage(
      name: _Paths.createNewPassword,
      page: () => const CreateNewPasswordView(),
      binding: CreateNewPasswordBinding(),
    ),
    GetPage(
      name: _Paths.recoveryPassword,
      page: () => const RecoveryPasswordView(),
      binding: RecoveryPasswordBinding(),
    ),
    GetPage(
      name: _Paths.onboarding,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: _Paths.news,
      page: () => const NewsView(),
      binding: NewsBinding(),
    ),
    GetPage(
      name: _Paths.classDetails,
      page: () => const ClassDetailsView(),
      binding: ClassDetailsBinding(),
    ),
    GetPage(
      name: _Paths.courseDetails,
      page: () => CourseDetailsView(),
      binding: CourseDetailsBinding(),
    ),
    GetPage(
      name: _Paths.newsDetails,
      page: () => const NewsDetailsView(),
      binding: NewsDetailsBinding(),
    ),
    GetPage(
      name: _Paths.notifications,
      page: () => const NotificationsView(),
      binding: NotificationsBinding(),
    ),
    GetPage(
      name: _Paths.checkout,
      page: () => CheckoutView(),
      binding: CheckoutBinding(),
    ),
    GetPage(
      name: _Paths.bookingConfirmed,
      page: () => const BookingConfirmedView(),
      binding: BookingConfirmedBinding(),
    ),
    GetPage(
      name: _Paths.instructorDetails,
      page: () => const InstructorDetailsView(),
      binding: InstructorDetailsBinding(),
    ),
    GetPage(
      name: _Paths.myBookings,
      page: () => const MyBookingsView(),
      binding: MyBookingsBinding(),
    ),
    GetPage(
      name: _Paths.bookingDetails,
      page: () => const BookingDetailsView(),
      binding: BookingDetailsBinding(),
    ),
    GetPage(name: _Paths.topUpSuccess, page: () => const TopUpSuccessView()),
    GetPage(
      name: _Paths.productDetails,
      page: () => const ProductDetailsView(),
      binding: ProductDetailsBinding(),
    ),
    GetPage(
      name: _Paths.aboutUs,
      page: () => const AboutUsView(),
      binding: AboutUsBinding(),
    ),
    GetPage(
      name: _Paths.editProfile,
      page: () => const EditProfileView(),
      binding: EditProfileBinding(),
    ),
    GetPage(
      name: _Paths.memberships,
      page: () => const MembershipsView(),
      binding: MembershipsBinding(),
    ),
    GetPage(
      name: _Paths.membershipDetails,
      page: () => MembershipDetailsView(),
      binding: MembershipDetailsBinding(),
    ),
    GetPage(
      name: _Paths.termsConditions,
      page: () => const TermsConditionsView(),
      binding: TermsConditionsBinding(),
    ),
    GetPage(
      name: _Paths.wallet,
      page: () => const WalletView(),
      binding: WalletBinding(),
    ),
    GetPage(
      name: _Paths.orderHistory,
      page: () => const OrderHistoryView(),
      binding: OrderHistoryBinding(),
    ),
    GetPage(
      name: _Paths.filter,
      page: () => const FilterView(),
      binding: FilterBinding(),
    ),
    GetPage(
      name: _Paths.errorScreen,
      page: () => const ErrorScreenView(),
      binding: ErrorScreenBinding(),
    ),
    GetPage(
      name: _Paths.notFoundScreen,
      page: () => const NotFoundScreenView(),
      binding: NotFoundScreenBinding(),
    ),
    GetPage(
      name: _Paths.courseInstructorDetails,
      page: () => const CourseInstructorDetailsView(),
      binding: CourseInstructorDetailsBinding(),
    ),
    GetPage(
      name: _Paths.privacyPolicy,
      page: () => const PrivacyPolicyView(),
      binding: PrivacyPolicyBinding(),
    ),
    GetPage(
      name: _Paths.faq,
      page: () => const FaqView(),
      binding: FaqBinding(),
    ),
    GetPage(
      name: _Paths.updatePassword,
      page: () => const UpdatePasswordView(),
      binding: UpdatePasswordBinding(),
    ),
    GetPage(
      name: _Paths.trackProgress,
      page: () => const TrackProgressView(),
      binding: TrackProgressBinding(),
    ),
    GetPage(
      name: _Paths.myPractice,
      page: () => const MyPracticeView(),
      binding: MyPracticeBinding(),
    ),
    GetPage(
      name: _Paths.deleteAccount,
      page: () => const DeleteAccountView(),
      binding: DeleteAccountBinding(),
    ),
    GetPage(
      name: '/payment/success',
      page: () {
        final referenceId = (Get.parameters['reference_id'] ?? '')
            .toUpperCase();
        final ampModule = (Get.parameters['amp;module'] ?? '').toUpperCase();
        final module = (Get.parameters['module'] ?? '').toUpperCase();
        final isBookingOrOrderOrMembershipOrPackage =
            referenceId.contains('BOOKING') ||
            referenceId.contains('ORDER') ||
            referenceId.contains('MEMBERSHIP') ||
            referenceId.contains('PACKAGE') ||
            referenceId.contains('COURSE') ||
            ampModule.contains('BOOKING') ||
            ampModule.contains('ORDER') ||
            ampModule.contains('MEMBERSHIP') ||
            ampModule.contains('PACKAGE') ||
            ampModule.contains('COURSE') ||
            module.contains('BOOKING') ||
            module.contains('ORDER') ||
            module.contains('MEMBERSHIP') ||
            module.contains('PACKAGE') ||
            module.contains('COURSE');
        if (isBookingOrOrderOrMembershipOrPackage) {
          return const BookingConfirmedView();
        } else {
          return const TopUpSuccessView();
        }
      },
    ),
    GetPage(
      name: '/success',
      page: () {
        final referenceId = (Get.parameters['reference_id'] ?? '')
            .toUpperCase();
        final ampModule = (Get.parameters['amp;module'] ?? '').toUpperCase();
        final module = (Get.parameters['module'] ?? '').toUpperCase();
        final isBookingOrOrderOrMembershipOrPackage =
            referenceId.contains('BOOKING') ||
            referenceId.contains('ORDER') ||
            referenceId.contains('MEMBERSHIP') ||
            referenceId.contains('PACKAGE') ||
            referenceId.contains('COURSE') ||
            ampModule.contains('BOOKING') ||
            ampModule.contains('ORDER') ||
            ampModule.contains('MEMBERSHIP') ||
            ampModule.contains('PACKAGE') ||
            ampModule.contains('COURSE') ||
            module.contains('BOOKING') ||
            module.contains('ORDER') ||
            module.contains('MEMBERSHIP') ||
            module.contains('PACKAGE') ||
            module.contains('COURSE');
        if (isBookingOrOrderOrMembershipOrPackage) {
          return const BookingConfirmedView();
        } else {
          return const TopUpSuccessView();
        }
      },
    ),
    GetPage(
      name: '/payment/error',
      page: () => const PaymentErrorRedirectPage(),
      middlewares: [PaymentErrorMiddleware()],
    ),
    GetPage(
      name: '/error',
      page: () => const PaymentErrorRedirectPage(),
      middlewares: [PaymentErrorMiddleware()],
    ),
    GetPage(
      name: '/payment/failure',
      page: () => const PaymentErrorRedirectPage(),
      middlewares: [PaymentErrorMiddleware()],
    ),
    GetPage(
      name: '/failure',
      page: () => const PaymentErrorRedirectPage(),
      middlewares: [PaymentErrorMiddleware()],
    ),
  ];
}

class PaymentErrorMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppSnackBar.error(
        'Your wallet top-up transaction was unsuccessful. Please check your card details and try again.',
      );
    });
    return null;
  }
}

class PaymentErrorRedirectPage extends StatefulWidget {
  const PaymentErrorRedirectPage({super.key});

  @override
  State<PaymentErrorRedirectPage> createState() =>
      _PaymentErrorRedirectPageState();
}

class _PaymentErrorRedirectPageState extends State<PaymentErrorRedirectPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.currentRoute == '/payment/error' ||
          Get.currentRoute == '/error' ||
          Get.currentRoute == '/payment/failure' ||
          Get.currentRoute == '/failure') {
        if (Get.previousRoute.isNotEmpty) {
          Get.back();
        } else {
          Get.offAllNamed(Routes.wallet);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xffF3EFE9),
      body: Center(child: CircularProgressIndicator(color: Color(0xff5d4037))),
    );
  }
}
