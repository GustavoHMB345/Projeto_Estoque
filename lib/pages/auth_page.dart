import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_model.dart'; 

class AuthPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<AuthModel>(
          builder: (context, authModel, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(labelText: 'Username'),
                ),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    String username = _usernameController.text;
                    String password = _passwordController.text;
                    Provider.of<AuthModel>(context, listen: false)
                        .login(username, password);
                  },
                  child: Text('Login'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
