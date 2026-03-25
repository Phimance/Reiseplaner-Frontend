import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/app_state.dart';
import '../../../../view/theme/app_colors.dart';
import '../../core/Widgets/Button.dart';
import '../../core/Widgets/InputField.dart';

class AddGruppeScreen extends StatefulWidget {
  const AddGruppeScreen({super.key});

  @override
  State<AddGruppeScreen> createState() => _AddGruppeScreenState();
}

class _AddGruppeScreenState extends State<AddGruppeScreen> {
  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _reiseortController = TextEditingController();
  final TextEditingController _personenInputController = TextEditingController();
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _endeController = TextEditingController();

  // State
  final List<String> _personen = [];
  String? _nameError;

  @override
  void initState() {
    super.initState();
    final benutzername = context.read<AppState>().benutzername;
    if (benutzername.isNotEmpty) {
      _personen.add(benutzername);
    }
  }

  void _addPerson() {
    final name = _personenInputController.text.trim();
    if (name.isNotEmpty && !_personen.contains(name)) {
      setState(() {
        _personen.add(name);
        _personenInputController.clear();
      });
    }
  }

  void _submitGruppe() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() => _nameError = 'Bitte gib einen Namen ein.');
      return;
    }
    setState(() => _nameError = null);
    // TODO: submit logic
  }

  @override
  void dispose() {
    _nameController.dispose();
    _reiseortController.dispose();
    _personenInputController.dispose();
    _startController.dispose();
    _endeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SimpleButton(
                    icon: Icons.close,
                    size: 60,
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 40),
                  const Text(
                    'Reisegruppe erstellen',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              TextInputField(
                label: 'Name',
                hint: '',
                controller: _nameController,
              ),
              if (_nameError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4, left: 12),
                  child: Text(
                    _nameError!,
                    style: const TextStyle(
                      color: AppColors.error,
                      fontSize: 13,
                    ),
                  ),
                ),
              const SizedBox(height: 6),
              TextInputField(
                label: 'Reiseort',
                hint: '',
                controller: _reiseortController,
              ),
              const SizedBox(height: 6),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: DateInputField(label: 'Start', hint: 'TT.MM.JJJJ', controller: _startController),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DateInputField(label: 'Ende', hint: 'TT.MM.JJJJ', controller: _endeController),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Divider(),
              SizedBox(height: 30),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child:  TextInputField(
                      label: 'Person hinzufügen',
                      hint: '',
                      controller: _personenInputController,
                    ),
                  ),
                  const SizedBox(width: 12),
                 SimpleButton(icon: Icons.add, onPressed: _addPerson),
                ],
              ),
              SizedBox(height: 18),
              // here forEach for the Persons
              ..._personen.map((person) {
                final isCurrentUser = person == context.read<AppState>().benutzername;
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8, left: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Opacity(
                            opacity: isCurrentUser ? 0.3 : 1.0,
                            child: SimpleButton(
                              icon: Icons.remove,
                              size: 44,
                              onPressed: isCurrentUser
                                  ? () {}
                                  : () => setState(() => _personen.remove(person)),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              person,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                  ],
                );
              }),
              SizedBox(height: 20),
              ReiseButton(
                title: 'Gruppe hinzufügen',
                icon: Icons.add,
                onPressed: _submitGruppe,
              ),
              // TODO: an Backend anbinden mit Fehlermeldung, wenn Name bereits existiert.
            ],
          ),
        ),
      ),
    );
  }
}
