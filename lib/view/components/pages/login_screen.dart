import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../api/auth/api_service.dart';
import '../../../core/app_state.dart';
import '../../../main.dart'; // Um später zum MainScreen zu navigieren
import 'package:reiseplaner/view/theme/app_colors.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _nameController = TextEditingController();
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  void _handleLogin() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      // 1. Prüfen, ob der Nutzer existiert
      final exists = await _apiService.loginBenutzer(name);

      if (exists) {
        // 2a. Nutzer existiert -> Gruppen laden & ab zum MainScreen!
        if (mounted) {
          await context.read<AppState>().initNachLogin(name);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainScreen()),
          );
        }
      } else {
        // 2b. Nutzer existiert nicht -> Dialog anzeigen, ob er erstellt werden soll
        if (mounted) _showRegisterDialog(name);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Fehler: $e')));
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showRegisterDialog(String name) {
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: const Text('Nutzer nicht gefunden'),
            content: Text(
                'Der Benutzer "$name" existiert noch nicht. Möchtest du ihn anlegen?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Abbrechen'),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context); // Dialog schließen
                  setState(() => _isLoading = true);
                  try {
                    // Nutzer registrieren
                    await _apiService.registerBenutzer(name);
                    // Direkt danach einloggen & Gruppen laden
                    if (mounted) {
                      await context.read<AppState>().initNachLogin(name);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MainScreen()),
                      );
                    }
                  } catch (e) {
                    if (mounted) ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Fehler: $e')));
                  } finally {
                    setState(() => _isLoading = false);
                  }
                },
                child: const Text('Registrieren'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      children: [
                        // Das drückt den gesamten Inhalt weiter nach unten
                        const Spacer(flex: 2),

                        const Icon(Icons.travel_explore, size: 80, color: AppColors.primary),
                        const SizedBox(height: 20),
                        const Text(
                          'Willkommen beim Reiseplaner',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 40),

                        TextField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Dein Benutzername',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person),
                          ),
                        ),
                        const SizedBox(height: 20),

                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _handleLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: AppColors.textOnPrimary,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Text('Einloggen', style: TextStyle(fontSize: 18)),
                          ),
                        ),

                        // und schiebt alles andere nach oben
                        const Spacer(flex: 4),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}