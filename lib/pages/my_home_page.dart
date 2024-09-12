import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_model.dart';
import '../providers/app_state.dart';
import 'login_page.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  final _textController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  Future<List<Map<String, dynamic>>>? _futureItens;

  @override
  Widget build(BuildContext context) {
    final appStateManager = Provider.of<AppState>(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: _buildAppBar(),
      drawer: _buildDrawer(appStateManager),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Texto'),
      leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () {
          _scaffoldKey.currentState?.openDrawer();
        },
      ),
    );
  }

  Drawer _buildDrawer(AppState appStateManager) {
    return Drawer(
      child: Column(
        children: [
          _buildDrawerHeader(appStateManager),
          _buildDrawerList(),
        ],
      ),
    );
  }

  DrawerHeader _buildDrawerHeader(AppState appStateManager) {
    return DrawerHeader(
      decoration: const BoxDecoration(
        color: Colors.brown,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            width: 80,
            height: 80,
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Icon(
                Icons.account_circle,
                size: 80,
                color: Colors.yellow,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              appStateManager.headerText,
              style: const TextStyle(
                color: Colors.yellow,
                fontSize: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerList() {
    return Consumer<AppState>(
      builder: (context, appStateManager, child) {
        return Column(
          mainAxisAlignment: appStateManager.mainAxisAlignment,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.arrow_back),
              title: const Text('Voltar'),
              onTap: () {
                Navigator.pop(context);
                appStateManager.updateHeaderText('Voltou para a tela anterior');
                appStateManager.updateMainAxisAlignment(MainAxisAlignment.spaceAround);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sair'),
              onTap: () {
                Provider.of<AuthModel>(context, listen: false).logout();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(
                      onLogin: onLogin,
                      usernameController: _usernameController,
                      passwordController: _passwordController,
                    ),
                  ),
                );
                appStateManager.updateHeaderText('Você saiu');
                appStateManager.updateMainAxisAlignment(MainAxisAlignment.spaceEvenly);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildBody() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: _textController,
            decoration: const InputDecoration(
              labelText: 'Pesquisar categoria',
              border: OutlineInputBorder(),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final categoriaEquipamento = _textController.text.trim();
              if (categoriaEquipamento.isNotEmpty) {
                setState(() {
                  _futureItens = fetchDados(categoriaEquipamento);
                });
              }
            },
            child: const Text('Buscar'),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _futureItens,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text('Erro'),
                  );
                } else if (snapshot.hasData) {
                  final itens = snapshot.data ?? [];
                  return itens.isEmpty
                      ? const Center(child: Text('Nenhuma categoria encontrada'))
                      : ListView.builder(
                          itemCount: itens.length,
                          itemBuilder: (context, index) {
                            final item = itens[index];
                            return ListTile(
                              title: Text(item['nomeCategoria'] ?? 'Sem Nome'),
                              subtitle: Text('Quantidade: ${item['quantidadeCategoria'] ?? 'N/A'}'),
                            );
                          },
                        );
                } else {
                  return const Center(
                    child: Text('Nenhum dado encontrado'),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void onLogin(BuildContext context, AuthModel authModel) {
    final username = _usernameController.text;
    final password = _passwordController.text;
    authModel.login(username, password);

    if (authModel.isAuthenticated) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login falhou'),
        ),
      );
    }
  }
}

Future<List<Map<String, dynamic>>> fetchDados(String pesquisa) async {
  final url = 'http://192.168.2.55:80/estoque/categorias';
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
