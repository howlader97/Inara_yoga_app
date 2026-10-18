import 'dart:math';

import 'package:flutter/material.dart';
import '../../../utils/duration_formatter.dart';
import '../../store/controllers/store_controller.dart';
import '../../memberships/controllers/memberships_controller.dart';
import '../../courses/controllers/courses_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../../utils/app_size.dart';
import '../../../widgets/app_image/app_image.dart';
import '../../../widgets/custom_appbar.dart';
import '../../../widgets/custom_elevated_button.dart';
import 'package:get/get.dart';
import '../../../data/app_colors.dart';
import '../../../data/app_text_styles.dart';
import '../controllers/checkout_controller.dart';

class CheckoutView extends GetView<CheckoutController> {
  CheckoutView({super.key});

  final storeController = Get.find<StoreController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(title: "Checkout"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Item Summary Card
            Obx(() {
              final type = controller.checkoutType.value;
              final isShop = controller.isFromShop.value;
              final name = isShop
                  ? (controller.product?.name ?? "")
                  : controller.itemName.value;
              final priceText = isShop
                  ? "QAR ${controller.product?.price ?? 0.0}"
                  : controller.cartTotal.value;
              final totalText = isShop
                  ? "QAR ${controller.product?.totalPrice ?? 0.0}"
                  : controller.cartTotal.value;
              final imgUrl = isShop
                  ? (controller.product?.thumbnail ?? "")
                  : controller.imageUrl.value;

              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFEBE3D9), // Sleek beige card background
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image / Icon Container
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFFBCAAA4,
                            ).withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: imgUrl.isNotEmpty
                              ? AppImage(
                                  url: imgUrl,
                                  fit: BoxFit.cover,
                                  networkPlaceholderImage:
                                      "assets/images/network_placeholder_image.jpg",
                                )
                              : Center(
                                  child: Icon(
                                    type == 'class'
                                        ? Icons.calendar_today_outlined
                                        : type == 'course'
                                        ? Icons.school_outlined
                                        : type == 'membership'
                                        ? Icons.card_membership_outlined
                                        : Icons.shopping_bag_outlined,
                                    color: const Color(0xFF5D4037),
                                    size: 32,
                                  ),
                                ),
                        ),
                        const SizedBox(width: 16),
                        // Title and quick details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Type Tag
                              if (type.isNotEmpty)
                                Container(
                                  margin: const EdgeInsets.only(bottom: 6),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFF5D4037,
                                    ).withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    type.toUpperCase(),
                                    style: const TextStyle(
                                      color: Color(0xFF5D4037),
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              Text(
                                name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Color(0xFF5D4037),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (controller
                                  .instructorName
                                  .value
                                  .isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  "Instructor: ${controller.instructorName.value}",
                                  style: TextStyle(
                                    color: const Color(
                                      0xFF5D4037,
                                    ).withValues(alpha: 0.8),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                              if (controller.validity.value.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  controller.validity.value,
                                  style: TextStyle(
                                    color: const Color(
                                      0xFF5D4037,
                                    ).withValues(alpha: 0.8),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),

                    // Specific meta details (Date, Time, Location, Duration)
                    if (type == 'class' || type == 'course') ...[
                      const SizedBox(height: 16),
                      const Divider(color: Color(0xFFD7CCC8), height: 1),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          if (controller.scheduledAt.value != null)
                            Expanded(
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.access_time,
                                    size: 16,
                                    color: Color(0xFF8D6E63),
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      "${controller.scheduledAt.value!.toQatarTime().day}/${controller.scheduledAt.value!.toQatarTime().month}/${controller.scheduledAt.value!.toQatarTime().year}",
                                      style: const TextStyle(
                                        color: Color(0xFF5D4037),
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if (controller.duration.value.isNotEmpty)
                            Expanded(
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.timer_outlined,
                                    size: 16,
                                    color: Color(0xFF8D6E63),
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      controller.scheduledAt.value != null
                                          ? formatClassTimeRange(
                                              controller.scheduledAt.value!,
                                              controller.duration.value,
                                            )
                                          : formatDuration(
                                              controller.duration.value,
                                              isSeconds: type == 'class',
                                            ),
                                      style: const TextStyle(
                                        color: Color(0xFF5D4037),
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      if (controller.location.value.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              size: 16,
                              color: Color(0xFF8D6E63),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                controller.location.value,
                                style: const TextStyle(
                                  color: Color(0xFF5D4037),
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],

                    const SizedBox(height: 16),
                    const Divider(color: Color(0xFFD7CCC8), height: 1),
                    const SizedBox(height: 12),

                    // Price details
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (isShop)
                          Text(
                            "Quantity: ${controller.product?.quantity ?? 1}",
                            style: const TextStyle(
                              color: Color(0xFF8D6E63),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        else
                          const SizedBox.shrink(),
                        if (isShop)
                          Text(
                            priceText.contains("QAR")
                                ? priceText
                                : "QAR $priceText",
                            style: const TextStyle(
                              color: Color(0xFF5D4037),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Total Price",
                          style: TextStyle(
                            color: Color(0xFF5D4037),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          totalText.contains("QAR")
                              ? totalText
                              : "QAR $totalText",
                          style: const TextStyle(
                            color: Color(0xFF5D4037),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 25),

            const Text(
              "Payment Method",
              style: TextStyle(
                color: AppColors.headlineColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),

            // Payment Methods List
            _buildPaymentMethods(),

            const SizedBox(height: 20),

            // Pay Now Button
            CustomElevetedButton(
              buttonText: 'Pay Now',
              onTap: () => controller.processPayment(),
            ),

            const SizedBox(height: 30),

            // Suggested Section
            Obx(
              () => controller.shouldHideSuggestions.value
                  ? const SizedBox()
                  : Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Suggested For you",
                            style: AppTextStyles.bold(
                              24,
                              color: const Color(0xFF5D4037),
                            ),
                          ),
                          const SizedBox(height: 15),
                          _buildSuggestedList(),
                        ],
                      ),
                    ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethods() {
    return Obx(() {
      final methods = <Map<String, dynamic>>[
        {
          'title': 'Wallet',
          'subtitle':
              'Balance QAR ${controller.walletBalance.value.toStringAsFixed(controller.walletBalance.value % 1 == 0 ? 0 : 1)}',
          'icon': Icons.account_balance_wallet_outlined,
        },
        {'title': 'Credit/Debit', 'icon': Icons.credit_card},
        ...controller.availablePackages.map(
          (pkg) => {
            'title': pkg.packageName,
            'subtitle': '${pkg.sessionsRemaining} sessions remaining',
            'icon': Icons.confirmation_number_outlined,
          },
        ),
      ];

      return Column(
        children: List.generate(methods.length, (index) {
          final isSelected = controller.selectedPaymentMethod.value == index;
          final method = methods[index];

          return GestureDetector(
            onTap: () => controller.selectPaymentMethod(index),
            child: Container(
              margin: const EdgeInsets.only(bottom: 15),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFF6D4C41),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      method['icon'] as IconData,
                      color: const Color(0xFF5D4037),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          method['title'] as String,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (method.containsKey('subtitle')) ...[
                          const SizedBox(height: 2),
                          Text(
                            method['subtitle'] as String,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.7),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  // Radio Button Style
                  Container(
                    width: 24,
                    height: 24,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: isSelected
                        ? Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          )
                        : null,
                  ),
                ],
              ),
            ),
          );
        }),
      );
    });
  }

  Widget _buildSuggestedList() {
    return Obx(() {
      final type = controller.checkoutType.value.toLowerCase();
      if (type == 'shop') {
        return _buildSuggestedProductsGrid();
      } else if (type == 'membership') {
        return _buildSuggestedMembershipsList(isPackage: false);
      } else if (type == 'package') {
        return _buildSuggestedMembershipsList(isPackage: true);
      } else if (type == 'course') {
        return _buildSuggestedCoursesList();
      } else if (type == 'class') {
        return _buildSuggestedClassesList();
      } else {
        return const SizedBox.shrink();
      }
    });
  }

  Widget _buildSuggestedMembershipsList({required bool isPackage}) {
    final membershipsCtrl = Get.isRegistered<MembershipsController>()
        ? Get.find<MembershipsController>()
        : Get.put(MembershipsController());

    return Obx(() {
      final List items = isPackage
          ? (membershipsCtrl.packageDataModel.value?.packages ?? [])
                .where((p) => p.id != controller.packageId.value)
                .take(2)
                .toList()
          : (membershipsCtrl.membershipDataModel.value?.memberships ?? [])
                .where((m) => m.id != controller.membershipPlanId.value)
                .take(2)
                .toList();

      if (items.isEmpty) {
        return const Center(child: Text("No suggestions available"));
      }

      return Column(
        children: List.generate(items.length, (index) {
          final item = items[index];
          final String id = item.id;
          final String title = item.name;
          final String price = "QAR ${item.price.toStringAsFixed(0)}";
          final String validity = "Valid for ${item.durationDays} days";

          return InkWell(
            onTap: () {
              Get.back(result: id);
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 15),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFEBE3D9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            color: AppColors.headlineColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(
                        price,
                        style: TextStyle(
                          color: AppColors.headlineColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        size: 18,
                        color: AppColors.headlineColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        validity,
                        style: TextStyle(
                          color: AppColors.headlineColor,
                          fontSize: 13,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.buttonPrimaryColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          "Buy",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
      );
    });
  }

  Widget _buildSuggestedCoursesList() {
    final coursesCtrl = Get.isRegistered<CoursesController>()
        ? Get.find<CoursesController>()
        : Get.put(CoursesController());

    return Obx(() {
      final items = (coursesCtrl.coursesList)
          .where((c) => c.id != controller.courseId.value)
          .take(2)
          .toList();

      if (items.isEmpty) {
        return const Center(child: Text("No suggestions available"));
      }

      return Column(
        children: List.generate(items.length, (index) {
          final item = items[index];
          final String id = item.id;
          final String title = item.title;
          final String price = "QAR ${item.price.toStringAsFixed(0)}";
          final String duration = item.duration;
          final String instructor = item.instructor.name;
          final String imageUrl = item.imageUrl;

          return InkWell(
            onTap: () {
              Get.back(result: id);
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 15),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFEBE3D9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: AppImage(
                      url: imageUrl,
                      networkPlaceholderImage:
                          "assets/images/network_placeholder_image.jpg",
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            color: AppColors.headlineColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Instructor: $instructor",
                          style: TextStyle(
                            color: AppColors.headlineColor.withValues(
                              alpha: 0.7,
                            ),
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 12,
                              color: AppColors.headlineColor.withValues(
                                alpha: 0.6,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              formatDuration(duration),
                              style: TextStyle(
                                color: AppColors.headlineColor.withValues(
                                  alpha: 0.6,
                                ),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    price,
                    style: TextStyle(
                      color: AppColors.headlineColor,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      );
    });
  }

  Widget _buildSuggestedClassesList() {
    final homeCtrl = Get.isRegistered<HomeController>()
        ? Get.find<HomeController>()
        : Get.put(HomeController());

    return Obx(() {
      final items = (homeCtrl.allClasses)
          .where((c) => c.id != controller.classId.value)
          .take(2)
          .toList();

      if (items.isEmpty) {
        return const Center(child: Text("No suggestions available"));
      }

      return Column(
        children: List.generate(items.length, (index) {
          final item = items[index];
          final String id = item.id;
          final String title = item.title;
          final String price = "QAR ${item.price.toStringAsFixed(0)}";
          final String duration = item.duration;
          final DateTime scheduledAt = item.scheduledAt;
          final String instructor = item.instructor.name;
          final String imageUrl = item.instructor.avatar ?? "";

          return InkWell(
            onTap: () {
              Get.back(result: id);
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 15),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFEBE3D9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: AppImage(
                      url: imageUrl,
                      networkPlaceholderImage:
                          "assets/images/network_placeholder_image.jpg",
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            color: AppColors.headlineColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Instructor: $instructor",
                          style: TextStyle(
                            color: AppColors.headlineColor.withValues(
                              alpha: 0.7,
                            ),
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 12,
                              color: AppColors.headlineColor.withValues(
                                alpha: 0.6,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              formatClassTimeRange(scheduledAt, duration),
                              style: TextStyle(
                                color: AppColors.headlineColor.withValues(
                                  alpha: 0.6,
                                ),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    price,
                    style: TextStyle(
                      color: AppColors.headlineColor,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      );
    });
  }

  Widget _buildSuggestedProductsGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: min(4, storeController.products.length),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.70,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
      ),
      itemBuilder: (context, index) {
        final products = storeController.products.value[index];
        return InkWell(
          onTap: () {
            Get.back(result: products.id);
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  height: AppSize.size.height * 0.5,
                  width: AppSize.size.width * 0.5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: AppImage(
                      url: products.thumbnail,
                      networkPlaceholderImage:
                          "assets/images/network_placeholder_image.jpg", // fallback
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 180.h, // set your desired height
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                products.name,
                style: TextStyle(
                  color: AppColors.headlineColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                "${products.price}",
                style: TextStyle(
                  color: AppColors.headlineColor,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
