import 'package:flutter/material.dart';
import '../../../data/app_colors.dart';
import '../../../utils/app_size.dart';

class GenderIconsRow extends StatelessWidget {
  const GenderIconsRow({super.key, required this.gender});
  final String? gender;

  @override
  Widget build(BuildContext context) {
    final classGender = (gender ?? '').trim().toLowerCase();
    return Row(
      children: [
        if (classGender == 'male' || classGender == 'both')
          Icon(Icons.male, size: 20.r, color: AppColors.headlineColor),
        if (classGender == 'female' || classGender == 'both')
          Icon(Icons.female, size: 20.r, color: AppColors.headlineColor),
      ],
    );
  }
}
