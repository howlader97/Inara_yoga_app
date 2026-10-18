import 'package:flutter/material.dart';
import '../../../utils/app_size.dart';
import 'package:get/get.dart';

import '../../../data/app_colors.dart';
import '../../../data/app_text_styles.dart';
import '../../../routes/app_pages.dart';
import '../../custom_bottom_nav/controllers/custom_bottom_nav_controller.dart';
import '../controllers/wallet_controller.dart';

class TopUpSuccessView extends StatefulWidget {
  const TopUpSuccessView({super.key});

  @override
  State<TopUpSuccessView> createState() => _TopUpSuccessViewState();
}

class _TopUpSuccessViewState extends State<TopUpSuccessView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              _buildAnimatedSuccessUI(),
              SizedBox(height: 48.h),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOutBack,
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(0, 20 * (1 - value)),
                    child: Opacity(
                      opacity: value.clamp(0.0, 1.0),
                      child: Text(
                        'Top Up Successful',
                        style: AppTextStyles.bold(
                          28,
                          color: const Color(0xFF6B5345),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
              ),
              const Spacer(),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 800),
                curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value.clamp(0.0, 1.0),
                    child: Transform.translate(
                      offset: Offset(0, 10 * (1 - value)),
                      child: SizedBox(
                        width: double.infinity,
                        height: 55.h,
                        child: ElevatedButton(
                          onPressed: () {
                            if (Get.isRegistered<CustomBottomNavController>()) {
                              Get.find<CustomBottomNavController>().changeIndex(
                                3,
                              );
                            }
                            if (Get.isRegistered<WalletController>()) {
                              Get.find<WalletController>().fetchWalletData(
                                isRefresh: true,
                              );
                            }
                            Get.offNamed(Routes.customBottomNav);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6B5345),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Back To Home',
                            style: AppTextStyles.bold(18, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedSuccessUI() {
    return SizedBox(
      width: 300.w,
      height: 300.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Animated Bubbles
          ..._buildAnimatedBubbles(),

          // Main Scale-in Circle
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 600),
            curve: Curves.elasticOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Container(
                  width: 150.r,
                  height: 150.r,
                  decoration: const BoxDecoration(
                    color: Color(0xFF6B5345),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Center(
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 400),
                      curve: const Interval(0.6, 1.0, curve: Curves.easeIn),
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value.clamp(0.0, 1.0),
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 80.r,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  List<Widget> _buildAnimatedBubbles() {
    final bubbles = [
      [0.2, 0.1, 10.0, const Color(0xFF6B5345), 200],
      [0.8, 0.2, 12.0, const Color(0xFF6B5345), 400],
      [0.1, 0.5, 14.0, const Color(0xFF6B5345), 100],
      [0.9, 0.6, 10.0, const Color(0xFF6B5345), 500],
      [0.3, 0.9, 12.0, const Color(0xFF6B5345), 300],
      [0.7, 0.8, 10.0, const Color(0xFF6B5345), 600],
      [0.2, 0.3, 8.0, const Color(0xFF6B5345), 150],
      [0.75, 0.3, 14.0, const Color(0xFFF08A8A), 450],
      [0.4, 0.15, 12.0, const Color(0xFF6B5345), 250],
      [0.55, 0.05, 8.0, const Color(0xFF6B5345), 550],
      [0.6, 0.9, 10.0, const Color(0xFF6B5345), 350],
      [0.4, 0.85, 12.0, const Color(0xFFF08A8A), 650],
    ];

    return bubbles.map((b) {
      return TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: Duration(milliseconds: 500 + (b[4] as int)),
        curve: Curves.easeOutBack,
        builder: (context, value, child) {
          return Align(
            alignment: FractionalOffset(b[0] as double, b[1] as double),
            child: Transform.scale(
              scale: value,
              child: Opacity(
                opacity: value.clamp(0.0, 1.0),
                child: Container(
                  width: b[2] as double,
                  height: b[2] as double,
                  decoration: BoxDecoration(
                    color: b[3] as Color,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          );
        },
      );
    }).toList();
  }
}
