import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../api/models/models.dart';
import '../../../../core/app_state.dart';
import '../../../../view/theme/app_colors.dart';
import 'TransactionListItem.dart';

class TransactionList extends StatelessWidget {
  final List<Transaktion> transaktionen;
  final int previewCount;

  const TransactionList({
    super.key,
    required this.transaktionen,
    this.previewCount = 3,
  });

  @override
  Widget build(BuildContext context) {
    final benutzername = context.read<AppState>().benutzername;

    if (transaktionen.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Text(
          'Noch keine Transaktionen vorhanden.',
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    final visible = transaktionen.sublist(
      0,
      transaktionen.length > previewCount ? previewCount : transaktionen.length,
    );

    return TransactionCard(
      items: visible.map((t) {
        final eigenerAnteil = t.transaktionspersonen
            .where((tp) => tp.schuldner == benutzername)
            .fold(0.0, (sum, tp) => sum + tp.anteil);

        final double betrag;
        final Color farbe;
        final String prefix;

        if (t.bezahlername == benutzername) {
          // Nutzer hat bezahlt → bekommt den Rest zurück
          betrag = t.gesamtwert - eigenerAnteil;
          farbe = AppColors.secondary;
          prefix = '+';
        } else if (eigenerAnteil > 0) {
          // Nutzer ist Schuldner
          betrag = eigenerAnteil;
          farbe = AppColors.error;
          prefix = '-';
        } else {
          betrag = 0;
          farbe = AppColors.textSecondary;
          prefix = '';
        }

        return TransactionListItem(
          icon: Icons.receipt_long,
          title: t.transaktionsname,
          subtitle: '${t.bezahlername} zahlte ${t.gesamtwert.toStringAsFixed(2)} €',
          amount: '$prefix${betrag.toStringAsFixed(2)} €',
          amountColor: farbe,
        );
      }).toList(),
      onShowMore: transaktionen.length > previewCount ? () {} : null,
    );
  }
}

