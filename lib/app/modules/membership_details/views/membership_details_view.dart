import 'package:flutter/material.dart';
import '../../../widgets/custom_appbar.dart';
import '../controllers/membership_details_controller.dart';
import 'package:get/get.dart';

class MembershipDetailsView extends GetView<MembershipDetailsController> {
  const MembershipDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF3EFE9),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Obx(() => CustomAppBar(title: controller.type.value)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name and subtitle
                    Obx(
                      () => Text(
                        controller.title.value,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff5D4037),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Obx(
                      () => Text(
                        controller.subtitle.value,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xff8D6E63),
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Days remaining / Non refundable note
                    Obx(() {
                      if (controller.isActive.value) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today_outlined,
                                  color: Color(0xff5D4037),
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "Days remaining: ${controller.daysRemaining.value} days",
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xff5D4037),
                                  ),
                                ),
                              ],
                            ),
                            if (controller.sessionsRemaining.value != null) ...[
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.confirmation_num_outlined,
                                    color: Color(0xff5D4037),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Sessions remaining: ${controller.sessionsRemaining.value} / ${controller.numberOfSessions.value ?? 0}",
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xff5D4037),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        );
                      } else {
                        return const Text(
                          "Note: Non refundable",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xff5D4037),
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      }
                    }),
                    const SizedBox(height: 12),
                    Obx(() {
                      final timeStr =
                          controller.timeRestriction.value.isNotEmpty
                          ? (_isRange(controller.timeRestriction.value)
                                ? " from ${_formatTimeRestriction(controller.timeRestriction.value)}"
                                : " (${_formatTimeRestriction(controller.timeRestriction.value)})")
                          : "";
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.check_circle_outline,
                            color: Color(0xff5D4037),
                            size: 22,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "${controller.validity.value}$timeStr",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xff5D4037),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                    const SizedBox(height: 12),
                    Obx(
                      () => (controller.isActive.value)
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Start- ${controller.startDate.value}",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Color(0xff5D4037),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    const Icon(
                                      Icons.calendar_today_outlined,
                                      size: 16,
                                      color: Color(0xff5D4037),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "${controller.startDate.value} - ${controller.endDate.value}",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: const Color(
                                      0xff5D4037,
                                    ).withValues(alpha: 0.6),
                                  ),
                                ),
                              ],
                            )
                          : const SizedBox.shrink(),
                    ),

                    // Excluded classes
                    Obx(() {
                      if (controller.excludedClassDetails.isNotEmpty) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Excluded Classes",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff5D4037),
                              ),
                            ),
                            const SizedBox(height: 10),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              itemCount: controller.excludedClassDetails.length,
                              itemBuilder: (context, index) {
                                final classInfo =
                                    controller.excludedClassDetails[index];
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: const Color(
                                        0xff5D4037,
                                      ).withValues(alpha: 0.1),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        classInfo.title,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: Color(0xff5D4037),
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.access_time,
                                            size: 14,
                                            color: Color(0xff8D6E63),
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            classInfo.duration,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Color(0xff8D6E63),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          const Icon(
                                            Icons.location_on_outlined,
                                            size: 14,
                                            color: Color(0xff8D6E63),
                                          ),
                                          const SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              classInfo.location,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Color(0xff8D6E63),
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    }),

                    const SizedBox(height: 20),

                    // Payment / Auto-renew section if not active
                    Obx(() {
                      if (controller.isActive.value) {
                        return const SizedBox.shrink();
                      }
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // GestureDetector(
                          //   behavior: HitTestBehavior.opaque,
                          //   onTap: () {
                          //     controller.autoRenew.value =
                          //         !controller.autoRenew.value;
                          //   },
                          //   child: Row(
                          //     children: [
                          //       Obx(
                          //         () => Transform.scale(
                          //           scale: 0.8,
                          //           child: Switch(
                          //             value: controller.autoRenew.value,
                          //             onChanged: (val) =>
                          //                 controller.autoRenew.value = val,
                          //             activeThumbColor: const Color(0xff5D4037),
                          //             activeTrackColor: Colors.white,
                          //             inactiveThumbColor: Colors.white,
                          //             inactiveTrackColor: Colors
                          //                 .grey
                          //                 .withValues(alpha: 0.3),
                          //           ),
                          //         ),
                          //       ),
                          //       const Text(
                          //         "Auto Renew",
                          //         style: TextStyle(
                          //           fontSize: 16,
                          //           fontWeight: FontWeight.w600,
                          //           color: Color(0xff5D4037),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          const SizedBox(height: 12),
                          GestureDetector(
                            onTap: controller.proceedToPayment,
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: const Color(0xff5D4037),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                    child: Text(
                                      "Proceed to Payment",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                    ),
                                    child: Row(
                                      children: List.generate(
                                        30,
                                        (index) => Expanded(
                                          child: Container(
                                            height: 1,
                                            color: index % 2 == 0
                                                ? Colors.white.withValues(
                                                    alpha: 0.3,
                                                  )
                                                : Colors.transparent,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    child: Text(
                                      "Wallet balance ${controller.walletBalance.value}",
                                      style: TextStyle(
                                        color: Colors.white.withValues(
                                          alpha: 0.7,
                                        ),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isRange(String timeStr) {
    final lower = timeStr.toLowerCase();
    return timeStr.contains('-') ||
        timeStr.contains('–') ||
        lower.contains(' to ');
  }

  String _formatTimeRestriction(String timeStr) {
    if (timeStr.isEmpty) return "";

    // Clean spaces
    timeStr = timeStr.trim();

    if (!_isRange(timeStr)) {
      // If it is not a range (e.g. "Before 12:00 pm"), return it as is
      return timeStr;
    }

    // Split using a proper range regex
    final parts = timeStr.split(RegExp(r'\s*(?:-|–|\bto\b)\s*'));
    if (parts.length != 2) {
      return timeStr;
    }

    String formatTimePart(String part) {
      part = part.trim();
      // Check if it already has am/pm
      if (part.toLowerCase().contains('am') ||
          part.toLowerCase().contains('pm')) {
        return part.toLowerCase();
      }

      // Try to parse HH:mm or HH:mm:ss
      final timeParts = part.split(':');
      if (timeParts.isEmpty) return part;

      int? hour = int.tryParse(timeParts[0]);
      int minute = 0;
      if (timeParts.length > 1) {
        minute = int.tryParse(timeParts[1]) ?? 0;
      }

      if (hour == null) return part;

      final period = hour >= 12 ? 'pm' : 'am';
      int displayHour = hour % 12;
      if (displayHour == 0) displayHour = 12;

      final minuteStr = minute == 0
          ? ''
          : ':${minute.toString().padLeft(2, '0')}';
      return '$displayHour$minuteStr $period';
    }

    final start = formatTimePart(parts[0]);
    final end = formatTimePart(parts[1]);
    return '$start to $end';
  }
}
