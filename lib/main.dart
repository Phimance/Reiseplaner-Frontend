import 'package:flutter/material.dart';
import 'package:reiseplaner/view/components/core/Widgets/ReiseHeader.dart';
import 'package:reiseplaner/view/components/pages/home_screen.dart';
import 'api/auth/api_service.dart'; // Hier importieren wir deine neue API-Datei!
import 'view/components/pages/login_screen.dart';
import 'view/theme/app_theme.dart';

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
      theme: AppTheme.darkTheme,
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
  double standardIconSize = 28;
  double highlightedIconSize = 34;

  // Hier ist unsere angepasste Liste der Bildschirme! Jetzt wieder mit 2 Elementen.
  final List<Widget> _screens = [
    const HomeScreen(),
    const Center(
      child: Text('Hier kommt später mehr hin!', style: TextStyle(fontSize: 20)),
    ),
    const Center(
      child: Text('Hier kommt später mehr hin!', style: TextStyle(fontSize: 20)),
    ),
    const Center(
      child: Text('Hier kommt später mehr hin!', style: TextStyle(fontSize: 20)),
    ),
    const Center(
      child: Text('Hier kommt später mehr hin!', style: TextStyle(fontSize: 20)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ReiseHeader(),
          Container(
            height: 16,
            color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
          ),
          BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _currentIndex,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            iconSize: standardIconSize,
            enableFeedback: false,
            mouseCursor: SystemMouseCursors.click,
            selectedItemColor: Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
            unselectedItemColor: Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
            backgroundColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home_outlined, size: highlightedIconSize),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.compare_arrows_outlined),
                activeIcon: Icon(Icons.compare_arrows_outlined, size: highlightedIconSize),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.list_outlined),
                activeIcon: Icon(Icons.list_outlined, size: highlightedIconSize),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.calendar_today_outlined),
                activeIcon: Icon(Icons.calendar_today_outlined, size: highlightedIconSize),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.person_outlined),
                activeIcon: Icon(Icons.person_outlined, size: highlightedIconSize),
                label: '',
              ),
            ],
          ),
        ],
      ),
    );
  }
}