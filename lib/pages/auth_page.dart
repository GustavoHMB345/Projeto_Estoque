import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_model.dart';

class AuthPage extends StatelessWidget {
  final Function(BuildContext, AuthModel) onLogin;
  final TextEditingController usernameController;
  final TextEditingController passwordController;

  const AuthPage({
    super.key,
    required this.onLogin,
    required this.usernameController,
    required this.passwordController,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.network(
            'https://www.designi.com.br/images/preview/10532917.jpg',
            fit: BoxFit.cover,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Consumer<AuthModel>(
                builder: (context, authModel, child) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _buildTextInput(
                        controller: usernameController,
                        label: 'Username',
                        obscureText: false,
                      ),
                      const SizedBox(height: 16.0),
                      _buildTextInput(
                        controller: passwordController,
                        label: 'Password',
                        obscureText: true,
                      ),
                      const SizedBox(height: 20),
                      _buildLoginButton(
                        context: context,
                        authModel: authModel,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextInput({
    required TextEditingController controller,
    required String label,
    required bool obscureText,
  }) {
    return Container(
      height: 60.0,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
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

  Widget _buildLoginButton({
    required BuildContext context,
    required AuthModel authModel,
  }) {
    return ElevatedButton(
      onPressed: () {
        onLogin(context, authModel);

        if (authModel.isAuthenticated) {
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Usuário ou senha inválidos')),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 218, 206, 96),
        foregroundColor: Colors.brown,
        minimumSize: const Size(double.infinity, 50),
      ),
      child: const Text('Login'),
    );
  }
}
