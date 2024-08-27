import 'package:flutter/material.dart';
import 'web_entrypoint.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: FutureBuilder(
            future: MyDatabase.initDB(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text('Connected to database');
              } else {
                return Text('Failed to connect to database');
              }
            },
          ),
        ),
      ),
    );
  }
}


class MySQLDB {
  final MyDatabase _database;

  MySQLDB({required MyDatabase database}) : _database = database;

  Future<List<Map<String, dynamic>>> buscarItens(String query) async {
    return await _database.buscarItens(query);
  }
}