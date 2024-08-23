import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_model.dart';

class AuthPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<AuthModel>(
            builder: (context, authModel, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _buildTextInput(_usernameController, 'Username', false),
                  const SizedBox(height: 16.0),
                  _buildTextInput(_passwordController, 'Password', true),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _handleLogin(context, authModel),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                    ), child: null,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTextInput(TextEditingController controller, String label, bool obscureText) {
    return Container(
      height: 60.0,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.0),
        border: Border.all(color: Colors.brown, width: 2.0),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
          labelStyle: const TextStyle(color: Colors.brown),
          contentPadding: const EdgeInsets.all(8.0),
        ),
        obscureText: obscureText,
        style: const TextStyle(color: Colors.black),
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