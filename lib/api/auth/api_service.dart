import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/models.dart';

class ApiService {
  final String _baseUrl = 'http://ubuntu.p-stephan.de:8081/api';

  // 1. Simpler GET-Request
  Future<dynamic> getGruppen() async {
    final response = await http.get(Uri.parse('$_baseUrl/gruppe'));

    if (response.statusCode == 200) {
      return json.decode(response.body); // Text in JSON umwandeln
    } else {
      throw Exception('Fehler beim Laden: Status ${response.statusCode}');
    }
  }

  // 2. Simpler POST-Request
  Future<dynamic> createGruppe(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/gruppe'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 409) {
      throw Exception('409 Conflict: ${response.body}');
    } else {
      throw Exception('Fehler beim Erstellen: Status ${response.statusCode}');
    }
  }

  // --- NEU: LOGIN & REGISTRIERUNG ---

  // Prüft, ob der Benutzer existiert
  Future<bool> loginBenutzer(String name) async {
    final response = await http.get(Uri.parse('$_baseUrl/benutzer/$name'));

    if (response.statusCode == 200) {
      return true; // Benutzer gefunden!
    } else if (response.statusCode == 404) {
      return false; // Benutzer gibt es nicht
    } else {
      throw Exception('Fehler beim Login: Status ${response.statusCode}');
    }
  }

  // Legt einen neuen Benutzer an
  Future<bool> registerBenutzer(String name) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/benutzer'),
      headers: {'Content-Type': 'application/json'},
      // Das Backend erwartet laut Doku auch leere Arrays für Gruppen und Freunde
      body: json.encode({
        'name': name,
        'gruppen': [],
        'freunde': []
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return true; // Erfolgreich erstellt
    } else {
      throw Exception('Fehler bei der Registrierung: Status ${response.statusCode}');
    }
  }

  // --- NEU: Gruppen eines Benutzers laden ---

  /// Ruft alle Gruppen eines Benutzers ab über GET /api/gruppe/benutzer/{name}
  Future<List<Gruppe>> getGruppenByBenutzer(String name) async {
    final response = await http.get(Uri.parse('$_baseUrl/gruppe/benutzer/$name'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      final List<Gruppe> result = [];
      for (int i = 0; i < jsonList.length; i++) {
        try {
          result.add(Gruppe.fromJson(jsonList[i] as Map<String, dynamic>));
        } catch (e) {
          print('⚠️ Fehler beim Parsen von Gruppe[$i]: $e');
          print('   JSON: ${jsonList[i]}');
        }
      }
      return result;
    } else {
      throw Exception('Fehler beim Laden der Gruppen: Status ${response.statusCode}');
    }
  }

  // --- NEU: Transaktion erstellen ---

  /// Erstellt eine Transaktion für eine Gruppe via POST /api/transaktion/gruppe/{gruppeId}
  Future<dynamic> createTransaktion(String gruppeId, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/transaktion/gruppe/$gruppeId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Fehler beim Erstellen der Transaktion: Status ${response.statusCode}');
    }
  }

  // --- NEU: Gruppe aktualisieren ---

  /// Aktualisiert eine Gruppe via PUT /api/gruppe/{id}
  Future<dynamic> updateGruppe(String gruppeId, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/gruppe/$gruppeId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else if (response.statusCode == 409) {
      throw Exception('409 Conflict: ${response.body}');
    } else {
      throw Exception('Fehler beim Aktualisieren: Status ${response.statusCode}');
    }
  }

  // --- NEU: Gruppe löschen ---

  /// Löscht eine Gruppe via DELETE /api/gruppe/{id}
  Future<void> deleteGruppe(String gruppeId) async {
    final response = await http.delete(Uri.parse('$_baseUrl/gruppe/$gruppeId'));

    if (response.statusCode == 204 || response.statusCode == 200) {
      return;
    } else if (response.statusCode == 404) {
      throw Exception('Gruppe nicht gefunden.');
    } else {
      throw Exception('Fehler beim Löschen: Status ${response.statusCode}');
    }
  }

  Future<dynamic> updateTransaktion(String transaktionId, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/transaktion/$transaktionId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Fehler beim Aktualisieren der Transaktion: Status ${response.statusCode}');
    }
  }

  // --- Transaktion löschen ---

  /// Löscht eine Transaktion via DELETE /api/transaktion/{id}
  Future<void> deleteTransaktion(String transaktionId) async {
    final response = await http.delete(Uri.parse('$_baseUrl/transaktion/$transaktionId'));

    if (response.statusCode == 204 || response.statusCode == 200) {
      return;
    } else if (response.statusCode == 404) {
      throw Exception('Transaktion nicht gefunden.');
    } else {
      throw Exception('Fehler beim Löschen der Transaktion: Status ${response.statusCode}');
    }
  }
}

