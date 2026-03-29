import 'package:flutter/material.dart';
import '../../../../api/data/saldo_calculator.dart';
import '../../../theme/app_colors.dart';

class SaldoCard extends StatelessWidget {
  final List<SaldoResult> salden;

  const SaldoCard({super.key, required this.salden});

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
            trailing: Text(
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
          );
        },
      ),
    );
  }
}
