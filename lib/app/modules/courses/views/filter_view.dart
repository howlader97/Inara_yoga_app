import 'package:flutter/material.dart';
import '../../../utils/app_size.dart';
import '../../../widgets/custom_appbar.dart';
import '../../../widgets/custom_elevated_button.dart';
import 'package:get/get.dart';
import '../../../data/app_colors.dart';
import '../../../data/app_text_styles.dart';
import '../controllers/filter_controller.dart';

class FilterView extends GetView<FilterController> {
  const FilterView({super.key});

  @override
  Widget build(BuildContext context) {
    // Variable to track expansion locally if needed, but we can also put it in controller
    final RxBool isInstructorExpanded = false.obs;
    final RxBool isClassExpanded = false.obs;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomAppBar(
        title: 'Filter',
        showAction: true,
        actionOnTap: () => controller.clearFilter(),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Instructor Section ---
                    Text(
                      'Search by instructor name',
                      style: AppTextStyles.regular(
                        14,
                        color: AppColors.headlineColor,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Obx(
                      () => _buildAccordion(
                        title: controller.selectedInstructor.value.isNotEmpty
                            ? controller.selectedInstructor.value
                            : 'Select an instructor',
                        isExpanded: isInstructorExpanded.value,
                        onTap: () => isInstructorExpanded.toggle(),
                        content: _buildSearchableList(
                          hintText: 'Search by Instructor name',
                          items: controller.instructors.value,
                          onSearchChanged: (val) =>
                              controller.instructorSearch.value = val,
                          onChanged: (name) {
                            controller.selectedInstructor.value = name;
                            isInstructorExpanded.value = false;
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      'Class name',
                      style: AppTextStyles.regular(
                        14,
                        color: AppColors.headlineColor,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Obx(
                      () => _buildAccordion(
                        title: controller.selectedClass.value.isNotEmpty
                            ? controller.selectedClass.value
                            : 'Select a class name',
                        isExpanded: isClassExpanded.value,
                        onTap: () => isClassExpanded.toggle(),
                        content: _buildSearchableList(
                          hintText: 'Search by Class Name',
                          items: controller.classes.value,
                          onSearchChanged: (val) =>
                              controller.classSearch.value = val,
                          onChanged: (name) {
                            controller.selectedClass.value = name;
                            isClassExpanded.value = false;
                          },
                        ),
                      ),
                    ),

                    SizedBox(height: 24.h),
                    Text(
                      'Difficulty Level',
                      style: AppTextStyles.regular(
                        14,
                        color: AppColors.headlineColor,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Obx(
                      () => Wrap(
                        spacing: 12.w,
                        runSpacing: 12.h,
                        children: controller.difficulties.map((level) {
                          final isSelected =
                              level == controller.selectedDifficulty.value;
                          return GestureDetector(
                            onTap: () => controller.selectedDifficulty.value =
                                isSelected ? '' : level,
                            child: _buildChip(level, isSelected),
                          );
                        }).toList(),
                      ),
                    ),

                    SizedBox(height: 24.h),
                    Text(
                      'Gender',
                      style: AppTextStyles.regular(
                        14,
                        color: AppColors.headlineColor,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Obx(
                      () => Wrap(
                        spacing: 12.w,
                        runSpacing: 12.h,
                        children: controller.genders.map((gender) {
                          final isSelected =
                              gender == controller.selectedGender.value;
                          return GestureDetector(
                            onTap: () => controller.selectedGender.value =
                                isSelected ? '' : gender,
                            child: _buildChip(gender, isSelected),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(24.w),
              child: CustomElevetedButton(
                onTap: () => controller.applyFilter(),
                buttonText: 'Apply Filter',
                backgroundColor: AppColors.buttonPrimaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccordion({
    required String title,
    required bool isExpanded,
    required VoidCallback onTap,
    required Widget content,
  }) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: AppColors.cardBackgroundColor,
              borderRadius: isExpanded
                  ? BorderRadius.vertical(top: Radius.circular(12.r))
                  : BorderRadius.circular(12.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.regular(
                      14,
                      color: AppColors.headlineColor.withValues(alpha: 0.6),
                    ),
                  ),
                ),
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: AppColors.headlineColor,
                ),
              ],
            ),
          ),
        ),
        if (isExpanded)
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(12.r),
              ),
            ),
            padding: EdgeInsets.all(16.r),
            child: content,
          ),
      ],
    );
  }

  Widget _buildSearchableList({
    required String hintText,
    required List<String> items,
    required Function(String) onSearchChanged,
    required Function(String) onChanged,
  }) {
    // Add this to filter items based on search text
    final searchTerm = hintText.contains('Instructor')
        ? controller.instructorSearch.value.toLowerCase()
        : controller.classSearch.value.toLowerCase();

    final filteredItems = items
        .where((item) => item.toLowerCase().contains(searchTerm))
        .toList();

    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            color: const Color(0xFFDCD3CB),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: TextField(
            onChanged: onSearchChanged,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search, color: Colors.grey, size: 20.sp),
              hintText: hintText,
              hintStyle: AppTextStyles.regular(14, color: Colors.grey),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
            ),
          ),
        ),
        SizedBox(height: 12.h),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filteredItems.length, // Use filteredItems instead of items
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            final item = filteredItems[index]; // Use filteredItems
            return Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: GestureDetector(
                onTap: () =>
                    onChanged(item), // FIXED: Now passes the item correctly
                behavior: HitTestBehavior.opaque,
                child: Row(
                  children: [
                    SizedBox(
                      width: 24.w,
                      height: 24.w,
                      child: Checkbox(
                        value:
                            item == controller.selectedInstructor.value ||
                            item == controller.selectedClass.value,
                        onChanged: (_) {
                          onChanged(
                            item,
                          ); // FIXED: Now passes the item instead of empty string
                        },
                        activeColor: AppColors.buttonPrimaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        side: BorderSide(
                          color: AppColors.headlineColor,
                          width: 1.5,
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        item,
                        style: AppTextStyles.regular(
                          16,
                          color: AppColors.headlineColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildChip(String label, bool isSelected) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.buttonPrimaryColor
            : const Color(0xFFB7B0A8).withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(100.r),
        border: Border.all(
          color: isSelected
              ? Colors.transparent
              : AppColors.headlineColor.withValues(alpha: 0.1),
        ),
      ),
      child: Text(
        label,
        style: AppTextStyles.medium(
          14,
          color: isSelected
              ? Colors.white
              : AppColors.headlineColor.withValues(alpha: 0.8),
        ),
      ),
    );
  }
}
