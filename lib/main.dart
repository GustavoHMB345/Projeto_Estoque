import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_model.dart';
import 'providers/app_state.dart';
import 'pages/auth_page.dart'; 
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
  }
}