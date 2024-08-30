import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> fetchDados() async {
  const url = 'http://192.16.100.2/';
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
    print(listaItens);

    for (var item in listaItens) {
      print(item['id']);
      print(item['nome']);
    }
  } else {
    print('Erro: ${response.statusCode}');
  }
}