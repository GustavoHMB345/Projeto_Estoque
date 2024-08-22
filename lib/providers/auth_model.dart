import 'package:flutter/foundation.dart';
import '../sqflite/database_helper.dart';
import '../sqflite/user.dart';

class AuthModel with ChangeNotifier {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  bool _isAuthenticated = false;

  Future<void> login(String username, String password) async {
    final user = await _databaseHelper.getUserByUsernameAndPassword(username, password);
    if (user != null) {
      _isAuthenticated = true;
      notifyListeners();
    }
  }

  Future<void> signup(User user) async {
    await _databaseHelper.insertUser(user);
    _isAuthenticated = true;
    notifyListeners();
  }

  Future<void> logout() async {
    _isAuthenticated = false;
    notifyListeners();
  }

  bool get isAuthenticated => _isAuthenticated;
}