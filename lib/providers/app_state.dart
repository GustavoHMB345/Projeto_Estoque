import 'package:flutter/material.dart';

class AppState extends ChangeNotifier{
  String _headerText = 'Cabeçalho do Drawer';

  String get headerText => _headerText;

  void updateHeaderText(String newText) {
    _headerText = newText;
    notifyListeners();
  }
}