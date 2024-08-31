import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<dynamic>> fetchDados() async {
  const url = 'http:192.168.2.63';
  final client = http.Client();

  final response = await client.get(Uri.parse(url), 
    headers: {
      'Connection': 'keep-alive',
      'Keep-Alive': 'timeout=30' 
    }
  ).timeout(const Duration(seconds: 30));

  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    final listaItens = jsonData['itens'];
    for  (var item in listaItens) {
      print(item['id']);
      print(item['nome']);
    }
    return listaItens;
  } else {
    throw Exception('Erro ao buscar dados');
  }
}

