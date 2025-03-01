import 'package:japanese_word_bank/classes/term_entry.dart';
import 'package:japanese_word_bank/classes/trie.dart';

var wordSplit = RegExp(" +");

Set<T> intersect<T>(Set<T> a, Set<T> b) {
  a.retainAll(b);
  return a;
}

class TermSearch {
  Trie<TermEntry> index = Trie();

  TermSearch(List<TermEntry> terms) {
    terms.forEach(addToIndex);
  }

  void addToIndex(TermEntry term) {
    term.en_term.split(wordSplit).forEach((w) => index.insert(w.toLowerCase(), term));
    term.k_term != null ? index.insert(term.k_term!, term) : null;
    index.insert(term.reading, term);
    index.insert(term.romaji, term);
  }

  void removeFromIndex(TermEntry term) {
    term.en_term.split(wordSplit).forEach((w) => index.remove(w.toLowerCase(), term));
    term.k_term != null ? index.remove(term.k_term!, term) : null;
    index.remove(term.reading, term);
    index.remove(term.romaji, term);
  }

  void clear() {
    index = Trie();
  }

  List<TermEntry> search(String query) {
    return query.toLowerCase()
      .split(wordSplit)
      .map((t) => index.search(t).toSet())
      .reduce(intersect)
      .toList();
  }
}