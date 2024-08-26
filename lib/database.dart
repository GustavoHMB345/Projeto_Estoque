import 'package:mysql1/mysql1.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:flutter/widgets.dart';

class Database {
  static Database? _instance;

  factory Database({required String mysqlHost}) {
    _instance ??= Database._(mysqlHost);
    return _instance!;
  }

  Database._(this._mysqlHost) : _conn = null;
  MySqlConnection? _conn;
  final String _mysqlHost;

  Future<void> _initConnection() async {
    final config = await rootBundle.loadString('assets/config.json');
    final jsonConfig = jsonDecode(config);

    _conn = await MySqlConnection.connect(
      ConnectionSettings(
        host: _mysqlHost,
        user: jsonConfig['user'],
        password: jsonConfig['password'],
        db: jsonConfig['db'],
        port: jsonConfig['port'],
      ),
    );
  }

  Future<List<Map<String, dynamic>>> buscarItens(String query) async {
    if (_conn == null) {
      await _initConnection();
    }
    final queryParam = '%$query%';
    final results = await _conn!.query('SELECT * FROM sua_tabela WHERE nome LIKE ?', [queryParam]);
    return results.map((row) {
      return row.assoc();
    }).toList();
  }
}

extension on ResultRow {
  Map<String, dynamic> assoc() {
    final map = <String, dynamic>{};
    for (var i = 0; i < fields.length; i++) {
      map[fields[i].name] = this[i];
    }
    return map;
  }
}

class MySQLDB {
  final Database _database;

  MySQLDB({required String mysqlHost}) : _database = Database(mysqlHost: mysqlHost);

  Future<List<Map<String, dynamic>>> buscarItens(String query) async {
    return await _database.buscarItens(query);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  final mysqlDB = MySQLDB(mysqlHost: '172.16.100.2');
  final results = await mysqlDB.buscarItens('query');
  print(results);
}