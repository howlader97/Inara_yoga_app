import 'package:flutter/material.dart';
import '../widgets/class_header_section.dart';
import '../widgets/date_section.dart';
import '../widgets/header_section.dart';
import '../widgets/quick_action_section.dart';
import '../../../utils/app_size.dart';
import 'package:get/get.dart';

import '../../../widgets/app_refresh_indicator.dart';
import '../controllers/home_controller.dart';
import '../widgets/class_list_section.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        bottom: false,
        child: AppRefreshIndicator(
          onRefresh: () async {
            await controller.fetchClasses(controller.currentDate.value);
          },
          child: SingleChildScrollView(
            controller: controller.classScrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HeaderSection(),
                SizedBox(height: 20.h),
                const DateSection(),
                SizedBox(height: 32.h),
                const ClassHeaderSection(),
                SizedBox(height: 16.h),
                const ClassListSection(),
                const QuickActionsSection(),
                SizedBox(height: 100.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
