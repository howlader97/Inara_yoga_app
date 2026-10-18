import 'package:flutter/material.dart';
import 'package:george/app/modules/track_progress/widgets/stat_card.dart';
import 'package:george/app/utils/app_size.dart';

class StatCardSection extends StatelessWidget {
  const StatCardSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10.w,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: StatCard(
            icon: Icons.self_improvement,
            title: 'Hatha Yoga',
            subtitle: 'You attend this class the most this month.',
          ),
        ),
        Expanded(
          child: StatCard(
            showIcon: false,
            title: "Jane Doe",
            subtitle: "is your favourite instructor this month.",
          ),
        ),
        Expanded(
          child: StatCard(
            icon: Icons.watch_later_outlined,
            title: "10 months 5 days",
            subtitle: "since you joined us.",
          ),
        ),
      ],
    );
  }
}
