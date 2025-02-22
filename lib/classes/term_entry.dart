import 'package:kana_kit/kana_kit.dart';

class TermEntry {
  String en_term;
  String? k_term;
  String _ja_reading;
  late String _romaji;

  final _kanaKit = const KanaKit();

  TermEntry({required this.en_term, String? this.k_term, required String reading}) : _ja_reading = reading {
    _romaji = _kanaKit.toRomaji(_ja_reading);
  }

  String get ja_term {
    return k_term ?? _ja_reading;
  }

  set reading (String kana) {
    _ja_reading = kana;
    _romaji = _kanaKit.toRomaji(_ja_reading);
  }

  String get reading {
    return _ja_reading;
  }

  set romaji_h (String rom) {
    _romaji = rom;
    _ja_reading = _kanaKit.toHiragana(_romaji);
  }

  set romaji_k (String rom) {
    _romaji = rom;
    _ja_reading = _kanaKit.toKatakana(_romaji);
  }

  String get romaji {
    return _romaji;
  }
}