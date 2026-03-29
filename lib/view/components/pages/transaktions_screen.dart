import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reiseplaner/view/components/pages/add_entity/add_transaktion_screen.dart';
import 'package:reiseplaner/api/auth/api_service.dart';
import 'package:reiseplaner/api/data/saldo_calculator.dart';
import 'package:reiseplaner/core/app_state.dart';
import 'package:reiseplaner/view/theme/app_colors.dart';
import 'package:reiseplaner/view/components/core/Widgets/TransactionList.dart';
import 'package:reiseplaner/view/components/core/Widgets/Button.dart';
import 'package:reiseplaner/view/components/core/Widgets/SaldoCard.dart';
import 'package:reiseplaner/view/components/core/Widgets/PageHeader.dart';

class TransaktionsScreen extends StatefulWidget {
  const TransaktionsScreen({super.key});

  @override
  State<TransaktionsScreen> createState() => _TransaktionsScreenState();
}

class _TransaktionsScreenState extends State<TransaktionsScreen> {
  final ApiService _apiService = ApiService();

  void _showSettleBottomSheet(BuildContext context, SaldoResult saldo, String gruppeId) {
    final myDebts = saldo.debts.where((d) => d.from == saldo.name).toList();

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Schulden von ${saldo.name}',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              if (myDebts.isEmpty)
                const Text(
                  'Keine offenen Schulden zu begleichen.',
                  style: TextStyle(color: AppColors.textSecondary),
                )
              else
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: myDebts.length,
                    itemBuilder: (context, index) {
                      final debt = myDebts[index];
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          'Ausgleich an ${debt.to}',
                          style: const TextStyle(color: AppColors.textPrimary),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${debt.amount.toStringAsFixed(2)}€',
                              style: const TextStyle(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () async {
                                final appState = context.read<AppState>();
                                final messenger = ScaffoldMessenger.of(context);
                                final navigator = Navigator.of(context);

                                final newTransaktion = {
                                  'transaktionsname': 'Ausgleich',
                                  'bezahlername': debt.from,
                                  'gesamtwert': debt.amount,
                                  'transaktionspersonen': [
                                    {'schuldner': debt.to, 'anteil': debt.amount}
                                  ]
                                };

                                navigator.pop();

                                try {
                                  await _apiService.createTransaktion(gruppeId, newTransaktion);
                                  await appState.loadActivities();
                                  messenger.showSnackBar(
                                    const SnackBar(content: Text('Ausgleich gebucht')),
                                  );
                                } catch (e) {
                                  messenger.showSnackBar(
                                    SnackBar(content: Text('Fehler beim Ausgleich: $e')),
                                  );
                                }
                              },
                              child: const Text('Zahlen'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final aktiveGruppe = context.watch<AppState>().aktiveGruppe;

    if (aktiveGruppe == null) {
      return const Scaffold(
        body: Center(
          child: Text(
            'Keine Gruppe ausgewählt',
            style: TextStyle(fontSize: 18, color: AppColors.textPrimary),
          ),
        ),
      );
    }

    final transaktionen = aktiveGruppe.transaktionen;
    final alleBenutzerNamen = aktiveGruppe.benutzer.map((b) => b.name).toList();
    final benutzername = context.watch<AppState>().benutzername;

    final saldenListe = SaldoCalculator.calculateBalances(transaktionen, alleBenutzerNamen);
    final saldo = SaldoCalculator.berechneSaldoFuerBenutzer(transaktionen, benutzername);

    String _buildSaldoSubtitle() {
      if (saldo > 0.01) {
        final names = saldenListe
            .expand((s) => s.debts)
            .where((d) => d.to == benutzername)
            .map((d) => d.from)
            .toSet()
            .toList();
        if (names.isEmpty) return '';
        final shown = names.take(2).join(', ');
        return 'von $shown${names.length > 2 ? '...' : ''}';
      } else if (saldo < -0.01) {
        final names = saldenListe
            .expand((s) => s.debts)
            .where((d) => d.from == benutzername)
            .map((d) => d.to)
            .toSet()
            .toList();
        if (names.isEmpty) return '';
        final shown = names.take(2).join(', ');
        return 'an $shown${names.length > 2 ? '...' : ''}';
      }
      return '';
    }

    final saldoSubtitle = _buildSaldoSubtitle();
    
    return Scaffold(
      body: SingleChildScrollView(
              child: Column(
                children: [
                  PageHeader(
                    label: (saldo > 0) ? "Du bekommst" : (saldo < 0) ? "Du schuldest" : "Saldo ausgeglichen",
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${saldo.abs().toStringAsFixed(2)}€',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        if (saldoSubtitle.isNotEmpty)
                        Padding(
                            padding: const EdgeInsets.only(bottom: 6, left: 12),
                            child: Text(
                              saldoSubtitle,
                              style: const TextStyle(
                                fontSize: 16,
                                color: AppColors.textSecondary,
                              ),
                            ),
                        ),
                      ],
                    )
                  ),
                  const SizedBox(height: 12),
                  SaldoCard(
                    salden: saldenListe,
                    onSettleTapped: (saldo) {
                      if (saldo.netBalance < -0.01) {
                        _showSettleBottomSheet(context, saldo, aktiveGruppe.id);
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  ReiseButton(
                    title: 'Ausgabe hinzufügen',
                    icon: Icons.add,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AddTransaktionScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  TransactionList(transaktionen: transaktionen, limitItems: false),
                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }
}
