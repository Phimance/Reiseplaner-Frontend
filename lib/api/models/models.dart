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
    List<Benutzer> benutzerList = [];
    try {
      benutzerList = (json['benutzer'] as List<dynamic>?)
              ?.map((e) => Benutzer.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [];
    } catch (e) {
      print('⚠️ Fehler beim Parsen von benutzer: $e');
    }

    List<Transaktion> transaktionenList = [];
    try {
      transaktionenList = (json['transaktionen'] as List<dynamic>?)
              ?.map((e) => Transaktion.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [];
    } catch (e) {
      print('⚠️ Fehler beim Parsen von transaktionen: $e');
    }

    List<Notizblock> notizblocksList = [];
    try {
      notizblocksList = (json['notizblocks'] as List<dynamic>?)
              ?.map((e) => Notizblock.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [];
    } catch (e) {
      print('⚠️ Fehler beim Parsen von notizblocks: $e');
    }

    Planer? planerObj;
    try {
      planerObj = json['planer'] != null
          ? Planer.fromJson(json['planer'] as Map<String, dynamic>)
          : null;
    } catch (e) {
      print('⚠️ Fehler beim Parsen von planer: $e');
    }

    return Gruppe(
      id: json['id'] as String,
      name: json['name'] as String,
      location: json['location'] as String?,
      startDate: json['startDate'] as String?,
      endDate: json['endDate'] as String?,
      benutzer: benutzerList,
      transaktionen: transaktionenList,
      notizblocks: notizblocksList,
      planer: planerObj,
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
  final String? id;
  final String transaktionsname;
  final String bezahlername;
  final double gesamtwert;
  final List<Transaktionsperson> transaktionspersonen;

  Transaktion({
    this.id,
    required this.transaktionsname,
    required this.bezahlername,
    required this.gesamtwert,
    this.transaktionspersonen = const [],
  });

  factory Transaktion.fromJson(Map<String, dynamic> json) {
    return Transaktion(
      id: json['id'] as String?,
      transaktionsname: json['transaktionsname'] as String,
      bezahlername: json['bezahlername'] as String,
      gesamtwert: (json['gesamtwert'] as num).toDouble(),
      transaktionspersonen: (json['transaktionspersonen'] as List<dynamic>?)
              ?.map((e) =>
                  Transaktionsperson.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'transaktionsname': transaktionsname,
        'bezahlername': bezahlername,
        'gesamtwert': gesamtwert,
        'transaktionspersonen':
            transaktionspersonen.map((tp) => tp.toJson()).toList(),
      };

  @override
  String toString() =>
      'Transaktion(id: $id, transaktionsname: $transaktionsname, gesamtwert: $gesamtwert)';
}

// ── Transaktionsperson ────────────────────────────────────────

class Transaktionsperson {
  final String? id;
  final String schuldner;
  final double anteil;

  Transaktionsperson({
    this.id,
    required this.schuldner,
    required this.anteil,
  });

  factory Transaktionsperson.fromJson(Map<String, dynamic> json) {
    return Transaktionsperson(
      id: json['id']?.toString(),
      schuldner: json['schuldner'] as String,
      anteil: (json['anteil'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'schuldner': schuldner,
        'anteil': anteil,
      };

  @override
  String toString() => 'Transaktionsperson(schuldner: $schuldner, anteil: $anteil)';
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
