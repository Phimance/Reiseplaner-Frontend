import 'package:flutter/material.dart';

class ReiseHeader extends StatefulWidget {
  const ReiseHeader({super.key});

  @override
  State<ReiseHeader> createState() => _ReiseHeaderState();
}

class _ReiseHeaderState extends State<ReiseHeader> {
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Südfrankreichseminar', // Hier später mit Auswahl arbeiten
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: const Icon(Icons.keyboard_arrow_down_outlined, size: 38),
          onPressed: () {

          },
        ),
      ],
    );
  }
}