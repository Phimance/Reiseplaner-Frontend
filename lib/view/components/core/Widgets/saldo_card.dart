import 'package:flutter/material.dart';
import 'package:reiseplaner/api/data/saldo_calculator.dart';
import 'package:reiseplaner/view/theme/app_colors.dart';

class SaldoCard extends StatelessWidget {
  final List<SaldoResult> salden;
  final Function(SaldoResult)? onSettleTapped;

  const SaldoCard({super.key, required this.salden, this.onSettleTapped});

  @override
  Widget build(BuildContext context) {
    if (salden.isEmpty) {
      return Card(
        color: AppColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              'Alle Rechnungen sind beglichen',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
        ),
      );
    }

    return Card(
      color: AppColors.card,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: salden.length,
        itemBuilder: (context, index) {
          final saldo = salden[index];
          final bool isPositive = saldo.netBalance > 0.01;
          final bool isNegative = saldo.netBalance < -0.01;

          return ListTile(
            onTap: () => onSettleTapped?.call(saldo),
            leading: const CircleAvatar(
              backgroundColor: AppColors.primary,
              radius: 12,
            ),
            title: Text(
              saldo.name,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              saldo.detailText,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isNegative) ...[
                  const Icon(Icons.payment, color: AppColors.textSecondary, size: 16),
                  const SizedBox(width: 8),
                ],
                Text(
                  '${saldo.netBalance.abs().toStringAsFixed(2)}€',
                  style: TextStyle(
                    color: isPositive
                        ? Colors.greenAccent
                        : isNegative
                            ? Colors.redAccent
                            : AppColors.textSecondary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
