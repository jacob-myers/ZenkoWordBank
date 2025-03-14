import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:collection/collection.dart';

import 'package:kana_kit/kana_kit.dart';
import 'package:tuple/tuple.dart';
import 'package:sqflite/sqflite.dart';
import 'package:string_similarity/string_similarity.dart';
import 'package:path_provider/path_provider.dart';

// Local
import 'package:japanese_word_bank/classes/en_ja_pair.dart';
import 'package:japanese_word_bank/classes/sense.dart';
import 'package:japanese_word_bank/classes/term_entry.dart';

class DictDatabaseHelper {
  double en_pri_min = 0, en_pri_max = 10;
  double ja_pri_min = 0, ja_pri_max = 10;
  double str_sim_min = 0, str_sim_max = 1;
  double freq_min = 1, freq_max = 49;

  double en_pri_weight = 1;
  double ja_pri_weight = 1;
  double str_sim_weight = 3;
  double freq_weight = 2;

  final _kanaKit = const KanaKit();

  DictDatabaseHelper._privateConstructor();
  static final DictDatabaseHelper instance = DictDatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {

    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/jmedict.db';

    if (!await databaseExists(path)) {
      await _copyDatabaseFromAssets(path);
    }
    return await openDatabase(path);
  }

  Future<void> _copyDatabaseFromAssets(String path) async {
    // Load the database from assets
    final byteData = await rootBundle.load('assets/jmedict.db');
    final bytes = byteData.buffer.asUint8List();

    // Write the bytes to the document directory
    await File(path).writeAsBytes(bytes);
  }

  // Get the top n results of translating.
  Future<List<EnJaPair>> _translateNResults(String term, int n, bool en_to_ja) async {
    List<EnJaPair> results = en_to_ja ? await translateToJa(term) : await translateToEn(term);
    n = n > results.length ? results.length : n;
    //if (n == 0) { return []; }
    return results.sublist(0, n);
  }
  Future<List<EnJaPair>> translateToJaN(String en_term, int n) async {
    return _translateNResults(en_term, n, true);
  }
  Future<List<EnJaPair>> translateToEnN(String ja_term, int n) async {
    return _translateNResults(ja_term, n, false);
  }

  // Takes a string en_term and returns a list of JaEntry matches.
  Future<List<EnJaPair>> translateToJa(String en_term) async {
    // Joins JA_TERMS and EN_TERMS where the enIDs are equal and en value contains en_term.
    // i.e Finds english matches and their related japanese elements.

    if (en_term.isEmpty) {
      return [];
    }

    Database db = await instance.database;

    List<dynamic> res = [];
    res = await db.rawQuery('''
      SELECT ja.pri as ja_pri, ja.value as ja_value, ja.reading as reading, en.value as en_value, ja.freqGroup as freq_group
      FROM JA_TERMS ja
      JOIN EN_TERMS en
      ON ja.enID = en.enID
      WHERE (en.value LIKE '%`${en_term.toLowerCase()}%'
          OR en.value LIKE '% ${en_term.toLowerCase()}%')
        AND ja.freqGroup IS NOT NULL
      ORDER BY ja.freqGroup
      LIMIT 1000
    ''');

    // If there aren't many results.
    if (res.length < 10) {
      res = await db.rawQuery('''
      SELECT ja.pri as ja_pri, ja.value as ja_value, ja.reading as reading, en.value as en_value, ja.freqGroup as freq_group
      FROM JA_TERMS ja
      JOIN EN_TERMS en
      ON ja.enID = en.enID
      WHERE en.value LIKE '%${en_term.toLowerCase()}%'
    ''');
    }

    // Constructs EnJaPairs from matches.
    List<EnJaPair> matches = res.map((e) {
      return EnJaPair(
        pri: e['ja_pri'],
        k_term: e['reading'] == null ? null : e['ja_value'],
        reading: e['reading'] ?? e['ja_value'],
        // Gets senses containing en_term then maps them to become Sense objects.
        en_senses: sensesContainingX(e['en_value'].toLowerCase(), en_term.toLowerCase()).map((e) {
          return Sense.fromUnparsed(e);
        }).toList(),
        freq_group: e['freq_group']
      );
    }).toList();

    // Remove non-direct matches ("othello" removed from "hello" results)
    matches.removeWhere((pair) => !pair.isDirectMatch(en_term));

    // Sorts the matches by their relevance score (Closer to 1 is earlier).
    List<Tuple2<double, EnJaPair>> tuples = List.generate(matches.length, (index) {
      return Tuple2(scoreEnMatch(en_term, matches[index]), matches[index]);
    });

    tuples.sort((a, b) => b.item1.compareTo(a.item1));
    List<EnJaPair> sorted = tuples.map((e) => e.item2).toList();

    return sorted;
  }

