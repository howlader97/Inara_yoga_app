import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:george/app/modules/wallet/controllers/decimal_text_input_formatter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../data/app_colors.dart';
import '../../../data/app_text_styles.dart';
import '../../../utils/app_size.dart';
import '../../../widgets/app_image/app_image.dart';
import '../../../widgets/app_refresh_indicator.dart';
import '../../../widgets/custom_appbar.dart';
import '../../../widgets/snack_bar/app_snack_bar.dart';
import '../controllers/wallet_controller.dart';
import '../../../../models/wallet_model.dart';

class WalletView extends StatelessWidget {
  const WalletView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WalletController());

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: SafeArea(
          child: CustomAppBar(title: 'Wallet', showBackButton: false),
        ),
      ),
      backgroundColor: AppColors.backgroundColor,
      body: AppRefreshIndicator(
        onRefresh: () => controller.fetchWalletData(isRefresh: true),
        child: SingleChildScrollView(
          controller: controller.scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.h),
                _buildBalanceCard(context, controller),
                // SizedBox(height: 25.h),
                // Text(
                //   "Payment Method",
                //   style: AppTextStyles.bold(
                //     18,
                //   ).copyWith(color: AppColors.headlineColor),
                // ),
                // SizedBox(height: 15.h),
                // _buildPaymentMethods(controller),
                Obx(
                  () => controller.selectedPaymentMethod.value == 2
                      ? Padding(
                          padding: EdgeInsets.only(top: 20.h),
                          child: _buildCreditDebitForm(controller),
                        )
                      : const SizedBox(),
                ),

                SizedBox(height: 25.h),
                Text(
                  "Payment History",
                  style: AppTextStyles.bold(
                    18,
                  ).copyWith(color: AppColors.headlineColor),
                ),
                SizedBox(height: 15.h),
                _buildPaymentHistory(controller),
                SizedBox(height: 70.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCreditDebitForm(WalletController controller) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xffEBE3D9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF6D4C41),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.credit_card, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text(
                  "Credit/Debit",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildTextField("First Name", controller.firstNameCtrl),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: _buildTextField("Last Name", controller.lastNameCtrl),
              ),
            ],
          ),
          const SizedBox(height: 15),

          _buildTextField("Routing Number", controller.routingNumberCtrl),
          const SizedBox(height: 15),
          _buildTextField("Account Number", controller.accountNumberCtrl),
          const SizedBox(height: 15),
          _buildTextField(
            "Verify Account Number",
            controller.verifyAccountNumberCtrl,
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: const Color(0xFFBCAAA4).withValues(alpha: 0.6),
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: const Color(0xFF5D4037).withValues(alpha: 0.5),
            fontSize: 15,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
        style: const TextStyle(color: Color(0xFF5D4037), fontSize: 16),
      ),
    );
  }

  Widget _buildBalanceCard(BuildContext context, WalletController controller) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF6D4C41),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Stack(
          children: [
            /// Pattern Background
            Positioned.fill(
              child: Opacity(
                opacity: 0.1,
                child: AppImage(
                  url: "https://picsum.photos/seed/pattern/500/500",
                  path: "assets/images/network_placeholder_image.jpg",
                  fit: BoxFit.cover,
                ),
              ),
            ),

            /// Decorative Circle
            Positioned(
              right: -30,
              top: -30,
              child: Container(
                width: 150.r,
                height: 150.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
              ),
            ),

            /// Content
            Padding(
              padding: EdgeInsets.all(20.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Current Balance",
                    style: AppTextStyles.regular(
                      14,
                    ).copyWith(color: Colors.white.withValues(alpha: 0.8)),
                  ),
                  SizedBox(height: 8.h),
                  Obx(() {
                    return Skeletonizer(
                      enabled: controller.isLoadingBalance.value,
                      child: Text(
                        "${controller.currency.value.isEmpty ? 'QAR' : controller.currency.value} ${controller.balance.value == 0.0 && controller.isLoadingBalance.value ? 250.00 : controller.balance.value.toStringAsFixed(2)}",
                        style: AppTextStyles.bold(
                          28,
                        ).copyWith(color: Colors.white),
                      ),
                    );
                  }),
                  SizedBox(height: 20.h),
                  SizedBox(
                    height: 36.h,
                    child: ElevatedButton(
                      onPressed: () {
                        _showAddMoneyDialog(context, controller);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF6D4C41),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        elevation: 0,
                      ),
                      child: Text(
                        "Add Money",
                        style: AppTextStyles.medium(14).copyWith(
                          color: const Color(0xFF6D4C41),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildPaymentMethods(WalletController controller) {
  //   return Column(
  //     children: [
  //       _paymentMethodItem(
  //         controller,
  //         index: 0,
  //         label: "Apple pay",
  //         icon: Icons.apple,
  //       ),
  //       SizedBox(height: 12.h),
  //       _paymentMethodItem(
  //         controller,
  //         index: 1,
  //         label: "Google pay",
  //         icon: Icons.g_mobiledata, // Best approximation or use custom asset
  //       ),
  //       SizedBox(height: 12.h),
  //       _paymentMethodItem(
  //         controller,
  //         index: 2,
  //         label: "Credit/Debit",
  //         icon: Icons.credit_card,
  //       ),
  //     ],
  //   );
  // }

  // Widget _paymentMethodItem(
  //   WalletController controller, {
  //   required int index,
  //   required String label,
  //   required IconData icon,
  // }) {
  //   return Obx(() {
  //     final isSelected = controller.selectedPaymentMethod.value == index;
  //     return GestureDetector(
  //       onTap: () => controller.selectPaymentMethod(index),
  //       child: Container(
  //         padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
  //         decoration: BoxDecoration(
  //           color: const Color(0xFF6D4C41), // Dark brown background
  //           borderRadius: BorderRadius.circular(12.r),
  //         ),
  //         child: Row(
  //           children: [
  //             Container(
  //               width: 40.w,
  //               height: 40.w,
  //               decoration: const BoxDecoration(
  //                 color: Colors.white,
  //                 shape: BoxShape.circle,
  //               ),
  //               child: Icon(icon, color: Colors.black, size: 24.r),
  //             ),
  //             SizedBox(width: 16.w),
  //             Expanded(
  //               child: Text(
  //                 label,
  //                 style: AppTextStyles.medium(16).copyWith(
  //                   color: const Color(0xFFD7CCC8), // Light beige text
  //                 ),
  //               ),
  //             ),
  //             Container(
  //               width: 24.w,
  //               height: 24.w,
  //               decoration: BoxDecoration(
  //                 shape: BoxShape.circle,
  //                 border: Border.all(color: const Color(0xFFD7CCC8), width: 2),
  //               ),
  //               child: isSelected
  //                   ? Center(
  //                       child: Container(
  //                         width: 12.w,
  //                         height: 12.w,
  //                         decoration: const BoxDecoration(
  //                           color: Colors.white,
  //                           shape: BoxShape.circle,
  //                         ),
  //                       ),
  //                     )
  //                   : null,
  //             ),
  //           ],
  //         ),
  //       ),
  //     );
  //   });
  // }

  Widget _buildPaymentHistory(WalletController controller) {
    return Obx(() {
      final isLoading = controller.isLoadingHistory.value;
      final items = isLoading
          ? List.generate(
              3,
              (index) => TransactionModel(
                id: 'mock_$index',
                type: 'DEPOSIT',
                amount: 100.0,
                balanceBefore: 0.0,
                balanceAfter: 100.0,
                description: 'Wallet Topup via Gateway',
                referenceId: 'REF-123456',
                createdAt: DateTime.now(),
              ),
            )
          : controller.historyList;

      if (!isLoading && items.isEmpty) {
        return Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 30.h),
            child: Text(
              "No transaction history found",
              style: AppTextStyles.medium(16).copyWith(color: Colors.grey),
            ),
          ),
        );
      }

      return Skeletonizer(
        enabled: isLoading,
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length + (controller.isLoadingMore.value ? 1 : 0),
          separatorBuilder: (context, index) => SizedBox(height: 12.h),
          itemBuilder: (context, index) {
            if (index == items.length) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.buttonPrimaryColor,
                  ),
                ),
              );
            }

            final item = items[index];
            final isCredit = item.type.toUpperCase() == 'DEPOSIT';
            final formattedDate = DateFormat(
              'dd MMM yyyy, hh:mm a',
            ).format(item.createdAt);

            return Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: const Color(0xFFEBE3D9), // Light creamy card color
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isCredit ? Icons.arrow_back : Icons.arrow_outward,
                      color: isCredit ? Colors.green : Colors.red,
                      size: 20.r,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.description.isNotEmpty
                              ? item.description
                              : item.type,
                          style: AppTextStyles.medium(16).copyWith(
                            color: AppColors.headlineColor,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          formattedDate,
                          style: AppTextStyles.regular(
                            12,
                          ).copyWith(color: Colors.grey[600]),
                        ),
                        if (item.referenceId.isNotEmpty) ...[
                          SizedBox(height: 2.h),
                          Text(
                            'Ref: ${item.referenceId}',
                            style: AppTextStyles.regular(
                              10,
                            ).copyWith(color: Colors.grey[500]),
                          ),
                        ],
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    "${isCredit ? '+' : '-'}${controller.currency.value.isEmpty ? 'QAR' : controller.currency.value} ${item.amount.toStringAsFixed(2)}",
                    style: AppTextStyles.medium(14).copyWith(
                      color: isCredit ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    });
  }

  void _showAddMoneyDialog(BuildContext context, WalletController controller) {
    controller.amountCtrl.clear();
    final RxString selectedQuickAmount = ''.obs;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          backgroundColor: const Color(0xffEBE3D9),
          elevation: 10,
          child: Padding(
            padding: EdgeInsets.all(20.r),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Add Money",
                        style: AppTextStyles.bold(
                          20,
                        ).copyWith(color: const Color(0xFF6D4C41)),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close, color: Color(0xFF6D4C41)),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    "Enter the amount you want to add to your wallet.",
                    style: AppTextStyles.regular(14).copyWith(
                      color: const Color(0xFF5D4037).withValues(alpha: 0.8),
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // Amount Input field
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: controller.amountCtrl,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      onChanged: (val) {
                        selectedQuickAmount.value = '';
                      },
                      inputFormatters: [DecimalTextInputFormatter()],
                      style: AppTextStyles.bold(
                        18,
                      ).copyWith(color: const Color(0xFF6D4C41)),

                      decoration: InputDecoration(
                        prefixIcon: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 12.h,
                          ),
                          child: Text(
                            controller.currency.value,
                            style: AppTextStyles.bold(
                              16,
                            ).copyWith(color: const Color(0xFF6D4C41)),
                          ),
                        ),
                        prefixIconConstraints: const BoxConstraints(
                          minWidth: 0,
                          minHeight: 0,
                        ),
                        hintText: "0.00",
                        hintStyle: AppTextStyles.regular(
                          18,
                        ).copyWith(color: Colors.grey[400]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 16.h,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15.h),

                  // Quick amounts
                  Text(
                    "Quick Select",
                    style: AppTextStyles.medium(
                      14,
                    ).copyWith(color: const Color(0xFF6D4C41)),
                  ),
                  SizedBox(height: 8.h),
                  Obx(() {
                    return Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: ['10', '20', '50', '100', '200', '500'].map((
                        amt,
                      ) {
                        final isSelected = selectedQuickAmount.value == amt;
                        return GestureDetector(
                          onTap: () {
                            selectedQuickAmount.value = amt;
                            controller.amountCtrl.text = amt;
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 10.h,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF6D4C41)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(30.r),
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFF6D4C41)
                                    : const Color(0xFFD7CCC8),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              "+${controller.currency.value} $amt",
                              style: AppTextStyles.medium(13).copyWith(
                                color: isSelected
                                    ? Colors.white
                                    : const Color(0xFF6D4C41),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  }),
                  SizedBox(height: 25.h),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 48.h,
                          child: OutlinedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFF6D4C41)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                            ),
                            child: Text(
                              "Cancel",
                              style: AppTextStyles.medium(
                                14,
                              ).copyWith(color: const Color(0xFF6D4C41)),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: SizedBox(
                          height: 48.h,
                          child: Obx(() {
                            final loading = controller.isToppingUp.value;
                            return ElevatedButton(
                              onPressed: loading
                                  ? null
                                  : () async {
                                      final double? parsedAmount =
                                          double.tryParse(
                                            controller.amountCtrl.text,
                                          );
                                      if (parsedAmount == null ||
                                          parsedAmount <= 0) {
                                        AppSnackBar.error(
                                          "Please enter a valid amount",
                                        );
                                        return;
                                      }
                                      final String? paymentUrl =
                                          await controller.topUpWallet(
                                            parsedAmount,
                                          );
                                      if (paymentUrl != null &&
                                          paymentUrl.isNotEmpty) {
                                        if (context.mounted) {
                                          Navigator.of(
                                            context,
                                          ).pop(); // Dismiss dialog first
                                        }
                                        await controller.openPaymentBrowser(
                                          paymentUrl,
                                        );
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF6D4C41),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                elevation: 0,
                              ),
                              child: loading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Text(
                                      "Proceed",
                                      style: AppTextStyles.medium(14).copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
