import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../models/product_details_model.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/app_size.dart';
import '../../../widgets/app_image/app_image.dart';
import '../../../widgets/image_top_button.dart';
import 'package:get/get.dart';
import '../../../data/app_colors.dart';
import '../../../data/app_text_styles.dart';
import '../controllers/product_details_controller.dart';

class ProductDetailsView extends GetView<ProductDetailsController> {
  const ProductDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Obx(() {
        final isLoading = controller.isLoading.value;
        final product = isLoading
            ? ProductDetailsModel(
                id: 'mock',
                name: 'Premium Eco Yoga Mat',
                description:
                    'This is a high quality yoga mat description mockup text. It is designed to show how paragraphs look under skeleton loading state. It is very soft and durable.',
                shortDescription: 'Premium yoga mat',
                material: 'Natural Rubber',
                dimensions: '183cm x 61cm x 4mm',
                price: 245.0,
                totalPrice: 245.0,
                quantity: 1,
                stockQuantity: 10,
                images: ['', ''],
                thumbnail: '',
                weight: 2.5,
                color: 'Sage Green',
                size: 'Standard',
                sku: 'YOGA-MAT-001',
                tags: ['Yoga', 'Mat', 'Eco'],
                slug: 'eco-yoga-mat',
                status: 'ACTIVE',
                isFeatured: true,
                viewCount: 100,
                salesCount: 10,
                averageRating: 4.8,
                totalReviews: 24,
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              )
            : controller.productDetails.value;

        if (!isLoading && product == null) {
          return const Center(child: Text("Product not found"));
        }

        return Skeletonizer(
          enabled: isLoading,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 0.5.sh,
                child: AppImage(
                  url: product!.thumbnail,
                  networkPlaceholderImage:
                      "assets/images/network_placeholder_image.jpg", // fallback image
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 0.5.sh,
                ),
              ),

              Positioned(
                top: 50.h,
                left: 20.w,
                child: ImageTopButton(onTap: () => Get.back()),
              ),

              // Content Overlay
              Positioned.fill(
                top: 0.35.sh,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.backgroundColor,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30.r),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 100.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Thumbnails
                        if (product.images.isNotEmpty)
                          SizedBox(
                            height: 100.h,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: product.images.length > 3
                                  ? 3
                                  : product.images.length,
                              separatorBuilder: (context, index) =>
                                  SizedBox(width: 12.w),
                              itemBuilder: (context, index) {
                                return Container(
                                  width: 104.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: AppImage(
                                    url: product.images[index],
                                    fit: BoxFit.cover,
                                    width: 104.w,
                                    height: 104.w, // adjust if needed
                                    networkPlaceholderImage:
                                        "assets/images/network_placeholder_image.jpg",
                                  ),
                                );
                              },
                            ),
                          ),
                        SizedBox(height: 8.h),
                        _buildInfoSection("Material:", product.material),
                        SizedBox(height: 6.h),

                        _buildInfoSection("Dimensions:", product.dimensions),
                        SizedBox(height: 6.h),
                        Text(
                          'Description',
                          style: AppTextStyles.bold(
                            16,
                          ).copyWith(color: AppColors.headlineColor),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          product.description,
                          style: AppTextStyles.regular(
                            16,
                          ).copyWith(color: AppColors.bodyTextColor),
                        ),
                        SizedBox(height: 6.h),

                        _buildInfoSection(
                          "Pickup Note:",
                          "Available at the studio.",
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          'QAR :${product.price}',
                          style: AppTextStyles.bold(
                            16,
                          ).copyWith(color: AppColors.headlineColor),
                        ),
                        SizedBox(height: 6.h),
                        Obx(
                          () => Text(
                            "Total price :${controller.productDetails.value?.totalPrice.toStringAsFixed(2)}",
                            style: AppTextStyles.bold(
                              16,
                            ).copyWith(color: AppColors.headlineColor),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),

              // Footer (Quantity & Buy Now)
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.fromLTRB(25.w, 15.h, 25.w, 30.h),
                  color: AppColors.backgroundColor,
                  child: Row(
                    children: [
                      // Quantity Control
                      Row(
                        children: [
                          _buildQuantityBtn(
                            icon: Icons.remove,
                            onTap: controller.decrement,
                          ),
                          SizedBox(width: 20.w),
                          Obx(
                            () => Text(
                              controller.productDetails.value?.quantity
                                      .toString() ??
                                  '0',
                              style: AppTextStyles.bold(24),
                            ),
                          ),
                          SizedBox(width: 20.w),
                          _buildQuantityBtn(
                            icon: Icons.add,
                            onTap: controller.increment,
                          ),
                        ],
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () async {
                          final result = await Get.toNamed(
                            Routes.checkout,
                            arguments: {
                              'product': controller.productDetails.value,
                              'isFromShop': true,
                            },
                          );

                          if (result != null && result is String) {
                            controller.refreshData(result);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.buttonPrimaryColor,
                          padding: EdgeInsets.symmetric(
                            horizontal: 30.w,
                            vertical: 8.h,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          "Buy Now",
                          style: AppTextStyles.bold(
                            16,
                          ).copyWith(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildInfoSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.bold(
            16,
          ).copyWith(color: AppColors.headlineColor),
        ),
        SizedBox(height: 4.h),
        Text(
          content,
          style: AppTextStyles.regular(
            16,
          ).copyWith(color: AppColors.bodyTextColor),
        ),
      ],
    );
  }

  Widget _buildQuantityBtn({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(icon, color: AppColors.bodyTextColor, size: 24.sp),
    );
  }
}
