import 'package:flutter/material.dart';
import '../../../data/app_text_styles.dart';
import '../../../utils/app_size.dart';
import '../../../widgets/custom_progress.dart';

class AvailableSpotsIndicator extends StatelessWidget {
  final int availableSeats;
  final double progress;

  const AvailableSpotsIndicator({
    super.key,
    required this.availableSeats,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Available spots $availableSeats',
          style: AppTextStyles.regular(10, color: Colors.grey),
        ),
        SizedBox(height: 4.h),
        CustomProgress(
          progress: progress,
          backgroundColor: Color(0xFFD6C8BE),
          progressColor: Color(0xFF6B5345),
        ),
      ],
    );
  }
}
