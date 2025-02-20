import 'package:collection/collection.dart';

class EnEntry {
  int enID;
  List<Sense> senses;

  EnEntry(this.enID, this.senses);

  int priMax() {
    return senses.map((e) => e.pri).max;
  }

  factory EnEntry.fromUnparsed(enID, String unpEntry) {
    return EnEntry(enID, unpEntry.split('~').map((sense) => Sense.fromUnparsed(sense)).toList());
  }
}



// collection of JaEntries matching with the same EnEntry.
class JaBlob {
  int pri;
  List<JaEntry> entries;

  JaBlob(this.pri, this.entries);
}

class JaEntry {
  int pri;
  String value;

  JaEntry(this.pri, this.value);
}

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

class Sense {
  final int pri;
  final List<String> glosses;

  Sense(this.pri, this.glosses);

  factory Sense.fromUnparsed(String unpSense) {
    List<String> glosses = unpSense.split('`');
    int pri = int.parse(glosses.removeAt(0));
    return Sense(pri, glosses);
  }

  @override
  String toString() {
    //return "Priority: $pri\n${glosses.join('\n')}";
    return "($pri) ${glosses.join(" / ")}";
  }
}