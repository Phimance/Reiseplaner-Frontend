import 'notiz.dart';

class Notizblock {
  final String id;
  final String name;
  final List<Notiz> notizen;

  Notizblock({required this.id, required this.name, required this.notizen});

  factory Notizblock.fromJson(Map<String, dynamic> json) {
    var list = json['notizen'] as List? ?? [];
    List<Notiz> notizenList = list.map((i) => Notiz.fromJson(i)).toList();

    return Notizblock(
      id: json['id'] as String,
      name: json['name'] as String,
      notizen: notizenList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'notizen': notizen.map((n) => n.toJson()).toList(),
    };
  }
}
