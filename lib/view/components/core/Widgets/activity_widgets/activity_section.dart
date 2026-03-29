import 'activity_item.dart';
import 'package:flutter/material.dart';
import '../../../../theme/app_colors.dart';

class DaySection extends StatelessWidget {
  final List<ActivityItem> items;
  final String? day;

  const DaySection({
    super.key,
    required this.items,
    this.day,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (day != null && day!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 12, bottom: 4),
            child: Text(
              day!,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ...items.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: item,
        )).toList(),
      ],
    );
  }
}
