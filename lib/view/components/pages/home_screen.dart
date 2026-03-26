import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reiseplaner/view/components/pages/reisegruppen/add_transaktion_screen.dart';
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
                  Text('Planer-ID: ${context.watch<AppState>().aktiveGruppe?.planer?.events.isNotEmpty == true ? context.watch<AppState>().aktiveGruppe!.planer!.events[0].beschreibung : "Keine Events vorhanden"}'),
                  Text('Notizblock-ID: ${context.watch<AppState>().aktiveGruppe?.notizblocks.isNotEmpty == true ? context.watch<AppState>().aktiveGruppe!.notizblocks[0].id : "Kein Notizblock vorhanden"}'),
                ],
              ),
            ),
    );
  }
}