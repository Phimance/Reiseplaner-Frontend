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
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  'Alle Rechnungen sind beglichen',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 12),
          child: Text(
            'Saldo',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 20,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: salden.length,
                    itemBuilder: (context, index) {
                      final saldo = salden[index];
                      final bool isPositive = saldo.netBalance > 0.01;
                      final bool isNegative = saldo.netBalance < -0.01;

                      final isFirst = index == 0;
                      final isLast = index == salden.length - 1;
                      final radius = BorderRadius.only(
                        topLeft: isFirst
                            ? const Radius.circular(24)
                            : Radius.zero,
                        topRight: isFirst
                            ? const Radius.circular(24)
                            : Radius.zero,
                        bottomLeft: isLast
                            ? const Radius.circular(24)
                            : Radius.zero,
                        bottomRight: isLast
                            ? const Radius.circular(24)
                            : Radius.zero,
                      );

                      return ListTile(
                        shape: RoundedRectangleBorder(borderRadius: radius),
                        onTap: () => onSettleTapped?.call(saldo),
                        leading: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.shadow,
                                blurRadius: 6,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            backgroundColor: AppColors.primary,
                            radius: 18,
                            child: Text(
                              saldo.name[0].toUpperCase(),
                              style: const TextStyle(
                                color: AppColors.textOnPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
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
                              const Icon(
                                Icons.payment,
                                color: AppColors.textSecondary,
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                            ],
                            Text(
                              '${saldo.netBalance.abs().toStringAsFixed(2)}€',
                              style: TextStyle(
                                color: isPositive
                                    ? AppColors.amountGreen
                                    : isNegative
                                    ? AppColors.error
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
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 12),
        Divider(),
        SizedBox(height: 12),
      ],
    );
  }
}
