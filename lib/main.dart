import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_model.dart';
import 'providers/app_state.dart';
import 'pages/auth_page.dart';
import 'pages/my_home_page.dart';
import 'sqflite/user.dart'; 

void main() {
  AuthModel authModel = AuthModel();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => authModel),
        ChangeNotifierProvider(create: (context) => AppState()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authModel = Provider.of<AuthModel>(context, listen: false);
    final username = 'Gus';
    final password = '1212';

    return FutureBuilder(
      future: authModel.signup(User(username: username, password: password)), 
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            title: 'Aplicação do estoque',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            initialRoute: '/',
            routes: {
              '/': (context) => Consumer<AuthModel>(
                builder: (context, authModel, child) {
                  if (authModel.isAuthenticated) {
                    return const MyHomePage();
                  } else {
                    return AuthPage();
                  }
                },
              ),
              '/home': (context) => const MyHomePage(),
              '/login': (context) => AuthPage(),
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}