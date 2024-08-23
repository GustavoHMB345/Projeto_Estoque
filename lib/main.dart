import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_model.dart';
import 'pages/auth_page.dart';
import 'pages/my_home_page.dart';
import 'providers/app_state.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthModel(navigatorKey)),
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
        '/': (context) => Consumer<AuthModel>(
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
        ),
        '/home': (context) => const MyHomePage(),
        '/login': (context) => Consumer<AuthModel>(
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
        ),
      },
    );
  }
}