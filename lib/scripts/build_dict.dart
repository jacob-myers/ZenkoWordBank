import 'dart:io';
import 'dart:math';

import 'package:sqlite3/sqlite3.dart';
import 'package:xml/xml.dart' as xml;

// WILL OVERRIDE jmedict.db IN ASSETS, CRUCIAL TO APP TRANSLATION FUNCTIONALITY.
// Converts ./lib/data/JMdict_e.xml to a sqlite database in ./assets/jmedict.db
void main() async {
  print('Using sqlite3 ${sqlite3.version}');

  final file = File('./lib/data/JMdict_e.xml');
  final contents = await file.readAsString();
  final document = xml.XmlDocument.parse(contents);

  // Builds the dictionary database in the assets folder (THIS WILL OVERRIDE WHAT IS THERE).
  final dbFilePath_k = './assets/jmedict.db';
  final db_k = sqlite3.open(dbFilePath_k);

  // If tables exist, empty them, if they don't exist, init them.
  try {
    initTables(db_k);
  } catch (e) {
    truncate(db_k);
  }
  read_xml_and_build_db_exclude_rel(db_k, document);
  deleteUnwantedRows(db_k);

  /*
  // Selects all from the database.
  final resk = db_k.select('''
    SELECT ja.pri as ja_pri, ja.freqGroup as freq_group, ja.value as ja_value, ja.reading as ja_reading, en.value as en_value
    FROM JA_TERMS ja
    JOIN EN_TERMS en
    ON ja.enID = en.enID
  ''');
  print(resk.length);
  */
}

// Maps a <misc> value to a priority modifier.
Map<String, int> misc_pris = {
  "&company;" : -100,
  "&given;" : -100,
  "&organization;" : -100,
  "&person;" : -100,
  "&surname;" : -100,
  "&ship;" : -100,
  "&work;" : -100,
  "&abbr;" : -2,
  "&arch;" : -3,
  "&dated;" : -1,
  "&rare;" : -1,
};

// Maps a <ke_inf> value to a priority modifier.
Map<String, int> ke_inf_pris = {
  "&sK;" : -100,
  "&ik;" : -100,
  "&iK;" : -100,
  "&oK;" : -3,
  "&rK;" : -1,
  "&io;" : -2,
};

// Maps a <re_inf> value to a priority modifier.
Map<String, int> re_inf_pris = {
  "&sk;" : -100,
  "&ik;" : -100,
  "&ok;" : -3,
  "&rk;" : -1,
};

// Substitutes a frequency group for values that aren't in nf.
Map<String, int> freq_group_sub = {
  //"news1": 1,  // 12,000 most frequent
  //"news2": 1,  // 12,000-24,000 most frequent
  "ichi1": 12,
  "ichi2": 24,
  "spec1": 12,
  "spec2": 24,
  "gai1": 24,
  "gai2": 48,
  //"nfxx": 1,  // xx: 01-48
};

// For cutting the freq group from entries where assigned (related to news1/2, from nfxx in xml doc)
RegExp freqGroupMatch = RegExp(r"nf[0-9][0-9]");  // Groups: 01-48

