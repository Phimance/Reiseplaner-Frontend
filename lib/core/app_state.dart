import 'package:flutter/foundation.dart';
import '../api/auth/api_service.dart';
import '../api/data/notiz_service.dart';
import '../api/models/models.dart';

class AppState extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final NotizService _notizService = NotizService();

  String _benutzername = '';
  String get benutzername => _benutzername;

  List<Gruppe> _gruppen = [];
  List<Gruppe> get gruppen => List.unmodifiable(_gruppen);

  Gruppe? _aktiveGruppe;
  Gruppe? get aktiveGruppe => _aktiveGruppe;

  Notizblock? _aktiverNotizblock;

  List<Notiz> _notizen = [];
  List<Notiz> get notizen => List.unmodifiable(_notizen);

  List<Event> _events = [];
  List<Event> get events => List.unmodifiable(_events);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void> initNachLogin(String name) async {
    _benutzername = name;
    _error = null;
    notifyListeners();
    await ladeGruppen();
  }

  Future<void> ladeGruppen() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final gruppenResult = await _apiService.getGruppenByBenutzer(
        _benutzername,
      );
      _gruppen = gruppenResult;

      if (_aktiveGruppe != null) {
        final gefunden = _gruppen.where((g) => g.id == _aktiveGruppe!.id);
        _aktiveGruppe = gefunden.isNotEmpty ? gefunden.first : null;
      }

      if (_aktiveGruppe == null && _gruppen.isNotEmpty) {
        await setAktiveGruppe(_gruppen.first);
      } else if (_aktiveGruppe != null) {
        await ladeNotizen();
      }

      _events = _aktiveGruppe?.planer?.events ?? [];
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
      _aktiverNotizblock = await _notizService.getNotizblockByGruppe(_aktiveGruppe!.id);

      if (_aktiverNotizblock == null) {
        _aktiverNotizblock = await _notizService.createNotizblock(_aktiveGruppe!.id, "Allgemein");
      }

      if (_aktiverNotizblock != null) {
        _notizen = await _notizService.getNotizenByNotizblock(_aktiverNotizblock!.id);
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  int _tabIndex = 0;
  int get tabIndex => _tabIndex;

  void setTabIndex(int index) {
    _tabIndex = index;
    notifyListeners();
  }

  Future<void> createNotiz(String titel, String inhalt) async {
    if (_aktiverNotizblock == null) {
      await ladeNotizen();
    }
    if (_aktiverNotizblock == null) return;

    try {
      final neueNotiz = Notiz(
        name: titel,
        inhalt: inhalt,
        notizblockId: _aktiverNotizblock!.id,
      );
      await _notizService.createNotiz(neueNotiz);
      await ladeNotizen();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateNotiz(Notiz notiz) async {
    try {
      await _notizService.updateNotiz(notiz);
      await ladeNotizen();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteNotiz(String id) async {
    try {
      await _notizService.deleteNotiz(id);
      await ladeNotizen();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> setAktiveGruppe(Gruppe gruppe) async {
    _aktiveGruppe = gruppe;
    _events = gruppe.planer?.events ?? [];
    notifyListeners();
    await ladeNotizen();
  }

  void logout() {
    _benutzername = '';
    _gruppen = [];
    _aktiveGruppe = null;
    _notizen = [];
    _aktiverNotizblock = null;
    notifyListeners();
  }

  Future<void> loadActivities() => ladeGruppen();

  Future<void> updateEvent(String eventId, Map<String, dynamic> data) async {
    try {
      await _apiService.updateEvent(eventId, data);
      await loadActivities();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteEvent(String eventId) async {
    try {
      await _apiService.deleteEvent(eventId);
      await loadActivities();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }
}
