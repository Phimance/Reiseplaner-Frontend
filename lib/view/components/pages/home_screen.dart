import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:reiseplaner/view/components/core/Widgets/StatSummaryTile.dart';
import 'package:reiseplaner/view/components/pages/add_entity/edit_gruppe_screen.dart';
import 'package:reiseplaner/view/components/pages/add_entity/add_gruppe_screen.dart';
import '../../../core/app_state.dart';
import '../../theme/app_colors.dart';
import '../core/Widgets/Button.dart';
import '../core/Widgets/TransactionList.dart';
import 'package:reiseplaner/view/components/core/Widgets/SummaryCard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  @override
  void dispose() {
    // Clean up controllers or listeners here
    super.dispose();
  }

  // 3. Logic: Functional Methods
  Future<void> _loadInitialData() async {
    setState(() => _isLoading = true);

    // Add your data fetching or logic here
    setState(() => _isLoading = false);
  }

  String _formatDate(String? date) {
    if (date == null || date.isEmpty) return '';
    final dt = DateTime.tryParse(date);
    if (dt == null) return date;
    return DateFormat('d. MMMM yyyy', 'de').format(dt);
  }

  double _berechneSaldo(List<dynamic> transaktionen, String benutzername) {
    double saldo = 0;
    for (final t in transaktionen) {
      final eigenerAnteil = t.transaktionspersonen
          .where((tp) => tp.schuldner == benutzername)
          .fold(0.0, (sum, tp) => sum + tp.anteil);
      if (t.bezahlername == benutzername) {
        saldo += t.gesamtwert - eigenerAnteil;
      } else {
        saldo -= eigenerAnteil;
      }
    }
    return saldo;
  }

  ({int tage, String label}) _berechneTage(String? startDate, String? endDate) {
    // 1. Alles auf UTC Mitternacht normalisieren
    final nun = DateTime.now();
    final heute = DateTime.utc(nun.year, nun.month, nun.day);

    final startRaw = startDate != null ? DateTime.tryParse(startDate) : null;
    final endeRaw = endDate != null ? DateTime.tryParse(endDate) : null;

    // Wenn keine Daten da sind, direkt raus
    if (startRaw == null || endeRaw == null) return (tage: 0, label: 'Kein Datum');

    final start = DateTime.utc(startRaw.year, startRaw.month, startRaw.day);
    final ende = DateTime.utc(endeRaw.year, endeRaw.month, endeRaw.day);

    // FALL A: Vor der Reise
    if (heute.isBefore(start)) {
      final diff = start.difference(heute).inDays;
      // Hier KEIN +1, denn wenn heute der 29. und Start der 30. ist, ist es genau 1 Tag.
      return (tage: diff, label: diff == 1 ? 'Tag bis Start' : 'Tage bis Start');
    }

    // FALL B: Während der Reise (Heute ist Starttag oder danach)
    else if (!heute.isAfter(ende)) {
      // Hier +1, weil der heutige Tag als voller Reisetag zählt
      final diff = ende.difference(heute).inDays;
      return (tage: diff, label: diff == 1 ? 'Letzter Tag' : 'Tage noch');
    }

    // FALL C: Reise vorbei
    else {
      return (tage: 0, label: 'Reise beendet');
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final gruppe = appState.aktiveGruppe;

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (gruppe == null) {
      return const EmptyTripState();
    }

    final transaktionen = gruppe.transaktionen;
    final benutzername = appState.benutzername;
    final saldo = _berechneSaldo(transaktionen, benutzername);
    final saldoText = '${saldo >= 0 ? '+' : ''}${saldo.toStringAsFixed(2)} €';
    final tageInfo = _berechneTage(gruppe.startDate, gruppe.endDate);

    return SingleChildScrollView(
      child: Column(
        children: [
          SummaryCard(
            title: (gruppe.location != null && gruppe.location!.isNotEmpty)
                ? gruppe.location!
                : gruppe.name,
            dateRange: '${_formatDate(gruppe.startDate)} - ${_formatDate(gruppe.endDate)}',
            avatars: gruppe.benutzer
                    .map((b) => b.name.isNotEmpty ? b.name[0].toUpperCase() : '?')
                    .toList(),
            onSettings: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditGruppeScreen(gruppe: gruppe),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: StatSummaryTile(
                  icon: saldo >= 0 ? Icons.trending_up : Icons.trending_down,
                  value: saldoText,
                  label: 'Mein Saldo',
                ),
              ),
              const SizedBox(width: 12),
              StatSummaryTile(
                icon: Icons.access_time_outlined,
                value: tageInfo.tage.toString(),
                label: tageInfo.label,
              ),
              const SizedBox(width: 12),
              const StatSummaryTile(
                icon: Icons.calendar_today_outlined,
                value: "",
                label: "Events",
              ),
            ],
          ),
          const SizedBox(height: 12),
          TransactionList(transaktionen: transaktionen)
        ],
      ),
    );
  }
}

class EmptyTripState extends StatelessWidget {
  const EmptyTripState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 60),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.explore_outlined,
              size: 64,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 24),
            const Text(
              'Keine Reise in Sicht',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Erstelle eine neue Reisegruppe.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 32),
            ReiseButton(
              title: 'Reisegruppe erstellen',
              icon: Icons.add_circle_outline,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddGruppeScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}