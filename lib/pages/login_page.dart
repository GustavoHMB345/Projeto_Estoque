import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_model.dart';
import './auth_page.dart';

class LoginPage extends StatelessWidget {
  final navigatorKey = GlobalKey<NavigatorState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<AuthModel>(
      create: (_) => AuthModel(navigatorKey),
      child: AuthPage(
        onLogin: (context, authModel) {
          _handleLogin(context, authModel);
        },
        usernameController: _usernameController,
        passwordController: _passwordController,
      ),
    );
  }

  void _handleLogin(BuildContext context, AuthModel authModel) {
    String username = _usernameController.text;
    String password = _passwordController.text;
    authModel.login(username, password);

    if (authModel.isAuthenticated) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login failed')),
      );
    }
  }
}