import 'package:flutter/material.dart';
import '../../../../api/models/models.dart';
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
        return TransactionListItem(
          icon: Icons.receipt_long,
          title: t.transaktionsname,
          subtitle: '${t.bezahlername} zahlte ${t.gesamtwert.toStringAsFixed(2)} €',
          amount: '${t.gesamtwert.toStringAsFixed(2)} €',
        );
      }).toList(),
      onShowMore: transaktionen.length > previewCount ? () {} : null,
    );
  }
}

