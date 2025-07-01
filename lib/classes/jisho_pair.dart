import 'package:kana_kit/kana_kit.dart';

class JishoPair {
  String? k_term;
  String reading;
  String en_term;
  String part;

  static const _kanaKit = KanaKit();

  JishoPair({this.k_term, required this.reading, required this.en_term, required this.part});

  String get ja_term {
    return k_term ?? reading;
  }

  String get romaji {
    return _kanaKit.toRomaji(reading).replaceAll("'", "");
  }

  @override
  String toString() {
    String ret;
    if (k_term != null) {
      ret = '${k_term!} ($reading - $romaji)';
    } else {
      ret = '$reading - $romaji';
    }
    return '$ret: $en_term';
  }
}