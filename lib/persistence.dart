import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'classes/term_entry.dart';

class WordsDatabaseHelper {
  WordsDatabaseHelper._privateConstructor();
  static final WordsDatabaseHelper instance = WordsDatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    String mydbDirectory = join(await getDatabasesPath(), "userWords.db");
    return await openDatabase(
      mydbDirectory,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    // kanji can be null.
    // romaji not included, generated from reading.
    await db.execute('''
      CREATE TABLE userWords(
        id INTEGER PRIMARY KEY, 
        en_term TEXT, 
        kanji TEXT, 
        reading TEXT)
    ''');
    //date INTEGER, (not using yet)
  }

  Future<List<TermEntry>> getTerms({String? orderBy}) async {
    Database db = await instance.database;
    var terms = await db.query('userWords', orderBy: orderBy);

    List<TermEntry> termList = terms.isNotEmpty
        ? terms.map((t) => TermEntry.fromMap(t)).toList()
        : [];

    return termList;
  }

  Future<int> addTerm(TermEntry term) async {
    Database db = await instance.database;
    return await db.insert('userWords', term.toMap());
  }

  Future<int> deleteTerm(int termID) async {
    Database db = await instance.database;
    return await db.delete('userWords', where: 'id = ?', whereArgs: [termID]);
  }

  Future<int> truncate() async {
    Database db = await instance.database;
    return await db.delete('userWords');
  }
}