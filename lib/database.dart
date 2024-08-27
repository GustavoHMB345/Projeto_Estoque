import 'package:mysql1/mysql1.dart';

class Database {
  static const _host = '172.16.100.2';
  static const _database = 'dbbrightinventorydesenvolvedor';

  static Future<MySqlConnection> _getConnection() async {
    return await MySqlConnection.connect(
      host: _host,
      db: _database,
    );
  }

  static Future<List<Map<String, dynamic>>> buscarItens() async {
    final conn = await _getConnection();
    final results = await conn.query('SELECT * FROM categoriaEquipamento');
    await conn.close();
    return results.map((row) => row.fields).toList();
  }

  static Future<List<Map<String, dynamic>>> fetchData() async {
    final conn = await _getConnection();
    final results = await conn.query('SELECT * FROM categoriaEquipamento');
    await conn.close();
    return results.map((row) => row.fields).toList();
  }
}