// Build a database attempting to shrink data set.
//! Excludes reading elements as separate rows when they have a related Kanji element.
void read_xml_and_build_db_exclude_rel(Database db, xml.XmlDocument doc) {
  final insertEnglish = db.prepare('''
    INSERT INTO EN_TERMS
    (value)
    VALUES (?)
  ''');

  final insertJapanese = db.prepare('''
    INSERT INTO JA_TERMS
    (value, reading, pri, freqGroup, enID)
    VALUES (?, ?, ?, ?, ?)
  ''');

  final entries = doc.findAllElements('entry');

  for (final entry in entries) {
    bool uk = false;

    // Parse english data from this entry.
    // Senses are delimited by '~', glosses are delimited by '`'. First element of sense is pri for that sense.
    List<String> senses = []; // each element is a senses combined glosses and a priority.
    for (final sense in entry.findElements('sense')) {
      // Sums primod for this sense from misc tags.
      int primod = 0;
      for (final misc in sense.findElements('misc')) {
        if (misc.text == "&uk;") {
          uk = true;
        }
        if (misc_pris.containsKey(misc.text)) {
          primod += misc_pris[misc.text]!;
        }
      }
      // Don't use this sense.
      if (primod <= -100) {
        continue;
      }

      // Collect all glosses from this sense.
      List<String> glosses = [];
      for (final gloss in sense.findElements('gloss')) {
        glosses.add(gloss.text);
      }
      // Add this sense to senses.
      senses.add("$primod`${glosses.join("`")}");
    }
    // Concat senses together and delimit with "&"
    String? en_row;
    if (senses.isNotEmpty) {
      en_row = senses.join("~");
    }

    // Put all content from kebs here.
    List<List<dynamic>> kebs = [];
    Map<String, List<String>> possibleReadings = {};
    Map<String, int> readingPri = {};

    // Parse kanji related terms (0+)
    for (final k_ele in entry.findElements('k_ele')) {

      // Calculate the freqGroup with any <ke_pri> info.
      int? freqGroup;
      for (final ke_pri in k_ele.findElements("ke_pri")) {
        int? tmp;
        if(freqGroupMatch.hasMatch(ke_pri.text)) {
          tmp = int.parse(ke_pri.text.substring(2, 4));
        } else if (freq_group_sub.containsKey(ke_pri.text)) {
          tmp = freq_group_sub[ke_pri.text]!;
        }
        if (tmp != null){
          freqGroup = (min(tmp, freqGroup ?? 50) / (freqGroup==null? 1 : 2)).ceil();
        }
      }

      // Get all ke_infs from k_ele
      int primod = 0;
      for (final ke_inf in k_ele.findElements("ke_inf")) {
        if(ke_inf_pris.containsKey(ke_inf.text)) {
          primod += ke_inf_pris[ke_inf.text]!;
        }
      }
      if (primod <= -100) {
        continue;
      }
      if (uk) {
        primod-=4;
      }

      // Only 1 keb per k_ele
      var val = k_ele.findElements('keb').first.text;

      kebs.add([val, primod, freqGroup]);
      possibleReadings[val] = [];
    }

    // Put all content from kebs here.
    List<List<dynamic>> rebs = [];

    // Parse non-kanji related terms (1+)
    for (final r_ele in entry.findElements('r_ele')) {

      // Calculate the freqGroup with any <ke_pri> info.
      int? freqGroup;
      for (final re_pri in r_ele.findElements("re_pri")) {
        int? tmp;
        if(freqGroupMatch.hasMatch(re_pri.text)) {
          tmp = int.parse(re_pri.text.substring(2, 4));
        } else if (freq_group_sub.containsKey(re_pri.text)) {
          tmp = freq_group_sub[re_pri.text]!;
        }
        if (tmp != null){
          freqGroup = (min(tmp, freqGroup ?? 50) / (freqGroup==null? 1 : 2)).ceil();
        }
      }

      // Get all re_infs from r_ele
      int primod = 0;
      for (final re_inf in r_ele.findElements("re_inf")) {
        if(re_inf_pris.containsKey(re_inf.text)) {
          primod += re_inf_pris[re_inf.text]!;
        }
      }
      if (primod <= -100) {
        continue;
      }

      // Only 1 reb per r_ele.
      var val = r_ele.findElements('reb').first.text;

      readingPri[val] = primod + 49 - (freqGroup ?? 49);

      // If it only applies to specific Kanji (skips last part)
      final re_restrs = r_ele.findElements("re_restr");
      for (final re_restr in re_restrs) {
        if (possibleReadings.keys.contains(re_restr.text)) {
          possibleReadings[re_restr.text]!.add(val);
          readingPri[val] = readingPri[val]! + 1;
        }
      }
      if (re_restrs.isNotEmpty) {
        continue;
      }

      rebs.add([val, primod, freqGroup]);
      for (final key in possibleReadings.keys) {
        possibleReadings[key]!.add(val);
      }
    }

    // If no reading elements or no english elements.
    if (readingPri.isEmpty) {
      continue;
    }
    if (en_row == null) {
      continue;
    }

    insertEnglish.execute([en_row]);
    int enID = db.lastInsertRowId;

    if (uk || (rebs.isNotEmpty && kebs.isEmpty)) {
      for (final reb in rebs) {
        insertJapanese.execute([reb[0], null, reb[1], reb[2], enID]);
      }
    }
    if (kebs.isNotEmpty) {
      for (final keb in kebs) {
        if (possibleReadings[keb[0]]!.isNotEmpty) {
          final String best_reb = possibleReadings[keb[0]]!.reduce((a, b) => readingPri[a]! > readingPri[b]! ? a : b);
          insertJapanese.execute([keb[0], best_reb, keb[1], keb[2], enID]);
        }
      }
    }
  }
}

void deleteUnwantedRows(Database db) {
  List<String> unwantedChars = [
    '０',
    '〇'
  ];

  final matches = db.select('''
    SELECT ja.jaID, en.enID, ja.pri as ja_pri, ja.value as ja_value, ja.reading as ja_reading, en.value as en_value, ja.freqGroup as freq_group
    FROM JA_TERMS ja
    JOIN EN_TERMS en
    ON ja.enID = en.enID
    WHERE ja.value IN ('${unwantedChars.join("', '")}')
  ''');

  for (Row row in matches) {
    final int count = matches.where((e) => e["enID"] == row["enID"]).length;
    final int dbCount = db.select(''' SELECT COUNT(*) as count FROM JA_TERMS WHERE enID = ${row["enID"]} ''')[0]["count"];
    if (count == dbCount) {
      db.execute('''
        DELETE FROM EN_TERMS WHERE enID = ${row["enID"]}
      ''');
    }
  }

  for (Row row in matches) {
    db.execute('''
      DELETE FROM JA_TERMS WHERE jaID = ${row["jaID"]}
    ''');
  }
}

ResultSet findDupes(Database db) {
  return db.select('''
    SELECT ja.pri as ja_pri, ja.value as ja_value, ja.reading as ja_reading, COUNT(*) AS count
    FROM JA_TERMS ja
    GROUP BY ja.value
    HAVING COUNT(*) > 1
  ''');
}

void initTables(Database db) {
  db.execute('''
    CREATE TABLE EN_TERMS(
      enID INTEGER PRIMARY KEY,
      value TEXT)
  ''');

  db.execute('''
    CREATE TABLE JA_TERMS(
      jaID INTEGER PRIMARY KEY,
      value TEXT,
      reading TEXT,
      pri INTEGER,
      freqGroup INTEGER,
      enID INTEGER,
      FOREIGN KEY (enID) REFERENCES EN_TERMS(enID) ON DELETE CASCADE)
  ''');
}

void truncate(Database db) {
  db.execute('''
    DELETE FROM EN_TERMS;
    DELETE FROM JA_TERMS;
  ''');
}

void jimmyDropTables(Database db) {
  db.execute('''
    DROP TABLE EN_TERMS;
    DROP TABLE JA_TERMS;
  ''');
}