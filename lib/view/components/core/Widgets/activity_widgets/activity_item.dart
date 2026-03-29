import 'package:flutter/material.dart';
import '../../../../theme/app_colors.dart';

class ActivityItem extends StatelessWidget {
  final String title;
  final String date;
  final String? location;
  final VoidCallback? onTap;
  final bool isPast;

  const ActivityItem({
    super.key,
    required this.title,
    required this.date,
    this.location,
    this.onTap,
    this.isPast = false,
  });

  @override
  Widget build(BuildContext context) {
    final titleColor = isPast ? AppColors.textSecondary : AppColors.textPrimary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Icon(
              isPast ? Icons.event_available_outlined : Icons.event_outlined,
              color: isPast ? AppColors.textSecondary : AppColors.primary,
              size: 26,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: titleColor,
                        ),
                  ),
                  if (!isPast && location != null && location!.isNotEmpty)
                    Text(
                      location!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                ],
              ),
            ),
            Text(
              date,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right, color: AppColors.textSecondary, size: 20),
          ],
        ),
      ),
    );
  }
}
