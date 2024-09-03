import 'package:flutter/material.dart';
import 'package:projeto_estoque/consumer_api.dart';
import 'package:provider/provider.dart';
import '../providers/auth_model.dart';
import '../providers/app_state.dart';
import 'login_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  List<dynamic> _itens = [];
  final _textController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

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
          child: _itens.isEmpty
              ? const Center(child: Text('Nenhum item encontrado'))
              : Column(
                  children: _itens.map((item) {
                    Map<String, dynamic> itemMap = item as Map<String, dynamic>;
                    return ListTile(
                      title: Text(itemMap['nome'].toString()),
                      subtitle: Text(itemMap['descricao'].toString()),
                    );
                  }).toList(),
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
          content: Text('Login failed'),
        ),
      );
    }
  }
}