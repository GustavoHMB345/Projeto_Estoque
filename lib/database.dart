import 'package:mysql1/mysql1.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';


class Database {
  static final Database _instance = Database._();
  factory Database() => _instance;

  Database._();
  late MySqlConnection _conn;

  Future<void> _initConnection() async {
    final config = await rootBundle.loadString('assets/config.json');
    final jsonConfig = jsonDecode(config);
  _conn = await MySqlConnection.connect(
    host: jsonConfig['host'],
    port: jsonConfig['port'],
    user: jsonConfig['user'],
    password: jsonConfig['password'],
    db: jsonConfig['db'],
  );
} 
  Future<List<Map<String, dynamic>>> searchItems(String query) async {
    if (_conn == null) {
      await _initConnection();
    }
  final queryParam = '%$query%';
  final results = await _conn.query('SELECT * FROM sua_tabela WHERE nome LIKE @query', [queryParam]);
    return results.map((row) => row.fields).toList();
  }
}




