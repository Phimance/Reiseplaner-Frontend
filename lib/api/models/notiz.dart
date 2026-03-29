class Notiz {
  final String? id;
  final String name;
  final String inhalt;
  final String? notizblockId;

  Notiz({this.id, required this.name, required this.inhalt, this.notizblockId});

  factory Notiz.fromJson(Map<String, dynamic> json) {
    return Notiz(
      id: json['id'] as String?,
      name: (json['name'] ?? '') as String,
      inhalt: (json['inhalt'] ?? '') as String,
      notizblockId: json['notizblock'] != null
          ? json['notizblock']['id'] as String?
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'inhalt': inhalt,
      if (notizblockId != null) 'notizblock': {'id': notizblockId},
    };
  }
}
