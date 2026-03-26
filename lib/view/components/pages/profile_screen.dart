import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/app_state.dart';
import '../../theme/app_colors.dart';
import '../core/Widgets/Button.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Spacer(),
            Divider(color: AppColors.divider, thickness: 1),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("derzeit angemeldet als"),
                const SizedBox(width: 8),
                Padding(
                  padding: EdgeInsetsGeometry.only(bottom: 3),
                  child: Text("${context.read<AppState>().benutzername}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                )
              ],
            ),
            SizedBox(height: 12),
            ReiseButton(
              title: 'Abmelden',
              icon: Icons.logout,
              floatLeft: true,
              onPressed: () {
                // Logout im AppState ausführen
                context.read<AppState>().logout();
                
                // Zurück zum Login-Screen navigieren und Stack leeren
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
