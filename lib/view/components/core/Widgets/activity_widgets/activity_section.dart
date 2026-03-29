import 'activity_item.dart';
import 'package:flutter/material.dart';
import '../../../../theme/app_colors.dart';

class DaySection extends StatelessWidget {
  final List<ActivityItem> items;
  final String? day;
  final bool isLeft;

  const DaySection({
    super.key,
    required this.items,
    this.day,
    this.isLeft = false
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (day != null && day!.isNotEmpty)
          Align(
            alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
            child: Padding(
              padding: isLeft ? EdgeInsets.only(left: 12, bottom: 6) : EdgeInsets.only(right: 20, bottom: 2),
              child: Text(
                day!,
                style:
                  isLeft?
                  Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textSecondary,
                  ) :
                  Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textSecondary,
                  ),
              ),
            ),
          ),
        SizedBox(
          width: double.infinity,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Card(
              margin: EdgeInsets.zero,
              elevation: 0,
              color: AppColors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (int i = 0; i < items.length; i++) ...[
                    if (i > 0)
                      const Divider(
                        color: AppColors.divider,
                        height: 1,
                        indent: 20,
                        endIndent: 20,
                      ),
                    items[i],
                  ],
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
