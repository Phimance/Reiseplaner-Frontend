import 'package:flutter/material.dart';
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
    return Center(
      child: _isLoading
          ? const CircularProgressIndicator()
      // Beispielbutton
          : ReiseButton(
            title: 'Ausgabe hinzufügen',
            icon: Icons.add,
            onPressed: () {
              // Aktion hier
            },
          )
    );
  }
}