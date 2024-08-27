import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_model.dart' as auth_model;
import 'pages/auth_page.dart';
import 'pages/my_home_page.dart';
import 'providers/app_state.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => auth_model.AuthModel(navigatorKey)),
        ChangeNotifierProvider(create: (context) => AppState()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplicação do estoque',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      navigatorKey: navigatorKey,
      initialRoute: '/',
      routes: {
        '/': _rootRoute,
        '/home': (context) => const MyHomePage(),
        '/login': _loginRoute,
      },
    );
  }

  Widget _rootRoute(BuildContext context) {
    return Consumer<auth_model.AuthModel>(
      builder: (context, authModel, child) {
        if (authModel.isAuthenticated) {
          return const MyHomePage();
        } else {
          return AuthPage(
            onLogin: (context, authModel) {
              authModel.login(
                authModel.usernameController.text,
                authModel.passwordController.text,
              );
            },
            usernameController: authModel.usernameController,
            passwordController: authModel.passwordController,
          );
        }
      },
    );
  }

  Widget _loginRoute(BuildContext context) {
    return Consumer<auth_model.AuthModel>(
      builder: (context, authModel, child) {
        return AuthPage(
          onLogin: (context, authModel) {
            authModel.login(
              authModel.usernameController.text,
              authModel.passwordController.text,
            );
          },
          usernameController: authModel.usernameController,
          passwordController: authModel.passwordController,
        );
      },
    );
  }
}

class MyDatabase {
  static MyDatabase? _instance;

  factory MyDatabase() {
    _instance ??= MyDatabase._();
    return _instance!;
  }

  MyDatabase._();

  late Database _db;
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return; // already initialized
    try {
      final directory = await getApplicationDocumentsDirectory();
      final path = directory.path;
      _db = await openDatabase(
        '$path/database: dbbrightinventorydesenvolvedor',
        onCreate: (Database db, int version) async {
          await db.execute(''' 
            CREATE TABLE sua_tabela (
              id INTEGER PRIMARY KEY,
              nome TEXT
            )
            ''');
        },
        version: 1,
      );
      _initialized = true;
    } catch (e) {
      print('Error initializing database: $e');
    }
  }

  Future<List<Map<String, dynamic>>> buscarItens(String query) async {
    if (!_initialized) {
      throw Exception('Database not initialized');
    }
    final results = await _db.query('sua_tabela', where: 'nome LIKE ?', whereArgs: ['%$query%']);
    return results;
  }
}

final mysqlDatabase = MyDatabase();

Future<void> MySQLDB() async {
  await mysqlDatabase.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => auth_model.AuthModel(navigatorKey)),
        ChangeNotifierProvider(create: (context) => AppState()),
      ],
      child: MyApp(),
    ),
  );
}