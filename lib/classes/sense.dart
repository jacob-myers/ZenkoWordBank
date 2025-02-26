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
    return glosses.join(" / ");
  }
}