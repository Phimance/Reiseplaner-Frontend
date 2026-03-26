import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reiseplaner/view/components/pages/reisegruppen/add_transaktion_screen.dart';
import '../../../core/app_state.dart';
import '../core/Widgets/TransactionList.dart';
import '../core/Widgets/Button.dart';

class TransaktionsScreen extends StatefulWidget {
  const TransaktionsScreen({super.key});

  @override
  State<TransaktionsScreen> createState() => _TransaktionsScreenState();
}

class _TransaktionsScreenState extends State<TransaktionsScreen> {
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
    final aktiveGruppe = context.watch<AppState>().aktiveGruppe;
    final transaktionen = aktiveGruppe?.transaktionen ?? [];

    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          children: [
            TransactionList(transaktionen: transaktionen),
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
          ],
        ),
      ),
    );
  }
}