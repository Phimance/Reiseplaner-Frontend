import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reiseplaner/view/components/core/Widgets/ReiseHeader.dart';
import 'package:reiseplaner/view/components/pages/home_screen.dart';
import 'package:reiseplaner/view/components/pages/profile_screen.dart';
import 'core/app_state.dart';
import 'view/components/pages/login_screen.dart';
import 'view/theme/app_theme.dart';

void main() {
  runApp(const ReiseplanerApp());
}

class ReiseplanerApp extends StatelessWidget {
  const ReiseplanerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(),
      child: MaterialApp(
        title: 'Reiseplaner',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const LoginScreen(),
      ),
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

  final List<Widget> _screens = [
    const HomeScreen(),
    const Center(
      child: Text('Bildschirm 2', style: TextStyle(fontSize: 20)),
    ),
    const Center(
      child: Text('Bildschirm 3', style: TextStyle(fontSize: 20)),
    ),
    const Center(
      child: Text('Bildschirm 4', style: TextStyle(fontSize: 20)),
    ),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    const double headerHeight = 72;
    final double totalTopPadding = headerHeight + MediaQuery.of(context).padding.top;

    return Scaffold(
      body: Stack(
        children: [
          // Hauptinhalt mit Padding oben, damit er nicht vom Header verdeckt wird
          Padding(
            padding: EdgeInsets.only(top: totalTopPadding, left: 16, right: 16),
            child: _screens[_currentIndex],
          ),
          // Floating Header oben
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: totalTopPadding,
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top,
                left: 16,
                right: 32,
              ),
              color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
              alignment: Alignment.centerLeft,
              child: const ReiseHeader(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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