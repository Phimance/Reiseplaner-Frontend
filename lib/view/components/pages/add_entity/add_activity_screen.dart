import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../api/auth/api_service.dart';
import '../../../../core/app_state.dart';
import '../../../../view/theme/app_colors.dart';
import '../../core/Widgets/Button.dart';
import '../../core/Widgets/InputField.dart';
class AddActivityScreen extends StatefulWidget {
  const AddActivityScreen({super.key});

  @override
  State<AddActivityScreen> createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends State<AddActivityScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _beschreibungController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _startDatumController = TextEditingController();
  final TextEditingController _startUhrzeitController = TextEditingController();
  final TextEditingController _endDatumController = TextEditingController();
  final TextEditingController _endUhrzeitController = TextEditingController();

  String? _nameError;

  void _submitActivity() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() => _nameError = 'Bitte gib einen Namen ein.');
      return;
    }
    setState(() => _nameError = null);

    String? startDateTime;
    String? endDateTime;
    final dateFormat = DateFormat('dd.MM.yyyy');
    final timeFormat = DateFormat('HH:mm');
    final isoFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss");

    if (_startDatumController.text.trim().isNotEmpty && _startUhrzeitController.text.trim().isNotEmpty) {
      try {
        final date = dateFormat.parseStrict(_startDatumController.text.trim());
        final time = timeFormat.parseStrict(_startUhrzeitController.text.trim());
        final combined = DateTime(date.year, date.month, date.day, time.hour, time.minute);
        startDateTime = isoFormat.format(combined);
      } catch (_) {}
    }

    if (_endDatumController.text.trim().isNotEmpty && _endUhrzeitController.text.trim().isNotEmpty) {
      try {
        final date = dateFormat.parseStrict(_endDatumController.text.trim());
        final time = timeFormat.parseStrict(_endUhrzeitController.text.trim());
        final combined = DateTime(date.year, date.month, date.day, time.hour, time.minute);
        endDateTime = isoFormat.format(combined);
      } catch (_) {}
    }

    final Map<String, dynamic> body = {
      'titel': name,
      'beschreibung': _beschreibungController.text.trim().isNotEmpty ? _beschreibungController.text.trim() : null,
      'location': _locationController.text.trim().isNotEmpty ? _locationController.text.trim() : null,
      'datumStart': startDateTime,
      'datumEnde': endDateTime,
    };

    try {
      final planerId = context.read<AppState>().aktiveGruppe?.planer?.id;
      if (planerId == null) {
        throw Exception('Keine aktive Gruppe mit Planer ausgewählt.');
      }
      
      final apiService = ApiService();
      await apiService.createEvent(planerId, body);

      if (mounted) {
        await context.read<AppState>().loadActivities();
        if (mounted) Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        final message = e.toString();
        if (message.contains('409') || message.contains('Conflict')) {
          setState(() => _nameError = 'Ein Event mit dem Namen "$name" existiert bereits.');
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

  @override
  void dispose() {
    _nameController.dispose();
    _beschreibungController.dispose();
    _locationController.dispose();
    _startDatumController.dispose();
    _startUhrzeitController.dispose();
    _endDatumController.dispose();
    _endUhrzeitController.dispose();
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
                  SimpleButton(icon: Icons.close, size: 60, onPressed: () => Navigator.pop(context)),
                  const SizedBox(width: 40),
                  const Text('Event erstellen', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                ],
              ),
              const SizedBox(height: 24),
              TextInputField(label: 'Name', hint: '', controller: _nameController),
              if (_nameError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4, left: 12),
                  child: Text(_nameError!, style: const TextStyle(color: AppColors.error, fontSize: 13)),
                ),
              const SizedBox(height: 18),
              TextInputField(label: 'Beschreibung', hint: '', controller: _beschreibungController),
              const SizedBox(height: 18),
              TextInputField(label: 'Location', hint: '', controller: _locationController),
              const SizedBox(height: 18),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: DateInputField(label: 'Start Datum', hint: 'TT.MM.JJJJ', controller: _startDatumController)),
                  const SizedBox(width: 12),
                  Expanded(child: TimeInputField(label: 'Start Zeit', hint: 'HH:MM', controller: _startUhrzeitController)),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: DateInputField(label: 'End Datum', hint: 'TT.MM.JJJJ', controller: _endDatumController)),
                  const SizedBox(width: 12),
                  Expanded(child: TimeInputField(label: 'End Zeit', hint: 'HH:MM', controller: _endUhrzeitController)),
                ],
              ),
              const SizedBox(height: 30),
              ReiseButton(title: 'Event hinzufügen', icon: Icons.add, onPressed: _submitActivity),
            ],
          ),
        ),
      ),
    );
  }
}
