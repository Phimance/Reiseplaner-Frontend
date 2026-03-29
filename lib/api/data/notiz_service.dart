import 'dart:convert';
import 'package:flutter/foundation.dart'; // Für compute
import 'package:http/http.dart' as http;
import '../models/models.dart';

//  Parsen in Hintergrund-Thread (Isolate).
//  außerhalb der Klasse, damit compute() funktioniert

Notizblock? _parseNotizblockFromList(String responseBody) {
  final List<dynamic> jsonList = json.decode(responseBody);
  if (jsonList.isNotEmpty) {
    return Notizblock.fromJson(jsonList.first);
  }
  return null;
}

Notizblock _parseSingleNotizblock(String responseBody) {
  return Notizblock.fromJson(json.decode(responseBody));
}

Notiz _parseSingleNotiz(String responseBody) {
  return Notiz.fromJson(json.decode(responseBody));
}

List<Notiz> _parseNotizenList(String responseBody) {
  final List<dynamic> jsonList = json.decode(responseBody);
  return jsonList.map((json) => Notiz.fromJson(json)).toList();
}

class NotizService {
  final String _baseUrl = 'http://ubuntu.p-stephan.de:8081/api';

  /// 1) Existierenden Notizblock der Gruppe prüfen
  Future<Notizblock?> getNotizblockByGruppe(String gruppeId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/notizblock/gruppe/$gruppeId'),
    );
    if (response.statusCode == 200) {
      return compute(_parseNotizblockFromList, response.body);
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
        "name": name,
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return compute(_parseSingleNotizblock, response.body);
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
      return compute(_parseSingleNotiz, response.body);
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
      return compute(_parseSingleNotiz, response.body);
    }
    throw Exception(
      'Fehler beim Aktualisieren der Notiz: Status ${response.statusCode}',
    );
  }

  /// 5) Notiz löschen (DELETE)
  Future<void> deleteNotiz(String id) async {
    final response = await http.delete(Uri.parse('$_baseUrl/notiz/$id'));
    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception(
        'Fehler beim Löschen der Notiz: Status ${response.statusCode}',
      );
    }
  }

  /// Alle Notizen eines Notizblocks laden
  Future<List<Notiz>> getNotizenByNotizblock(String notizblockId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/notiz/notizblock/$notizblockId'),
    );
    if (response.statusCode == 200) {
      return compute(_parseNotizenList, response.body);
    }
    return [];
  }
}
