import 'package:sqflite/sqflite.dart';

class MyDatabase {
  static MyDatabase? _instance;

  factory MyDatabase() {
    _instance ??= MyDatabase._();
    return _instance!;
  }

  MyDatabase._();

  late Database _db;

  static Future<void> initDB() async {
    final myDatabase = MyDatabase();
    await myDatabase.init();
  }

  Future<void> init() async {
    _db = await openDatabase(
      'my_database.db',
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(''' 
          CREATE TABLE sua_tabela (
            id INTEGER PRIMARY KEY,
            nome TEXT
          )
          ''');
      },
    );
  }

  Future<List<Map<String, dynamic>>> buscarItens(String query) async {
    final results = await _db.query('sua_tabela', where: 'nome LIKE ?', whereArgs: ['%$query%']);
    return results;
  }
}