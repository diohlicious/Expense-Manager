import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class InitDb {
  static final _databaseName = "ExpenseManager.db";
  static final _databaseVersion = 1;

  static final tableEx = 'expense_table';
  static final tableCat = 'category_table';

  static final columnIdEx = '_id';
  static final columnTransDate = '_transDate';
  static final columnCategory = '_category';
  static final columnAmount = '_amt';
  static final columnDescription = '_description';
  static final columnType = '_type';
  static final columnCreateDate = '_createDate';

  static final columnIdCat = '_idCategory';
  static final columnCat = '_category';

  // make this a singleton class
  InitDb._privateConstructor();

  static final InitDb instance = InitDb._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  /// Create Expense Versi 1
  void _createTableExpenseV1(Batch batch) {
    batch.execute('DROP TABLE IF EXISTS $tableEx');
    batch.execute('''
          CREATE TABLE $tableEx (
            $columnIdEx INTEGER PRIMARY KEY,
            $columnTransDate TEXT NOT NULL,
            $columnCategory TEXT NOT NULL,
            $columnAmount INTEGER NOT NULL,
            $columnDescription TEXT NOT NULL,
            $columnType TEXT NOT NULL,
            $columnCreateDate TEXT NOT NULL
          )
          ''');
  }

  /// Create Category Versi 1
  void _createTableCategoryV1(Batch batch) {
    batch.execute('DROP TABLE IF EXISTS $tableCat');
    batch.execute('''CREATE TABLE $tableCat (
            $columnIdCat INTEGER PRIMARY KEY,
            $columnCat TEXT NOT NULL
          )
          ''');
  }

  Future _onCreate(Database db, int version) async {
    var batch = db.batch();
    // We create all the tables
    _createTableExpenseV1(batch);
    _createTableCategoryV1(batch);
    await batch.commit();
  }

  Future<List<Map<String, dynamic>>> initdb() async {
    Database db = await instance.database;
    return await db.query('sqlite_master', columns: ['type', 'name']);
  }

/*tableNames = (await db
      .query('sqlite_master', where: 'type = ?', whereArgs: ['table'])  )
      .map((row) => row['name'] as String)
      .toList(growable: false);*/

// Helper methods
}
