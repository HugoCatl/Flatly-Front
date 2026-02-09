import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Asegúrate de que este archivo tiene las claves nuevas
import 'app_shell.dart';
import 'core/theme/app_colors.dart';
import 'core/services/firebase_auth_service.dart';
import 'features/auth/pages/login_page.dart';

void main() async {
  // Aseguramos que el motor gráfico de Flutter esté listo antes de llamar a Firebase
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Intentamos conectar con Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("✅ Firebase inicializado correctamente");
  } catch (e) {
    // Si falla, lo imprimimos en consola pero dejamos que la app arranque
    print("⚠️ ERROR FATAL: No se pudo inicializar Firebase: $e");
  }

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
      // El AuthWrapper decide si mostrar Login o la App principal
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuthService().userStream, // Escuchamos cambios de sesión en tiempo real
      builder: (context, snapshot) {
        
        // 1. Estado de carga inicial (mientras Firebase comprueba si hay token guardado)
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

        // 2. Si snapshot tiene datos, el usuario está logueado -> Vamos a AppShell
        if (snapshot.hasData) {
          return const AppShell();
        }

        // 3. Si no hay datos (null), el usuario no está logueado -> Vamos a LoginPage
        return const LoginPage();
      },
    );
  }
}