import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_model.dart';
import 'providers/app_state.dart';
import 'pages/login_page.dart';
import 'pages/my_home_page.dart';



void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthModel()),
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
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(),
        '/login': (context) => AuthPage(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Consumer<AuthModel>(
        builder: (context, authModel, child) {
          if (authModel.isAuthenticated) {
            return MyHomePage();
          } else {
            return AuthPage();
          }
        },
      ),
    );
  }
}