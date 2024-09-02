import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';


class AuthManager {
  static final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  static final FocusManager _focusManager = FocusManager.instance;

  static bool get isLoggedIn => _focusManager.primaryFocus != null;

  static void login() {
    _navigatorKey.currentState?.pushNamed('/home');
  }
}

Future<List<dynamic>> fetchDados() async {
  const url = 'http://192.168.2.55:80';
  final client = http.Client();

  try {
    final response = await client.get(Uri.parse(url),
      headers: {
        'Connection': 'keep-alive',
        'Keep-Alive': 'timeout=30'
      }
    ).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final listaItens = jsonData['itens'];
      if (AuthManager.isLoggedIn) {
        for (var item in listaItens) {
          print(item['id']);
          print(item['nome']);
        }
      } else {
        print('Você precisa estar logado para visualizar esses dados');
      }
      return listaItens;
    } else {
      throw Exception('Erro ao buscar dados');
    }
  } catch (e) {
    print('Error: $e');
    if (e is http.Response) {
      print('Status Code: ${e.statusCode}');
      print('Reason Phrase: ${e.reasonPhrase}');
    }
      throw Exception('Erro ao buscar dados');
  }
}