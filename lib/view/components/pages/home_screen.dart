import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/app_state.dart';
import '../core/Widgets/TransactionListItem.dart';
import '../core/Widgets/Button.dart';

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

  // 4. Structure: The Build Method
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
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
                  Text('Planer-ID: ${context.watch<AppState>().aktiveGruppe?.planer?.events[0].beschreibung ?? "Keine Gruppe ausgewählt"}'),
                  Text('Notizblock-ID: ${context.watch<AppState>().aktiveGruppe?.notizblocks[0]?.id ?? "Keine Gruppe ausgewählt"}'),
                ],
              ),
            ),
    );
  }
}