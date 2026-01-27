import 'package:flutter/material.dart';
import 'features/map/map_page.dart';
import 'features/home/home_page.dart';
import 'features/chat/chat_page.dart';
import 'features/gastos/gastos_page.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 1; // Home por defecto (centro)

  final _pages = const [
    MapPage(),
    HomePage(),
    ChatPage(),
    GastosPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flatly'),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              // luego aquí abrimos ajustes o drawer
            },
          ),
        ],
      ),
      body: _pages[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.place), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: ''),
        ],
      ),
    );
  }
}
