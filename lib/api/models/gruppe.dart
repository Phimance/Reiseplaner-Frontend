/// Datenmodell für eine Gruppe aus der API.
class Gruppe {
  final String id;
  final String name;

  Gruppe({
    required this.id,
    required this.name,
  });

  /// Erstellt ein Gruppe-Objekt aus einer JSON-Map.
  factory Gruppe.fromJson(Map<String, dynamic> json) {
    return Gruppe(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }

  /// Wandelt das Objekt in eine JSON-Map um.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  @override
  String toString() => 'Gruppe(id: $id, name: $name)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Gruppe && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