  Future<List<EnJaPair>> translateToEn(String ja_term) async {
    // Translates a given Japanese term to English.
    if (ja_term.isEmpty) {
      return [];
    }

    // Defines the 'where' clause of the SQL query. If it's romaji,
    // converts to phonetic and looks for it.
    String where = '''
      (ja.value LIKE '%$ja_term%'
        OR ja.reading LIKE '$ja_term%')
    ''';
    if (_kanaKit.isRomaji(ja_term)) {
      where = '''
        (ja.reading LIKE '${_kanaKit.toHiragana(ja_term)}%'
          OR ja.reading LIKE '${_kanaKit.toKatakana(ja_term)}%'
          OR ja.value LIKE '${_kanaKit.toHiragana(ja_term)}%'
          OR ja.value LIKE '${_kanaKit.toKatakana(ja_term)}%')
      ''';
    }

    Database db = await instance.database;

    List<dynamic> res = [];
    res = await db.rawQuery('''
      SELECT ja.pri as ja_pri, ja.value as ja_value, ja.reading as reading, en.value as en_value, ja.freqGroup as freq_group
      FROM JA_TERMS ja
      JOIN EN_TERMS en
      ON ja.enID = en.enID
      WHERE $where
        AND ja.freqGroup IS NOT NULL
      ORDER BY ja.freqGroup
      LIMIT 1000
    ''');

    // If there aren't many results.
    if (res.length < 10) {
      res = await db.rawQuery('''
      SELECT ja.pri as ja_pri, ja.value as ja_value, ja.reading as reading, en.value as en_value, ja.freqGroup as freq_group
      FROM JA_TERMS ja
      JOIN EN_TERMS en
      ON ja.enID = en.enID
      WHERE $where
    ''');
    }

    // Constructs EnJaPairs from matches.
    List<EnJaPair> matches = res.map((e) {
      return EnJaPair.fromUnparsedSenses(
        pri:  e['ja_pri'],
        k_term:  e['reading'] == null ? null : e['ja_value'],
        reading: e['reading'] ?? e['ja_value'],
        unpSenses: e['en_value'],
        freq_group: e['freq_group']
      );
    }).toList();

    List<Tuple2<double, EnJaPair>> tuples = List.generate(matches.length, (index) {
      return Tuple2(scoreJaMatch(ja_term, matches[index]), matches[index]);
    });

    tuples.sort((a, b) => b.item1.compareTo(a.item1));
    List<EnJaPair> sorted = tuples.map((e) => e.item2).toList();

    return sorted;
  }

  // Score a match with a pair + an English string.
  double scoreEnMatch(String en_term, EnJaPair pair) {
    return _scoreMatch(en_term, pair, true);
  }

  // Score a match with a pair + a Japanese string.
  double scoreJaMatch(String ja_term, EnJaPair pair) {
    return _scoreMatch(ja_term, pair, false);
  }

  // Calculates the relevance of the pair to the en_term.
  double _scoreMatch(String term, EnJaPair pair, bool en) {

    /*
    matches = [EnJaPair, EnJaPair, ...]
    EnJaPair.pri -> JA PRI (Originating from <ke_inf> and <re_inf> tags)

    EnJaPair.en_senses = [Sense, Sense, Sense]
    Sense.pri -> EN PRI (Originating from <misc> tags)

    en - StringLikeness(Related gloss in Sense.glosses, en_term) -> SIMILARITY
    !en - StringLikeness(Term compared to each japanese writing of term) -> SIMILARITY

    EnJaPair.freq_group -> FREQ GROUP

    Range:
      SIMILARITY: 0 1
      FREQ GROUP: 1 48 (or null)
      EN PRI: -10 0
      JA PRI: -10 0
    */

    double ja_pri = pair.pri.toDouble();
    double en_pri = pair.en_senses.map((e) => e.pri).max.toDouble();

    double str_sim;
    if (en) {
      RegExp parenMatcher = RegExp(r'\(.*?\)');
      str_sim = pair.en_senses.map((e) => e.glosses.map((g) {
        return g.replaceAll(parenMatcher, "").similarityTo(term);
      }).max).max;
    } else {
      str_sim = [pair.reading, pair.k_term, pair.romaji].map((e) {
        return e.similarityTo(term);
      }).max;
    }

    // Freq group if exists, otherwise 49 (off the end).
    double freq_group = (pair.freq_group ?? freq_max).toDouble();

    en_pri = normalize(en_pri, en_pri_min, en_pri_max);
    ja_pri = normalize(ja_pri, ja_pri_min, ja_pri_max);
    str_sim = normalize(str_sim, str_sim_min, str_sim_max);
    freq_group = normalize(freq_max-freq_group, freq_min, freq_max);
    //print("${pair.ja_value}: $en_pri $ja_pri $str_sim $freq_group");

    double score =
        en_pri_weight * en_pri +
        ja_pri_weight * ja_pri +
        str_sim_weight * str_sim +
        freq_weight * freq_group;
    //print("$pair: $score");
    return score;
  }

  double normalize(double x, double min_x, double max_x) {
    return (x-min_x)/(max_x-min_x);
  }

  List<String> sensesContainingX(String unpSenses, String x) {
    return unpSenses.split("~").where((sense) => sense.contains(x)).toList();
  }

  Future<TermEntry> getRandomWord(int seed) async {
    var r = Random(seed);
    int rInt = r.nextInt(1000000);

    Database db = await instance.database;
    var res = await db.rawQuery('''
      SELECT ja.value as ja_value, ja.reading as reading, en.value as en_value
      FROM JA_TERMS ja
      JOIN EN_TERMS en
      ON ja.enID = en.enID
      WHERE ja.freqGroup IS NOT NULL
      LIMIT 1 OFFSET ($rInt % (SELECT COUNT(*) - 1 FROM JA_TERMS ja JOIN EN_TERMS en ON ja.enID = en.enID WHERE ja.freqGroup IS NOT NULL))
    ''');
    var first = res.first;
    var ej = EnJaPair.fromUnparsedSenses(
      pri: 0,
      k_term: first['reading'] == null ? null : first['ja_value'].toString(),
      reading: first['reading'] == null ? first['ja_value'].toString() : first['reading'].toString(),
      unpSenses: first['en_value'].toString(),
    );
    return TermEntry.fromEnJaPair(ej);
  }
}