import 'package:kana_kit/kana_kit.dart';

import 'sense.dart';

class EnJaPair {
  int pri;
  int? freq_group;
  String? k_term;
  String reading;
  List<Sense> en_senses;

  static const _kanaKit = KanaKit();

  EnJaPair({required this.pri, this.k_term, required this.reading, required this.en_senses, this.freq_group});

  factory EnJaPair.fromUnparsedSenses({required int pri, String? k_term, required String reading, required String unpSenses, int? freq_group}) {
    return EnJaPair(pri: pri, k_term: k_term, reading: reading, en_senses: unpSenses.split('~').map((sense) => Sense.fromUnparsed(sense)).toList(), freq_group: freq_group);
  }

  String get ja_term {
    return k_term ?? reading;
  }

  bool isDirectMatch(String en_term) {
    RegExp termMatcher = RegExp('^${en_term.toLowerCase()}|[ \\-\\(]${en_term.toLowerCase()}');
    for (final sense in en_senses) {
      for (String gloss in sense.glosses) {
        if (termMatcher.hasMatch(gloss.toLowerCase())) {
          return true;
        }
      }
    }
    return false;
  }

  String get en_term {
    return en_senses.reduce((a, b) => a.pri > b.pri ? a : b).toString();
  }

  String get romaji {
    return _kanaKit.toRomaji(reading);
  }

  @override
  String toString() {
    return "$k_term ($freq_group, $pri): $en_senses";
  }
}