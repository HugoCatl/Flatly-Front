import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // 1. Nueva importación
import 'firebase_options.dart'; // 2. Las llaves de tu compañero
import 'app_shell.dart';
import 'core/theme/app_colors.dart';
import 'core/services/firebase_auth_service.dart'; // 3. Tu nuevo servicio
import 'features/auth/pages/login_page.dart';

// 4. Convertimos el main en asíncrono para arrancar Firebase
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializamos Firebase con las opciones de tu compañero
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

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
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.indigo,
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          centerTitle: true,
        ),
        cardTheme: const CardThemeData(
          color: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
          bodyMedium: TextStyle(color: AppColors.textSecondary),
        ),
      ),
      // Mantenemos el AuthWrapper como puerta de entrada
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // 5. Usamos StreamBuilder en lugar de FutureBuilder.
    // Esto permite que la app reaccione al instante cuando el usuario loguea/desloguea.
    return StreamBuilder(
      stream: FirebaseAuthService().userStream, // Escuchamos a Firebase
      builder: (context, snapshot) {
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
                  CircularProgressIndicator(color: Color(0xFF4F46E5)),
                ],
              ),
            ),
          );
        }

        // Si snapshot tiene datos, significa que Firebase tiene un usuario activo
        if (snapshot.hasData) {
          return const AppShell();
        }

        // Si no hay datos, mostramos el login
        return const LoginPage();
      },
    );
  }
}
