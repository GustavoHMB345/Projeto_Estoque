import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_model.dart';
import './auth_page.dart';

class LoginPage extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final Function(BuildContext, AuthModel) onLogin;

  LoginPage({
    super.key,
    required this.onLogin,
    required this.usernameController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return Provider<AuthModel>(
      create: (_) => AuthModel(navigatorKey),
      child: AuthPage(
        onLogin: onLogin,
        usernameController: usernameController,
        passwordController: passwordController,
      ),
    );
  }
}

  void handleLogin(
  BuildContext context,
  AuthModel authModel,
  TextEditingController usernameController,
  TextEditingController passwordController,
) {
  String username = usernameController.text;
  String password = passwordController.text;
  authModel.login(username, password);

  if (authModel.isAuthenticated) {
    Navigator.pushReplacementNamed(context, '/home');
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Login failed')),
    );
  }
}