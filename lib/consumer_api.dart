import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

final Logger _logger = Logger('AuthManager');

class AuthManager {
  static final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  static final FocusManager _focusManager = FocusManager.instance;

  static bool get isLoggedIn => _focusManager.primaryFocus != null;

  static void login() {
    _logger.info('Usuário conectado');
    _navigatorKey.currentState?.pushNamed('/home');
  }
}

Future<List<Map<String, dynamic>>> fetchDados(String pesquisa) async {
  final url = 'http://192.168.2.55:80/estoque';
  final client = http.Client();

  try {
    final response = await client.get(Uri.parse(url), headers: {
      'Connection': 'keep-alive',
      'Keep-Alive': 'timeout=30'
    }).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body) as List<dynamic>;

      final categorias = jsonData.where((item) {
        final nomeCategoria = item['nomeCategoria'] as String;
        return nomeCategoria.toLowerCase().contains(pesquisa.toLowerCase());
      }).toList().cast<Map<String, dynamic>>();

      return categorias;
    } else {
      return [];
    }
  } catch (e) {
    return [];
  } finally {
    client.close();
  }
}