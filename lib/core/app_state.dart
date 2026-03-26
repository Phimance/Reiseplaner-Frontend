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
      final gruppenJson = await _apiService.getGruppenByBenutzer(_benutzername);
      _gruppen = gruppenJson;

      // Wenn noch keine Gruppe ausgewählt ist und Gruppen vorhanden,
      // automatisch die erste auswählen.
      if (_aktiveGruppe == null && _gruppen.isNotEmpty) {
        _aktiveGruppe = _gruppen.first;
      }

      // Falls die aktive Gruppe nicht mehr in der Liste ist, zurücksetzen.
      if (_aktiveGruppe != null && !_gruppen.contains(_aktiveGruppe)) {
        _aktiveGruppe = _gruppen.isNotEmpty ? _gruppen.first : null;
      }
    } catch (e) {
      _error = e.toString();
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

