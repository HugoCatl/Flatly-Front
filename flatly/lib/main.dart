import 'package:flutter/material.dart';
import 'app_shell.dart';
import 'core/theme/app_colors.dart';
import 'core/services/auth_service.dart';
import 'features/auth/pages/login_page.dart';

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

      // Verificar sesión antes de decidir qué mostrar
      home: const AuthWrapper(),
    );
  }
}

/// Widget que verifica si el usuario está logueado
/// y muestra la pantalla correspondiente
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: AuthService.isLoggedIn(),
      builder: (context, snapshot) {
        // Mientras carga, muestra un splash screen
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'flatly',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4F46E5),
                      letterSpacing: -1,
                    ),
                  ),
                  SizedBox(height: 24),
                  CircularProgressIndicator(
                    color: Color(0xFF4F46E5),
                  ),
                ],
              ),
            ),
          );
        }

        // Si hay sesión activa, muestra el app shell
        if (snapshot.data == true) {
          return const AppShell();
        }

        // Si no hay sesión, muestra el login
        return const LoginPage();
      },
    );
  }
}