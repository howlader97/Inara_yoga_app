import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../utils/app_size.dart';
import 'package:get/get.dart';
import '../../../../models/store_product_model.dart';
import '../../../data/app_text_styles.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/app_image/app_image.dart';
import '../controllers/store_controller.dart';

class StoreView extends GetView<StoreController> {
  const StoreView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Obx(() {
            final isLoading = controller.isLoading.value;
            final products = controller.products;

            if (!isLoading && products.isEmpty) {
              return Center(child: Text("No data found"));
            }

            final displayList = isLoading
                ? List.generate(
                    4,
                    (index) => StoreProductModel(
                      id: 'mock_$index',
                      name: 'Premium Leather Training Gloves',
                      thumbnail: '',
                      shortDescription: 'Workout gloves',
                      stockQuantity: 10,
                      price: 245.0,
                      status: 'ACTIVE',
                    ),
                  )
                : products;

            return Skeletonizer(
              enabled: isLoading,
              child: GridView.builder(
                physics: isLoading
                    ? const NeverScrollableScrollPhysics()
                    : const AlwaysScrollableScrollPhysics(),
                controller: controller.scrollController,
                padding: EdgeInsets.only(bottom: 80.h),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.70, // Adjusted for image + text height
                  crossAxisSpacing: 15.w,
                  mainAxisSpacing: 20.h,
                ),
                itemCount: displayList.length,
                itemBuilder: (context, index) {
                  final product = displayList[index];
                  return _buildProductCard(product);
                },
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildProductCard(StoreProductModel product) {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.productDetails, arguments: product.id),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  height: AppSize.size.height * 0.5,
                  width: AppSize.size.width * 0.5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    color: Colors.grey[300],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: AppImage(
                      url: product.thumbnail,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 180.h, // adjust height as needed
                      networkPlaceholderImage:
                          "assets/images/network_placeholder_image.jpg",
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10.h,
                  left: 10.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: product.stockQuantity == 0
                          ? Colors.black.withValues(alpha: 0.7)
                          : const Color(
                              0xFF6D4C41,
                            ).withValues(alpha: 0.8), // Dark brown/transparent
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      product.stockQuantity == 0
                          ? "Out of stock"
                          : "Available ${product.stockQuantity}",
                      style: AppTextStyles.medium(
                        10,
                      ).copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            product.name,
            style: AppTextStyles.medium(
              14,
            ).copyWith(color: const Color(0xFF6D4C41), height: 1.2),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 5.h),
          Text(
            "${product.price}",
            style: AppTextStyles.bold(
              16,
            ).copyWith(color: const Color(0xFF4E342E)),
          ),
        ],
      ),
    );
  }
}
