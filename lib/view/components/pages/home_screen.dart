import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:reiseplaner/view/components/pages/reisegruppen/edit_gruppe_screen.dart';
import '../../../core/app_state.dart';
import '../core/Widgets/TransactionListItem.dart';
import '../core/Widgets/Button.dart';
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

  // 4. Structure: The Build Method
  @override
  Widget build(BuildContext context) {
    final gruppe = context.watch<AppState>().aktiveGruppe;
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
                  TransactionCard(
                    items: const [
                      TransactionListItem(
                        icon: Icons.directions_car_filled_outlined,
                        title: 'Hin- und Rückflug',
                        subtitle: 'Phillip zahlte 1001€ am 10.07.2026',
                        amount: '250,25€',
                      ),
                      TransactionListItem(
                        icon: Icons.directions_car_filled_outlined,
                        title: 'Hin- und Rückflug',
                        subtitle: 'Phillip zahlte 1001€ am 10.07.2026',
                        amount: '250,25€',
                      ),
                      TransactionListItem(
                        icon: Icons.directions_car_filled_outlined,
                        title: 'Hin- und Rückflug',
                        subtitle: 'Phillip zahlte 1001€ am 10.07.2026',
                        amount: '250,25€',
                      ),
                    ],
                    onShowMore: () => print('Mehr anzeigen geklickt'),
                  ),
                  const SizedBox(height: 12),
                  ReiseButton(
                    title: 'Ausgabe hinzufügen',
                    icon: Icons.add,
                    onPressed: () {
                      // Aktion hier
                    },
                  ),
                ],
              ),
            ),
    );
  }
}