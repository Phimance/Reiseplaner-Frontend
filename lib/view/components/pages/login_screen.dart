import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../api/auth/api_service.dart';
import '../../../api/auth/local_auth_service.dart';
import '../../../core/app_state.dart';
import '../../../main.dart';
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
      final exists = await _apiService.loginBenutzer(name);

      if (exists) {
        if (mounted) {
          // Namen lokal speichern für Auto-Login
          await LocalAuthService.saveUsername(name);
          
          await context.read<AppState>().initNachLogin(name);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainScreen()),
          );
        }
      } else {
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
            backgroundColor: AppColors.surface,
            title: const Text('Nutzer nicht gefunden', style: TextStyle(color: AppColors.textPrimary)),
            content: Text(
                'Der Benutzer "$name" existiert noch nicht. Möchtest du ihn anlegen?',
                style: const TextStyle(color: AppColors.textSecondary)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Abbrechen', style: TextStyle(color: AppColors.textSecondary)),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  setState(() => _isLoading = true);
                  try {
                    await _apiService.registerBenutzer(name);
                    if (mounted) {
                      // Namen lokal speichern
                      await LocalAuthService.saveUsername(name);
                      
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
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                child: const Text('Registrieren', style: TextStyle(color: Colors.black)),
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
                        const Spacer(flex: 2),
                        const Icon(Icons.travel_explore, size: 80, color: AppColors.primary),
                        const SizedBox(height: 20),
                        const Text(
                          'BananaSplit dein Reiseplaner',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 40),
                        TextField(
                          controller: _nameController,
                          style: const TextStyle(color: AppColors.textPrimary),
                          decoration: const InputDecoration(
                            labelText: 'Dein Benutzername',
                            labelStyle: TextStyle(color: AppColors.textSecondary),
                            border: OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.divider)),
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.primary)),
                            prefixIcon: Icon(Icons.person, color: AppColors.primary),
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
