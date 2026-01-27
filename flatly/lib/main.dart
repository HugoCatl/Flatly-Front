import 'package:flutter/material.dart';
import 'app_shell.dart';
import 'core/theme/app_colors.dart';

void main() {
  runApp(const FlatlyApp());
}

class FlatlyApp extends StatelessWidget {
  const FlatlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flatly',
      theme: ThemeData(
        useMaterial3: true,

        // Fondo general de la app
        scaffoldBackgroundColor: AppColors.background,

        // Esquema de color base (indigo/violeta)
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.indigo,
          brightness: Brightness.light,
        ),

        // AppBar por defecto
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          centerTitle: true,
        ),

        // Cards
        cardTheme: const CardThemeData(
          color: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
        ),

        // Texto
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
          bodyMedium: TextStyle(color: AppColors.textSecondary),
        ),
      ),

      // Shell principal (navegación)
      home: const AppShell(),
    );
  }
}
