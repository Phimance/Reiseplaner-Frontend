/// Datenmodell für eine Gruppe aus der API.
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
      id: json['id'] as String,
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
    return Transaktion(id: json['id'] as String, raw: json);
  }

  Map<String, dynamic> toJson() => raw;
}

// ── Notizblock ────────────────────────────────────────────────

class Notizblock {
  final String id;
  final String name;
  final List<dynamic> notizen;

  Notizblock({required this.id, required this.name, this.notizen = const []});

  factory Notizblock.fromJson(Map<String, dynamic> json) {
    return Notizblock(
      id: json['id'] as String,
      name: json['name'] as String,
      notizen: json['notizen'] as List<dynamic>? ?? [],
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'notizen': notizen};
}

// ── Planer ────────────────────────────────────────────────────

class Planer {
  final String id;
  final String name;
  final List<Event> events;

  Planer({required this.id, required this.name, this.events = const []});

  factory Planer.fromJson(Map<String, dynamic> json) {
    return Planer(
      id: json['id'] as String,
      name: json['name'] as String,
      events: (json['events'] as List<dynamic>?)
              ?.map((e) => Event.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'events': events.map((e) => e.toJson()).toList(),
      };
}

// ── Event ────────────────────────────────────────────────────

class Event {
  final String id;
  final String datumStart;
  final String datumEnde;
  final String titel;
  final String? beschreibung;
  final String? location;

  Event({
    required this.id,
    required this.datumStart,
    required this.datumEnde,
    required this.titel,
    this.beschreibung,
    this.location,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] as String,
      datumStart: json['datumStart'] as String,
      datumEnde: json['datumEnde'] as String,
      titel: json['titel'] as String,
      beschreibung: json['beschreibung'] as String?,
      location: json['location'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'datumStart': datumStart,
        'datumEnde': datumEnde,
        'titel': titel,
        'beschreibung': beschreibung,
        'location': location,
      };

  @override
  String toString() => 'Event(id: $id, titel: $titel)';
}
