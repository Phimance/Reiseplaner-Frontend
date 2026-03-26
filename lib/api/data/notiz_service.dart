import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/models.dart';

class NotizService {
  final String _baseUrl = 'http://ubuntu.p-stephan.de:8081/api';

  /// 1) Existierenden Notizblock der Gruppe prüfen
  Future<Notizblock?> getNotizblockByGruppe(String gruppeId) async {
    final response = await http.get(Uri.parse('$_baseUrl/notizblock/gruppe/$gruppeId'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      if (jsonList.isNotEmpty) {
        return Notizblock.fromJson(jsonList.first);
      }
    }
    return null;
  }

  /// 2) Notizblock anlegen
  Future<Notizblock> createNotizblock(String gruppeId, String name) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/notizblock'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        "gruppe": {"id": gruppeId},
        "name": name
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return Notizblock.fromJson(json.decode(response.body));
    }
    throw Exception('Fehler beim Erstellen des Notizblocks');
  }

  /// 3) Notiz anlegen
  Future<Notiz> createNotiz(Notiz notiz) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/notiz'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(notiz.toJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return Notiz.fromJson(json.decode(response.body));
    }
    throw Exception('Fehler beim Erstellen der Notiz');
  }

  /// 4) Notiz aktualisieren (PUT)
  Future<Notiz> updateNotiz(Notiz notiz) async {
    if (notiz.id == null) throw Exception('Notiz ID fehlt für Update');
    
    final response = await http.put(
      Uri.parse('$_baseUrl/notiz/${notiz.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(notiz.toJson()),
    );

    if (response.statusCode == 200) {
      return Notiz.fromJson(json.decode(response.body));
    }
    throw Exception('Fehler beim Aktualisieren der Notiz: Status ${response.statusCode}');
  }

  /// Alle Notizen eines Notizblocks laden
  Future<List<Notiz>> getNotizenByNotizblock(String notizblockId) async {
    final response = await http.get(Uri.parse('$_baseUrl/notiz/notizblock/$notizblockId'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Notiz.fromJson(json)).toList();
    }
    return [];
  }
}
