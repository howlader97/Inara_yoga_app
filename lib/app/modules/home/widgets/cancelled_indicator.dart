// Cancelled Indicator
import 'package:flutter/material.dart';
import 'package:george/app/data/app_text_styles.dart';

class CancelledIndicator extends StatelessWidget {
  const CancelledIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Cancelled',
      style: AppTextStyles.medium(14, color: Colors.red),
    );
  }
}
