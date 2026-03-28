import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../api/auth/api_service.dart';
import '../../../../api/models/models.dart';
import '../../../../core/app_state.dart';
import '../../../../view/theme/app_colors.dart';
import '../../core/Widgets/Button.dart';
import '../../core/Widgets/InputField.dart';

/// Hilfsklasse für eine einzelne Transaktionsperson im Formular.
class _TransaktionspersonEntry {
  String? schuldner;
  final TextEditingController anteilController = TextEditingController();
  void dispose() => anteilController.dispose();
}

class AddTransaktionScreen extends StatefulWidget {
  const AddTransaktionScreen({super.key});

  @override
  State<AddTransaktionScreen> createState() => _AddTransaktionScreenState();
}

class _AddTransaktionScreenState extends State<AddTransaktionScreen> {
  // ── Controller ────────────────────────────────────────────
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _gesamtwertController = TextEditingController();

  String? _bezahler;
  final List<_TransaktionspersonEntry> _transaktionspersonen = [];

  @override
  void initState() {
    super.initState();
    _gesamtwertController.addListener(_verteileAnteile);
  }

  // ── Fehler ────────────────────────────────────────────────
  String? _nameError;
  String? _bezahlerError;
  String? _gesamtwertError;
  String? _anteilError;

  // ── Gruppenmitglieder (Namen) ─────────────────────────────
  List<Benutzer> get _mitglieder =>
      context.read<AppState>().aktiveGruppe?.benutzer ?? [];

  // ── Transaktionsperson hinzufügen / entfernen ─────────────

  void _addTransaktionsperson() {
    setState(() {
      _transaktionspersonen.add(_TransaktionspersonEntry());
      _verteileAnteile();
    });
  }

  void _removeTransaktionsperson(int index) {
    setState(() {
      _transaktionspersonen[index].dispose();
      _transaktionspersonen.removeAt(index);
      _verteileAnteile();
    });
  }

  /// Verteilt den Gesamtwert gleichmäßig auf alle Transaktionspersonen.
  void _verteileAnteile() {
    if (_transaktionspersonen.isEmpty) return;
    final gesamtwert = double.tryParse(
        _gesamtwertController.text.trim().replaceAll(',', '.')) ?? 0.0;
    final anteil = gesamtwert / _transaktionspersonen.length;
    for (final tp in _transaktionspersonen) {
      tp.anteilController.text = anteil.toStringAsFixed(2);
    }
  }

  // ── Submit ────────────────────────────────────────────────

