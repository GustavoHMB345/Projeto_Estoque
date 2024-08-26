import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_model.dart' as auth_model;
import 'pages/auth_page.dart';
import 'pages/my_home_page.dart';
import 'providers/app_state.dart';
import 'database.dart'; 

final navigatorKey = GlobalKey<NavigatorState>();

void main() {
 mysqlDb();

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

final mysqlDatabase = Database(mysqlHost: '172.16.100.2');

Future<void> mysqlDb() async {
  final results = await mysqlDatabase.buscarItens('Query');
  print(results);
}