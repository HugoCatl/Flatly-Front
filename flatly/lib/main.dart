import 'package:flutter/material.dart';
import 'app_shell.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flatly',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const AppShell(),
    );
  }
}