  void _submit() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() => _nameError = 'Bitte gib einen Namen ein.');
      return;
    }
    setState(() => _nameError = null);

    if (_bezahler == null || _bezahler!.isEmpty) {
      setState(() => _bezahlerError = 'Bitte wähle einen Bezahler aus.');
      return;
    }
    setState(() => _bezahlerError = null);

    final gesamtwertText = _gesamtwertController.text.trim().replaceAll(',', '.');
    final gesamtwert = double.tryParse(gesamtwertText);
    if (gesamtwert == null || gesamtwert <= 0) {
      setState(() => _gesamtwertError = 'Bitte gib einen gültigen Betrag ein.');
      return;
    }
    setState(() => _gesamtwertError = null);

    // Prüfen ob alle Transaktionspersonen einen Schuldner haben
    for (int i = 0; i < _transaktionspersonen.length; i++) {
      if (_transaktionspersonen[i].schuldner == null || _transaktionspersonen[i].schuldner!.isEmpty) {
        setState(() => _anteilError = 'Transaktionsperson ${i + 1} hat keinen Schuldner zugewiesen.');
        return;
      }
    }

    // Summe aller Anteile berechnen
    double summeAnteile = 0;
    for (final tp in _transaktionspersonen) {
      summeAnteile += double.tryParse(
          tp.anteilController.text.trim().replaceAll(',', '.')) ?? 0.0;
    }

    // Prüfen ob die Summe der Anteile exakt dem Gesamtwert entspricht
    if ((summeAnteile - gesamtwert).abs() > (0.01 * _transaktionspersonen.length)) {
      setState(() => _anteilError =
          'Die Summe der Anteile (${summeAnteile.toStringAsFixed(2)} €) '
          'stimmt nicht mit dem Gesamtwert (${gesamtwert.toStringAsFixed(2)} €) überein.');
      return;
    }
    setState(() => _anteilError = null);

    final gruppeId = context.read<AppState>().aktiveGruppe?.id;
    if (gruppeId == null) return;


    final transaktion = Transaktion(
      transaktionsname: name,
      bezahlername: _bezahler ?? '',
      gesamtwert: gesamtwert,
      transaktionspersonen: _transaktionspersonen.map((tp) {
        final anteil = double.tryParse(
            tp.anteilController.text.trim().replaceAll(',', '.')) ?? 0.0;
        return Transaktionsperson(
          schuldner: tp.schuldner ?? '',
          anteil: anteil,
        );
      }).toList(),
    );

    try {
      final apiService = ApiService();
      await apiService.createTransaktion(gruppeId, transaktion.toJson());

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

  // ── Picker-BottomSheet ────────────────────────────────────

  void _showBenutzerPicker({
    required String title,
    required ValueChanged<String> onSelected,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) {
        final mitglieder = _mitglieder;
        if (mitglieder.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(24),
            child: Text('Keine Mitglieder vorhanden.',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 16)),
          );
        }
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                child: Text(title,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary)),
              ),
              const Divider(color: AppColors.divider),
              ...mitglieder.map((b) => ListTile(
                    leading: const Icon(Icons.person, color: AppColors.navInactive),
                    title: Text(b.name,
                        style: const TextStyle(color: AppColors.textPrimary)),
                    onTap: () {
                      onSelected(b.name);
                      Navigator.pop(sheetContext);
                    },
                  )),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  // ── Lifecycle ─────────────────────────────────────────────

  @override
  void dispose() {
    _nameController.dispose();
    _gesamtwertController.dispose();
    for (final tp in _transaktionspersonen) {
      tp.dispose();
    }
    super.dispose();
  }

  // ── UI ────────────────────────────────────────────────────

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
              // ── Header ──────────────────────────────────
              Row(
                children: [
                  SimpleButton(
                    icon: Icons.close,
                    size: 60,
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 40),
                  const Text(
                    'neue Transaktion erstellen',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // ── Name ────────────────────────────────────
              TextInputField(
                label: 'Name',
                hint: '',
                controller: _nameController,
              ),
              if (_nameError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4, left: 12),
                  child: Text(_nameError!,
                      style: const TextStyle(color: AppColors.error, fontSize: 13)),
                ),
              const SizedBox(height: 12),

              // ── Bezahler (Picker) ───────────────────────
              _buildPickerField(
                label: 'Bezahler',
                value: _bezahler,
                placeholder: 'Benutzer auswählen',
                onTap: () => _showBenutzerPicker(
                  title: 'Bezahler auswählen',
                  onSelected: (name) => setState(() => _bezahler = name),
                ),
              ),
              if (_bezahlerError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4, left: 12),
                  child: Text(_bezahlerError!,
                      style: const TextStyle(color: AppColors.error, fontSize: 13)),
                ),
              const SizedBox(height: 12),

              // ── Gesamtwert ──────────────────────────────
              TextInputField(
                label: 'Gesamtwert (€)',
                hint: '0.00',
                controller: _gesamtwertController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              if (_gesamtwertError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4, left: 12),
                  child: Text(_gesamtwertError!,
                      style: const TextStyle(color: AppColors.error, fontSize: 13)),
                ),
              const SizedBox(height: 12),
              const Divider(color: AppColors.divider),
              const SizedBox(height: 12),

              // ── Transaktionspersonen ─────────────────────
              Row(
                children: [
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 12),
                      child: Text('Transaktionspersonen',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary)),
                    ),
                  ),
                  SimpleButton(icon: Icons.add, onPressed: _addTransaktionsperson),
                ],
              ),
              const SizedBox(height: 12),

              _buildTransaktionspersonenColumn(),

              if (_anteilError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4, left: 12),
                  child: Text(_anteilError!,
                      style: const TextStyle(color: AppColors.error, fontSize: 13)),
                ),

              const SizedBox(height: 20),
              ReiseButton(
                title: 'Transaktion erstellen',
                icon: Icons.check,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Wiederverwendbares Picker-Feld ──────────────────────

  Widget _buildTransaktionspersonenColumn() {
    final List<Widget> children = [];
    for (int index = 0; index < _transaktionspersonen.length; index++) {
      final tp = _transaktionspersonen[index];
      children.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                flex: 3,
                child: _buildPickerField(
                  label: 'Schuldner',
                  value: tp.schuldner,
                  placeholder: 'Auswählen',
                  onTap: () => _showBenutzerPicker(
                    title: 'Schuldner auswählen',
                    onSelected: (name) => setState(() => tp.schuldner = name),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: TextInputField(
                  label: 'Anteil (€)',
                  hint: '0.00',
                  controller: tp.anteilController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
              ),
              const SizedBox(width: 8),
              SimpleButton(
                icon: Icons.remove,
                size: 44,
                onPressed: () => _removeTransaktionsperson(index),
              ),
            ],
          ),
        ),
      );
    }
    return Column(children: children);
  }

  Widget _buildPickerField({
    required String label,
    String? value,
    required String placeholder,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Text(label,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary)),
        ),
        const SizedBox(height: 2),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.inputSurface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value ?? placeholder,
                    style: TextStyle(
                      color: value != null
                          ? AppColors.textPrimary
                          : AppColors.textHint,
                      fontSize: 15,
                    ),
                  ),
                ),
                const Icon(Icons.arrow_drop_down,
                    color: AppColors.textHint, size: 24),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
