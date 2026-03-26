import 'package:flutter/foundation.dart';
import '../api/auth/api_service.dart';
import '../api/models/models.dart';

/// Zentraler App-Zustand – speichert globale Informationen wie
/// Benutzername, Gruppen-Liste und die aktuell ausgewählte Gruppe.
class AppState extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  // ── Benutzername ──────────────────────────────────────────
  String _benutzername = '';
  String get benutzername => _benutzername;

  // ── Gruppen des Benutzers ─────────────────────────────────
  List<Gruppe> _gruppen = [];
  List<Gruppe> get gruppen => List.unmodifiable(_gruppen);

  // ── Aktuell ausgewählte Gruppe ────────────────────────────
  Gruppe? _aktiveGruppe;
  Gruppe? get aktiveGruppe => _aktiveGruppe;

  // ── Lade-Status ───────────────────────────────────────────
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // ── Fehler ────────────────────────────────────────────────
  String? _error;
  String? get error => _error;

  /// Wird nach dem Login aufgerufen: Setzt den Benutzernamen
  /// und lädt die Gruppen vom Backend.
  Future<void> initNachLogin(String name) async {
    _benutzername = name;
    _error = null;
    notifyListeners();

    await ladeGruppen();
  }

  /// Lädt die Gruppen des aktuellen Benutzers vom Backend.
  Future<void> ladeGruppen() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      print('🔄 Lade Gruppen für "$_benutzername"...');
      final gruppenResult = await _apiService.getGruppenByBenutzer(_benutzername);
      print('✅ ${gruppenResult.length} Gruppe(n) geladen: ${gruppenResult.map((g) => g.name).toList()}');
      _gruppen = gruppenResult;

      // Aktive Gruppe per ID wiederfinden (nach Reload ist es ein neues Objekt)
      if (_aktiveGruppe != null) {
        final gefunden = _gruppen.where((g) => g.id == _aktiveGruppe!.id);
        _aktiveGruppe = gefunden.isNotEmpty ? gefunden.first : null;
      }

      // Wenn immer noch keine aktive Gruppe → erste nehmen
      if (_aktiveGruppe == null && _gruppen.isNotEmpty) {
        _aktiveGruppe = _gruppen.first;
      }

      print('👉 Aktive Gruppe: ${_aktiveGruppe?.name ?? "keine"}');
    } catch (e) {
      _error = e.toString();
      print('❌ Fehler beim Laden der Gruppen: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Setzt die aktuell aktive Gruppe.
  void setAktiveGruppe(Gruppe gruppe) {
    _aktiveGruppe = gruppe;
    notifyListeners();
  }

  /// Setzt den gesamten Zustand zurück (z. B. beim Logout).
  void logout() {
    _benutzername = '';
    _gruppen = [];
    _aktiveGruppe = null;
    _error = null;
    _isLoading = false;
    notifyListeners();
  }
}

