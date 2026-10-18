import 'package:flutter/material.dart';

import '../data/app_colors.dart';
import '../utils/app_size.dart';

class CustomCheckBox extends StatelessWidget {
  const CustomCheckBox({super.key, required this.value, this.onChanged});

  final bool value;
  final void Function(bool?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: value,
      onChanged: onChanged,
      activeColor: AppColors.buttonPrimaryColor, // Color when checked
      fillColor: WidgetStateProperty.resolveWith<Color>((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.buttonPrimaryColor; // Fill color when checked
        }
        return AppColors.whiteColor; // Fill color when unchecked
      }),
      checkColor: AppColors.whiteColor, // Check icon color
      side: const BorderSide(color: AppColors.buttonPrimaryColor),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.r)),
    );
  }
}
