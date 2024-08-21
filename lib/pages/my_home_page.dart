import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_model.dart'; 
import '../pages/auth_page.dart';
import '../providers/app_state.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final authModel = Provider.of<AuthModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Texto'),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.brown,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
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
                  SizedBox(width: 16), 
                  Expanded( 
                    child: Text(
                      appState.headerText,
                      style: TextStyle(
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
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.arrow_back),
                    title: Text('Voltar'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Sair'),
              onTap: () {
                authModel.logout();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => AuthPage()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            appState.updateHeaderText('Estoque Bright Bee');
          },
          child: Text('Atualizar Cabeçalho'),
        ),
      ),
    );
  }
}
