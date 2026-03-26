import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';

class TransactionListItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String amount;
  final Color amountColor;
  final VoidCallback? onTap;

  const TransactionListItem({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.amount,
    this.amountColor = AppColors.amountGreen,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
              ),
            ),
            Text(
              amount,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: amountColor,
                    fontWeight: FontWeight.bold,
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

/// Ein Container-Widget
class TransactionCard extends StatelessWidget {
  final List<TransactionListItem> items;
  final VoidCallback? onShowMore;

  const TransactionCard({
    super.key,
    required this.items,
    this.onShowMore,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
            borderRadius: BorderRadius.circular(24), // Stark abgerundete Ecken wie im Bild
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              ...items,
              if (onShowMore != null) ...[
                const Divider(color: Colors.transparent, height: 8),
                TextButton(
                  onPressed: onShowMore,
                  child: const Text(
                    'mehr anzeigen',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
