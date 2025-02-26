import 'sense.dart';

class EnJaPair {
  int pri;
  int? freq_group;
  String? k_term;
  String reading;
  List<Sense> en_senses;

  EnJaPair({required this.pri, this.k_term, required this.reading, required this.en_senses, this.freq_group});

  factory EnJaPair.fromUnparsedSenses(int pri, String? k_term, String reading, String unpSenses) {
    return EnJaPair(pri: pri, k_term: k_term, reading: reading, en_senses: unpSenses.split('~').map((sense) => Sense.fromUnparsed(sense)).toList());
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
    return en_senses[0].toString();
  }

  @override
  String toString() {
    return "$k_term ($freq_group, $pri): $en_senses";
  }
}