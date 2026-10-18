import 'package:flutter/material.dart';
import 'package:george/app/modules/home/controllers/home_controller.dart';
import '../../../data/image_path.dart';
import '../../../methodes/call_studio.dart';
import '../../../methodes/call_whatsapp.dart';
import '../../../widgets/full_screen_map_view.dart';
import 'quick_action_item.dart';
import 'package:get/get.dart';
import '../../../utils/app_size.dart';

class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    return Obx(() {
      if (controller.isLoading.value) {
        return const SizedBox.shrink();
      }
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: QuickActionItem(
                iconPath: ImagePath.phone,
                label: 'Call Us',
                onTap: () => makePhoneCall('+974 5550 5301'),
              ),
            ),
            Expanded(
              child: QuickActionItem(
                iconPath: ImagePath.whatsapp,
                label: 'WhatsApp',
                onTap: () => openWhatsApp('+974 5550 5301'),
              ),
            ),
            Expanded(
              child: QuickActionItem(
                iconPath: ImagePath.location,
                label: 'Find Us',
                onTap: () => Get.to(
                  () => const FullScreenMapView(
                    title:
                        'Al Corniche Street, Building 22, West Bay, Doha, Qatar',
                    latitude: 25.3548,
                    longitude: 51.531,
                  ),
                ),
              ),
            ),
            Expanded(
              child: QuickActionItem(
                iconPath: ImagePath.news,
                label: 'Our News',
                onTap: () => Get.toNamed('/news'),
              ),
            ),
          ],
        ),
      );
    });
  }
}
