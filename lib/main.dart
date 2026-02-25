import 'package:flutter/material.dart';
import 'api_service.dart'; // Hier importieren wir deine neue API-Datei!
import 'login_screen.dart';

void main() {
  runApp(const ReiseplanerApp());
}

class ReiseplanerApp extends StatelessWidget {
  const ReiseplanerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reiseplaner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // Hier ist unsere angepasste Liste der Bildschirme! Jetzt wieder mit 2 Elementen.
  final List<Widget> _screens = [
    // --- TAB 1: BACKEND TEST-STATION ---
    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Backend Test-Station', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 30),
        ElevatedButton(
          onPressed: () async {
            final apiService = ApiService();
            try {
              final gruppen = await apiService.getGruppen();
              print('Erfolg! Gruppen geladen: $gruppen');
            } catch (e) {
              print('Fehler beim Laden: $e');
            }
          },
          child: const Text('GET: Alle Gruppen in Konsole laden'),
        ),
        const SizedBox(height: 15),
        ElevatedButton(
          onPressed: () async {
            final apiService = ApiService();
            try {
              await apiService.createGruppe({
                'name': 'Test-Gruppe aus Flutter'
              });
              print('Erfolg: Neue Gruppe erstellt!');
            } catch (e) {
              print('Fehler beim Erstellen: $e');
            }
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.teal.shade100),
          child: const Text('POST: Neue Gruppe erstellen'),
        ),
      ],
    ),
    // --- TAB 2: PLATZHALTER ---
    const Center(
      child: Text('Hier kommt später mehr hin!', style: TextStyle(fontSize: 20)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reiseplaner', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        // WICHTIG: Hier müssen immer mindestens 2 Items stehen!
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Test',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.build),
            label: 'In Arbeit',
          ),
        ],
      ),
    );
  }
}