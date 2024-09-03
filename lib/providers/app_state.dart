import 'package:flutter/material.dart';

class AppState with ChangeNotifier {
  String _headerText = 'Cabeçalho do Drawer';
  MainAxisAlignment _mainAxisAlignment = MainAxisAlignment.spaceBetween;

  String get headerText => _headerText;
  MainAxisAlignment get mainAxisAlignment => _mainAxisAlignment;

  void updateHeaderText(String newText) {
    _headerText = newText;
    notifyListeners();
  }

  void updateMainAxisAlignment(MainAxisAlignment newMainAxisAlignment) {
    _mainAxisAlignment = newMainAxisAlignment;
    notifyListeners();
  }
}