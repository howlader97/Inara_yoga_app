import 'package:flutter/material.dart';
import '../../../utils/app_size.dart';
import 'package:get/get.dart';
import '../../../data/app_colors.dart';
import '../../../data/app_text_styles.dart';
import '../../../data/image_path.dart';
import '../../courses/views/courses_view.dart';
import '../../home/views/home_view.dart';
import '../../profile/views/profile_view.dart';
import '../controllers/custom_bottom_nav_controller.dart';
import '../../wallet/views/wallet_view.dart';
import '../../store/views/store_view.dart';

class CustomBottomNavView extends GetView<CustomBottomNavController> {
  const CustomBottomNavView({super.key});
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CustomBottomNavController>(
      init: CustomBottomNavController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColors.backgroundColor,
          extendBody: true,
          // Floating Action Button
          floatingActionButton: SizedBox(
            height: 60.h,
            width: 60.w,
            child: FloatingActionButton(
              heroTag: 'home_fab',
              onPressed: () => controller.changeIndex(5), // index 4 is Home
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              backgroundColor: AppColors.primaryColor,
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(10.r),
                child: Image.asset(ImagePath.home, color: AppColors.whiteColor),
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,

          bottomNavigationBar: BottomAppBar(
            height: AppSize.size.width * 0.14,
            shape: const CircularNotchedRectangle(),
            notchMargin: 12.0,
            color: AppColors.primaryColor,
            elevation: 0,
            padding: EdgeInsets.zero,
            child: SafeArea(
              child: SizedBox(
                width: AppSize.size.width,
                child: FittedBox(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _bottomNavItem(
                          index: 0,
                          iconPath: ImagePath.store,
                          label: 'Store',
                        ),
                        _bottomNavItem(
                          index: 1,
                          iconPath: ImagePath.courses,
                          label: 'Courses',
                        ),

                        SizedBox(
                          width: AppSize.size.width * 0.25,
                        ), // Space for FAB
                        _bottomNavItem(
                          index: 3,
                          iconPath: ImagePath.wallet,
                          label: 'Wallet',
                        ),
                        _bottomNavItem(
                          index: 4,
                          iconPath: ImagePath.profile,
                          label: 'Account',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          body: IndexedStack(
            index: controller.currentIndex.value,
            children: [
              const StoreView(),
              const CoursesView(),
              const WalletView(),
              const WalletView(),
              const ProfileView(),
              const HomeView(),
            ],
          ),
          // body: Obx(() {
          //   switch (controller.currentIndex.value) {
          //     case 0:
          //       return const CoursesView();

          //     case 1:
          //       return const WalletView();
          //     case 2:
          //       return const StoreView();
          //     case 3:
          //       return const ProfileView();
          //     case 4:
          //       return const HomeView();
          //     default:
          //       return const HomeView();
          //   }
          // }),
        );
      },
    );
  }

  // Custom Bottom Item
  Widget _bottomNavItem({
    required int index,
    required String iconPath,
    required String label,
  }) {
    bool isSelected = controller.currentIndex.value == index;
    return InkWell(
      onTap: () => controller.changeIndex(index),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: SizedBox(
        width: AppSize.size.width * 0.2,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top indicator
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.whiteColor : Colors.transparent,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 10.h),
            // Icon
            Image.asset(
              iconPath,
              height: 24.h,
              width: 24.w,
              color: isSelected
                  ? AppColors.whiteColor
                  : AppColors.bottomNevUnselectedItemColor,
            ),
            SizedBox(height: 4.h),
            // Label
            Text(
              label,
              style: AppTextStyles.regular(10).copyWith(
                color: isSelected
                    ? AppColors.whiteColor
                    : AppColors.bottomNevUnselectedItemColor,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
