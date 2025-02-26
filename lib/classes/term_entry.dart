import 'package:kana_kit/kana_kit.dart';

class TermEntry {
  int? id;
  String en_term;
  String? k_term;
  String reading;

  final _kanaKit = const KanaKit();

  TermEntry({this.id, required this.en_term, String? this.k_term, required this.reading});

  factory TermEntry.fromMap(Map<String, dynamic> json) {
    return TermEntry(
      id: json["id"],
      en_term: json["en_term"],
      k_term: json["kanji"],
      reading: json["reading"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'en_term': en_term,
      'kanji': k_term,
      'reading': reading,
    };
  }

  String get ja_term {
    return k_term ?? reading;
  }

  String get romaji {
    return _kanaKit.toRomaji(reading);
  }
}