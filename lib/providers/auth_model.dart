import 'package:flutter/material.dart';
import 'package:projeto_estoque/database.dart';

class AuthModel with ChangeNotifier {
  final GlobalKey<NavigatorState> _navigatorKey;
  bool _isAuthenticated = false;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  AuthModel(this._navigatorKey);

  bool get isAuthenticated => _isAuthenticated;
  TextEditingController get usernameController => _usernameController;
  TextEditingController get passwordController => _passwordController;

  void login(String username, String password) {
    if (username == 'adm' && password == '12') {
      _isAuthenticated = true;
      notifyListeners();
      _navigatorKey.currentState?.pushReplacementNamed('/home');
    } else {
      _isAuthenticated = false;
      notifyListeners();
    }
  }

  void logout() {
    _isAuthenticated = false;
    notifyListeners();
    _navigatorKey.currentState?.pushReplacementNamed('/login');
  }
}
  Future<List<Map<String, dynamic>>> fetchData() async {
    final data = await Database.buscarItens();
    return data;
  }
