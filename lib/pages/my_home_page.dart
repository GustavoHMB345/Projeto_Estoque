import 'package:flutter/material.dart';
import 'package:projeto_estoque/consumer_api.dart';
import 'package:provider/provider.dart';
import '../providers/auth_model.dart';
import '../pages/auth_page.dart';
import '../providers/app_state.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  List<dynamic> _itens = [];

  @override
  Widget build(BuildContext context) {
    final appStateManager = Provider.of<AppState>(context);
    final authenticator = Provider.of<AuthModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Texto'),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
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
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListTile(
                    leading: const Icon(Icons.arrow_back),
                    title: const Text('Voltar'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sair'),
              onTap: () {
                authenticator.logout();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AuthPage(
                      onLogin: (context, authModel) {},
                      usernameController: TextEditingController(),
                      passwordController: TextEditingController(),
                    ),
                  ),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const TextField(
              decoration: InputDecoration(
                labelText: 'Pesquisar aparato',
                border: OutlineInputBorder(),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final item = await fetchDados();
                setState(() {
                  _itens = item;
                });
              },
              child: const Text('Buscar'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _itens.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_itens[index]['nome']),
                    subtitle: Text(_itens[index]['descricao']),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}