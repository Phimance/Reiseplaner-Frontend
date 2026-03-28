import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reiseplaner/view/components/core/Widgets/StatSummaryTile.dart';
import 'package:reiseplaner/view/components/pages/reisegruppen/edit_gruppe_screen.dart';
import '../../../core/app_state.dart';
import '../core/Widgets/TransactionList.dart';
import 'package:reiseplaner/view/components/core/Widgets/SummaryCard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 1. Logic: Variables & State
  bool _isLoading = false;

  // 2. Logic: Lifecycle Methods
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
    final heute = DateTime.now();
    final start = startDate != null ? DateTime.tryParse(startDate) : null;
    final ende = endDate != null ? DateTime.tryParse(endDate) : null;

    if (start != null && heute.isBefore(start)) {
      final diff = start.difference(DateTime(heute.year, heute.month, heute.day)).inDays;
      return (tage: diff, label: 'Tage bis Start');
    } else if (ende != null && heute.isBefore(ende)) {
      final diff = ende.difference(DateTime(heute.year, heute.month, heute.day)).inDays;
      return (tage: diff, label: 'Tage noch');
    } else {
      return (tage: 0, label: 'Reise beendet');
    }
  }

  // 4. Structure: The Build Method
  @override
  Widget build(BuildContext context) {
    final gruppe = context.watch<AppState>().aktiveGruppe;
    final transaktionen = gruppe?.transaktionen ?? [];
    final benutzername = context.read<AppState>().benutzername;
    final saldo = _berechneSaldo(transaktionen, benutzername);
    final saldoText = '${saldo >= 0 ? '+' : ''}${saldo.toStringAsFixed(2)} €';
    final tageInfo = _berechneTage(gruppe?.startDate, gruppe?.endDate);
    /* final eventsLeft = gruppe?.events.where((e) {
      final eventDate = DateTime.tryParse(e.datum);
      return eventDate != null && eventDate.isAfter(DateTime.now());
    }).length ?? 0; */
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  //test der summary card
                  SummaryCard(
                    title: gruppe?.location ?? 'Reisegruppe',
                    dateRange: '${_formatDate(gruppe?.startDate)} - ${_formatDate(gruppe?.endDate)}',
                    avatars: gruppe?.benutzer
                            .map((b) => b.name.isNotEmpty ? b.name[0].toUpperCase() : '?')
                            .toList() ??
                        [],
                    onSettings: () {
                      Navigator.push(
                        context,
                          MaterialPageRoute(
                            builder: (_) => EditGruppeScreen(gruppe: gruppe!),
                          ),
                        );
                      },
                    ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(child:
                        StatSummaryTile(
                          icon: saldo >= 0 ? Icons.trending_up : Icons.trending_down,
                          value: saldoText,
                          label: 'Mein Saldo',
                        ),
                      ),
                      SizedBox(width: 12),
                      StatSummaryTile(
                        icon: Icons.access_time_outlined,
                        value: tageInfo.tage.toString(),
                        label: tageInfo.label,
                      ),
                      SizedBox(width: 12),
                      StatSummaryTile(icon: Icons.calendar_today_outlined, value: "", label: "Events"),
                    ],
                  ),
                  SizedBox(height: 12),
                  TransactionList(transaktionen: transaktionen)
                ],
              ),
            ),
    );
  }
}