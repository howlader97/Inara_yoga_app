import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import '../utils/app_size.dart';
import '../data/app_colors.dart';

class AppRefreshIndicator extends StatelessWidget {
  final Widget child;
  final Future<void> Function() onRefresh;

  const AppRefreshIndicator({
    super.key,
    required this.child,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return CustomRefreshIndicator(
      onRefresh: onRefresh,
      offsetToArmed: 50.h,
      builder:
          (BuildContext context, Widget child, IndicatorController controller) {
            return AnimatedBuilder(
              animation: controller,
              child: child,
              builder: (context, child) {
                final double value = controller.value.clamp(0.0, 1.5);
                return Stack(
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    if (!controller.isIdle)
                      Positioned(
                        top: 20.h + (30.h * (value > 1.0 ? 1.0 : value)),
                        child: Container(
                          padding: EdgeInsets.all(8.r),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: SizedBox(
                            height: 24.h,
                            width: 24.w,
                            child: CircularProgressIndicator(
                              value: controller.isLoading
                                  ? null
                                  : value.clamp(0.0, 1.0),
                              color: AppColors.buttonPrimaryColor,
                              strokeWidth: 3,
                            ),
                          ),
                        ),
                      ),
                    Transform.translate(
                      offset: Offset(0, 100.h * value.clamp(0.0, 1.0)),
                      child: child,
                    ),
                  ],
                );
              },
            );
          },
      child: child,
    );
  }
}
