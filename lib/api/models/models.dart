// ── Notiz ──────────────────────────────────────────────────

class Notiz {
  final String? id;
  final String name;
  final String inhalt;
  final String? notizblockId;

  Notiz({
    this.id,
    required this.name,
    required this.inhalt,
    this.notizblockId,
  });

  factory Notiz.fromJson(Map<String, dynamic> json) {
    final String foundName = (json['name'] ?? json['titel'] ?? '') as String;
    // Wenn 'id' fehlt, nutzen wir den 'name' als ID (da Name = ID)
    final foundId = (json['id'] ?? json['uuid'] ?? foundName).toString();

    return Notiz(
      id: foundId,
      name: foundName,
      inhalt: (json['inhalt'] ?? '') as String,
      notizblockId: json['notizblock'] != null 
          ? (json['notizblock']['id'] ?? json['notizblock']['uuid'])?.toString() 
          : json['notizblockId']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'name': name,
      'inhalt': inhalt,
    };
    
    if (id != null) data['id'] = id;
    if (notizblockId != null) {
      data['notizblock'] = {'id': notizblockId};
    }
    
    return data;
  }
}

// ── Notizblock ────────────────────────────────────────────────

class Notizblock {
  final String id;
  final String name;
  final List<Notiz> notizen;

  Notizblock({required this.id, required this.name, this.notizen = const []});

  factory Notizblock.fromJson(Map<String, dynamic> json) {
    var list = json['notizen'] as List? ?? [];
    List<Notiz> notizenList = list.map((i) => Notiz.fromJson(i as Map<String, dynamic>)).toList();

    return Notizblock(
      id: (json['id'] ?? json['uuid'] ?? json['name']).toString(),
      name: (json['name'] ?? '') as String,
      notizen: notizenList,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id, 
    'name': name, 
    'notizen': notizen.map((n) => n.toJson()).toList()
  };
}

// ── Gruppe ──────────────────────────────────────────────────

class Gruppe {
  final String id;
  final String name;
  final String? location;
  final String? startDate;
  final String? endDate;
  final List<Benutzer> benutzer;
  final List<Transaktion> transaktionen;
  final List<Notizblock> notizblocks;
  final Planer? planer;

  Gruppe({
    required this.id,
    required this.name,
    this.location,
    this.startDate,
    this.endDate,
    this.benutzer = const [],
    this.transaktionen = const [],
    this.notizblocks = const [],
    this.planer,
  });

  factory Gruppe.fromJson(Map<String, dynamic> json) {
    return Gruppe(
      id: (json['id'] ?? json['uuid']).toString(),
      name: json['name'] as String,
      location: json['location'] as String?,
      startDate: json['startDate'] as String?,
      endDate: json['endDate'] as String?,
      benutzer: (json['benutzer'] as List<dynamic>?)
              ?.map((e) => Benutzer.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      transaktionen: (json['transaktionen'] as List<dynamic>?)
              ?.map((e) => Transaktion.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      notizblocks: (json['notizblocks'] as List<dynamic>?)
              ?.map((e) => Notizblock.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      planer: json['planer'] != null
          ? Planer.fromJson(json['planer'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'startDate': startDate,
      'endDate': endDate,
      'benutzer': benutzer.map((b) => b.toJson()).toList(),
      'transaktionen': transaktionen.map((t) => t.toJson()).toList(),
      'notizblocks': notizblocks.map((n) => n.toJson()).toList(),
      'planer': planer?.toJson(),
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

// ── Benutzer ──────────────────────────────────────────────────

class Benutzer {
  final String name;
  final List<String> freunde;

  Benutzer({required this.name, this.freunde = const []});

  factory Benutzer.fromJson(Map<String, dynamic> json) {
    return Benutzer(
      name: json['name'] as String,
      freunde: (json['freunde'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {'name': name, 'freunde': freunde};
}

// ── Transaktion ───────────────────────────────────────────────

class Transaktion {
  final String id;
  final Map<String, dynamic> raw;

  Transaktion({required this.id, required this.raw});

  factory Transaktion.fromJson(Map<String, dynamic> json) {
    return Transaktion(id: (json['id'] ?? json['uuid']).toString(), raw: json);
  }

  Map<String, dynamic> toJson() => raw;
}

// ── Planer ────────────────────────────────────────────────────

class Planer {
  final String id;
  final String name;
  final List<dynamic> events;

  Planer({required this.id, required this.name, this.events = const []});

  factory Planer.fromJson(Map<String, dynamic> json) {
    return Planer(
      id: (json['id'] ?? json['uuid']).toString(),
      name: json['name'] as String,
      events: json['events'] as List<dynamic>? ?? [],
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'events': events};
}
