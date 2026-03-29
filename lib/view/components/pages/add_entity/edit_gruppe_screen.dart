import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../api/auth/api_service.dart';
import '../../../../api/models/models.dart';
import '../../../../core/app_state.dart';
import '../../../../view/theme/app_colors.dart';
import '../../core/Widgets/Button.dart';
import '../../core/Widgets/InputField.dart';

class EditGruppeScreen extends StatefulWidget {
  final Gruppe gruppe;

  const EditGruppeScreen({super.key, required this.gruppe});

  @override
  State<EditGruppeScreen> createState() => _EditGruppeScreenState();
}

class _EditGruppeScreenState extends State<EditGruppeScreen> {
  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _reiseortController = TextEditingController();
  final TextEditingController _personenInputController = TextEditingController();
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _endeController = TextEditingController();

  // State
  final List<String> _personen = [];
  String? _nameError;
  String? _dateError;
  String? _personError;
  bool _isLoadingPerson = false;

  @override
  void initState() {
    super.initState();

    // Felder mit bestehenden Daten füllen
    _nameController.text = widget.gruppe.name;
    _reiseortController.text = widget.gruppe.location ?? '';

    // Datum konvertieren (yyyy-MM-dd → dd.MM.yyyy)
    final displayFormat = DateFormat('dd.MM.yyyy');
    final apiFormat = DateFormat('yyyy-MM-dd');

    if (widget.gruppe.startDate != null &&
        widget.gruppe.startDate!.isNotEmpty) {
      try {
        final parsed = apiFormat.parseStrict(widget.gruppe.startDate!);
        _startController.text = displayFormat.format(parsed);
      } catch (_) {}
    }
    if (widget.gruppe.endDate != null && widget.gruppe.endDate!.isNotEmpty) {
      try {
        final parsed = apiFormat.parseStrict(widget.gruppe.endDate!);
        _endeController.text = displayFormat.format(parsed);
      } catch (_) {}
    }

    // Personen aus der Gruppe laden
    for (final b in widget.gruppe.benutzer) {
      _personen.add(b.name);
    }
  }

  void _addPerson() async {
    final name = _personenInputController.text.trim();
    if (name.isEmpty) return;

    if (_personen.contains(name)) {
      setState(() => _personError = 'Benutzer ist bereits in der Liste.');
      return;
    }

    setState(() {
      _isLoadingPerson = true;
      _personError = null;
    });

    try {
      final apiService = ApiService();
      final exists = await apiService.loginBenutzer(name);

      if (exists) {
        setState(() {
          _personen.add(name);
          _personenInputController.clear();
          _personError = null;
        });
      } else {
        setState(() => _personError = 'Benutzer "$name" existiert nicht.');
      }
    } catch (e) {
      setState(() => _personError = 'Fehler beim Prüfen des Benutzers.');
    } finally {
      setState(() => _isLoadingPerson = false);
    }
  }

  void _submitUpdate() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() => _nameError = 'Bitte gib einen Namen ein.');
      return;
    }
    setState(() {
      _nameError = null;
      _dateError = null;
    });

    // Datum parsen (TT.MM.JJJJ → yyyy-MM-dd)
    DateTime? startDateTime;
    DateTime? endDateTime;
    String? startDateStr;
    String? endDateStr;
    final dateFormat = DateFormat('dd.MM.yyyy');
    final apiFormat = DateFormat('yyyy-MM-dd');

    if (_startController.text.trim().isNotEmpty) {
      try {
        startDateTime = dateFormat.parseStrict(_startController.text.trim());
        startDateStr = apiFormat.format(startDateTime);
      } catch (_) {}
    }
    if (_endeController.text.trim().isNotEmpty) {
      try {
        endDateTime = dateFormat.parseStrict(_endeController.text.trim());
        endDateStr = apiFormat.format(endDateTime);
      } catch (_) {}
    }

    // Validierung: Ende darf nicht vor Start liegen
    if (startDateTime != null && endDateTime != null) {
      if (endDateTime.isBefore(startDateTime)) {
        setState(
          () =>
              _dateError = 'Das Enddatum darf nicht vor dem Startdatum liegen.',
        );
        return;
      }
    }

    final Map<String, dynamic> body = {
      'name': name,
      'location': _reiseortController.text.trim().isNotEmpty
          ? _reiseortController.text.trim()
          : null,
      'startDate': startDateStr,
      'endDate': endDateStr,
      'benutzer': _personen.map((p) => {'name': p}).toList(),
    };

    try {
      final apiService = ApiService();
      await apiService.updateGruppe(widget.gruppe.id, body);

      if (mounted) {
        await context.read<AppState>().ladeGruppen();
        if (mounted) Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        final message = e.toString();
        if (message.contains('409') || message.contains('Conflict')) {
          setState(
            () => _nameError =
                'Eine Gruppe mit dem Namen "$name" existiert bereits.',
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Fehler: $message'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(
          'Gruppe löschen',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: Text(
          'Möchtest du "${widget.gruppe.name}" wirklich löschen? '
          'Alle Transaktionen, Notizen und Events gehen verloren.',
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text(
              'Abbrechen',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              _deleteGruppe();
            },
            child: const Text(
              'Löschen',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  void _deleteGruppe() async {
    try {
      final apiService = ApiService();
      await apiService.deleteGruppe(widget.gruppe.id);

      if (mounted) {
        await context.read<AppState>().ladeGruppen();
        if (mounted) Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fehler: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
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
                    'Gruppe bearbeiten',
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
                    child: DateInputField(
                      label: 'Start',
                      hint: 'TT.MM.JJJJ',
                      controller: _startController,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DateInputField(
                      label: 'Ende',
                      hint: 'TT.MM.JJJJ',
                      controller: _endeController,
                    ),
                  ),
                ],
              ),
              if (_dateError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4, left: 12),
                  child: Text(
                    _dateError!,
                    style: const TextStyle(
                      color: AppColors.error,
                      fontSize: 13,
                    ),
                  ),
                ),
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 30),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextInputField(
                      label: 'Person hinzufügen',
                      hint: '',
                      controller: _personenInputController,
                    ),
                  ),
                  const SizedBox(width: 12),
                  SimpleButton(
                    icon: Icons.add,
                    onPressed: _addPerson,
                    isLoading: _isLoadingPerson,
                  ),
                ],
              ),
              if (_personError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4, left: 12),
                  child: Text(
                    _personError!,
                    style: const TextStyle(
                      color: AppColors.error,
                      fontSize: 13,
                    ),
                  ),
                ),
              const SizedBox(height: 18),
              ..._personen.map((person) {
                final isCurrentUser =
                    person == context.read<AppState>().benutzername;
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
                                  : () => setState(
                                      () => _personen.remove(person),
                                    ),
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
                    const SizedBox(height: 8),
                  ],
                );
              }),
              const SizedBox(height: 20),
              ReiseButton(
                title: 'Änderungen speichern',
                icon: Icons.check,
                onPressed: _submitUpdate,
                floatLeft: true,
              ),
              const SizedBox(height: 12),
              ReiseButton(
                title: 'Gruppe löschen',
                icon: Icons.delete_outline,
                onPressed: _confirmDelete,
                floatLeft: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
