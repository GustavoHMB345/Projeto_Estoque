import 'package:flutter/foundation.dart';

class AuthModel extends ChangeNotifier {
  bool _isAuthenticated = false;
  String _username = '';
  String _password = '';

  bool get isAuthenticated => _isAuthenticated;

  void login(String username, String password) {
    if (username == 'user' && password == 'password') {
      _isAuthenticated = true;
      notifyListeners();
    } else {
      _isAuthenticated = false; //
      notifyListeners();
    }
  }

  void logout() {
    _isAuthenticated = false;
    _username = '';
    _password = '';
    notifyListeners();
  }
}
