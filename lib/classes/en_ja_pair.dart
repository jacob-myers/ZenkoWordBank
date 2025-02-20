import 'sense.dart';

class EnJaPair {
  int pri;
  int? freq_group;
  String ja_value;
  List<Sense> en_senses;

  EnJaPair({required this.pri, required this.ja_value, required this.en_senses, this.freq_group});

  factory EnJaPair.fromUnparsedSenses(int pri, String ja_value, String unpSenses) {
    return EnJaPair(pri: pri, ja_value: ja_value, en_senses: unpSenses.split('~').map((sense) => Sense.fromUnparsed(sense)).toList());
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

  @override
  String toString() {
    return "$ja_value ($freq_group, $pri): $en_senses";
  }
}