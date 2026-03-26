import 'package:flutter/foundation.dart';
import '../api/auth/api_service.dart';
import '../api/data/notiz_service.dart';
import '../api/models/gruppe.dart';
import '../api/models/notiz.dart';
import '../api/models/notizblock.dart';
import '../api/models/models.dart';

/// Zentraler App-Zustand – speichert globale Informationen wie
/// Benutzername, Gruppen-Liste und die aktuell ausgewählte Gruppe.
class AppState extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final NotizService _notizService = NotizService();

  // ── Benutzername ──────────────────────────────────────────
  String _benutzername = '';
  String get benutzername => _benutzername;

  // ── Gruppen des Benutzers ─────────────────────────────────
  List<Gruppe> _gruppen = [];
  List<Gruppe> get gruppen => List.unmodifiable(_gruppen);

  // ── Aktuell ausgewählte Gruppe ────────────────────────────
  Gruppe? _aktiveGruppe;
  Gruppe? get aktiveGruppe => _aktiveGruppe;

  Notizblock? _aktiverNotizblock;

  List<Notiz> _notizen = [];
  List<Notiz> get notizen => List.unmodifiable(_notizen);

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
      _gruppen = await _apiService.getGruppenByBenutzer(_benutzername);
      if (_aktiveGruppe == null && _gruppen.isNotEmpty) {
        await setAktiveGruppe(_gruppen.first);
      } else if (_aktiveGruppe != null) {
        // Notizen für die bereits aktive Gruppe laden (z.B. nach Refresh)
        await ladeNotizen();
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> ladeNotizen() async {
    if (_aktiveGruppe == null) return;
    _isLoading = true;
    notifyListeners();

    try {
      print('Suche Notizblock für Gruppe: ${_aktiveGruppe!.id}');
      _aktiverNotizblock = await _notizService.getNotizblockByGruppe(_aktiveGruppe!.id);

      if (_aktiverNotizblock == null) {
        print('Kein Notizblock gefunden, erstelle "Allgemein" für Gruppe ${_aktiveGruppe!.id}');
        _aktiverNotizblock = await _notizService.createNotizblock(_aktiveGruppe!.id, "Allgemein");
      }

      if (_aktiverNotizblock != null) {
        print('Lade Notizen für Block: ${_aktiverNotizblock!.id}');
        _notizen = await _notizService.getNotizenByNotizblock(_aktiverNotizblock!.id);
        print('Anzahl Notizen geladen: ${_notizen.length}');
      }
    } catch (e) {
      print('Fehler im ladeNotizen: $e');
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createNotiz(String titel, String inhalt) async {
    if (_aktiverNotizblock == null) {
      await ladeNotizen();
    }

    if (_aktiverNotizblock == null) {
      print('Fehler: Kein aktiver Notizblock vorhanden.');
      return;
    }

    try {
      final neueNotiz = Notiz(
        name: titel,
        inhalt: inhalt,
        notizblockId: _aktiverNotizblock!.id,
      );
      print('Sende Notiz an API: ${neueNotiz.toJson()}');
      await _notizService.createNotiz(neueNotiz);
      print('Notiz erstellt, lade Liste neu...');
      await ladeNotizen();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> setAktiveGruppe(Gruppe gruppe) async {
    _aktiveGruppe = gruppe;
    _notizen = [];
    _aktiverNotizblock = null;
    notifyListeners();
    await ladeNotizen();
  }

  /// Setzt den gesamten Zustand zurück (z. B. beim Logout).
  void logout() {
    _benutzername = '';
    _gruppen = [];
    _aktiveGruppe = null;
    _notizen = [];
    _aktiverNotizblock = null;
    notifyListeners();
  }
}

