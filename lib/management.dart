import 'package:flutter/material.dart';
import 'app/modules/error_screen/views/error_screen_view.dart';
import 'app/modules/not_found_screen/bindings/not_found_screen_binding.dart';
import 'app/modules/not_found_screen/views/not_found_screen_view.dart';
import 'package:get/get.dart';
import 'app/data/theme.dart';
import 'app/routes/app_pages.dart';
import 'app/utils/app_size.dart';
import 'app/widgets/snack_bar/app_snack_bar.dart';

class Management extends StatelessWidget {
  const Management({super.key});

  @override
  Widget build(BuildContext context) {
    AppSize.size = MediaQuery.of(context).size;
    return GetMaterialApp(
      scaffoldMessengerKey: AppSnackBar.messengerKey,
      title: "Application",
      theme: themeData(),
      debugShowCheckedModeBanner: false,
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      unknownRoute: GetPage(
        name: Routes.notFoundScreen,
        page: () => const NotFoundScreenView(),
        binding: NotFoundScreenBinding(),
      ),
      builder: (context, child) {
        ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
          return Overlay(
            initialEntries: [
              OverlayEntry(builder: (context) => ErrorScreenView()),
            ],
          );
        };
        return child ?? const SizedBox();
      },
    );
  }
}
