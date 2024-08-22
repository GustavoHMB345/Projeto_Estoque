import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'user.dart';

class DatabaseHelper {
  static const String _databaseName = 'my_database.db';
  static const int _databaseVersion = 1;

  late Database _database;

  DatabaseHelper() {
    _init();
  }

  Future<void> _init() async {
    databaseFactory = databaseFactoryFfi;
    final path = join(await getDatabasesPath(), _databaseName);
    _database = await openDatabase(path, version: _databaseVersion, onCreate: _createDb);
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY,
            username TEXT NOT NULL,
            password TEXT NOT NULL
          )
          ''');
  }

  Future<User?> getUserByUsernameAndPassword(String username, String password) async {
    final rows = await _database.query('users', where: 'username = ? AND password = ?', whereArgs: [username, password]);
    if (rows.isNotEmpty) {
      return User.fromMap(rows.first);
    } else {
      return null;
    }
  }

  Future<void> insertUser(User user) async {
    await _database.insert('users', user.toMap());
  }
}