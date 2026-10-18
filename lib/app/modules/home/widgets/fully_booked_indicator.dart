import 'package:flutter/material.dart';
import '../../../data/app_text_styles.dart';
import '../../../utils/app_size.dart';

class FullyBookedIndicator extends StatelessWidget {
  const FullyBookedIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.group_outlined, size: 18.r, color: Colors.red),
        SizedBox(width: 4.w),
        Text(
          'Fully Booked',
          style: AppTextStyles.medium(14, color: Colors.red),
        ),
      ],
    );
  }
}
