// lib/core/services/auth_service.dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../features/auth/models/auth_response.dart';
import '../../features/auth/models/user_model.dart';
import '../config/api_config.dart';
import 'storage_service.dart';

class AuthService {
  // Cliente HTTP que mantiene las cookies
  static final http.Client _client = http.Client();
  
  // Variable para almacenar las cookies de sesión
  static String? _sessionCookie;

  // ==================== REGISTRO ====================
  static Future<AuthResponse> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client
          .post(
            Uri.parse('${ApiConfig.baseUrl}${ApiConfig.register}'),
            headers: ApiConfig.headers,
            body: json.encode({
              'name': name,
              'email': email,
              'password': password,
            }),
          )
          .timeout(ApiConfig.timeout);

      // Guardar cookies de sesión
      _saveCookies(response);

      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        // El backend devuelve un mensaje de texto como:
        // "Usuario registrado e inicio de sesión automático: Bienvenido Juan"
        
        final user = UserModel(name: name, email: email);
        
        // Guardar usuario localmente
        await StorageService.saveUserData(user.toJson());
        
        return AuthResponse.success(response.body, user);
      } else if (response.statusCode == 409) {
        // Conflict - usuario ya existe
        return AuthResponse.error('El usuario ya existe o los datos son inválidos');
      } else {
        return AuthResponse.error('Error en el registro: ${response.body}');
      }
    } on SocketException {
      return AuthResponse.error('No se pudo conectar al servidor. Verifica tu conexión.');
    } catch (e) {
      print('Error en register: $e');
      return AuthResponse.error('Error de conexión: $e');
    }
  }

  // ==================== LOGIN ====================
  static Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client
          .post(
            Uri.parse('${ApiConfig.baseUrl}${ApiConfig.login}'),
            headers: ApiConfig.headers,
            body: json.encode({
              'email': email,
              'password': password,
            }),
          )
          .timeout(ApiConfig.timeout);

      // Guardar cookies de sesión
      _saveCookies(response);

      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        // El backend devuelve un mensaje como:
        // "Login exitoso. Bienvenido Juan"
        
        // Extraer el nombre del mensaje (puedes mejorarlo)
        String name = _extractNameFromMessage(response.body);
        
        final user = UserModel(name: name, email: email);
        
        // Guardar usuario localmente
        await StorageService.saveUserData(user.toJson());
        
        return AuthResponse.success(response.body, user);
      } else if (response.statusCode == 401) {
        // Unauthorized - credenciales incorrectas
        return AuthResponse.error('Credenciales incorrectas');
      } else {
        return AuthResponse.error('Error en el login: ${response.body}');
      }
    } on SocketException {
      return AuthResponse.error('No se pudo conectar al servidor. Verifica tu conexión.');
    } catch (e) {
      print('Error en login: $e');
      return AuthResponse.error('Error de conexión: $e');
    }
  }

  // ==================== LOGOUT ====================
  static Future<bool> logout() async {
    try {
      await _client.get(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.logout}'),
        headers: _getHeadersWithCookies(),
      ).timeout(ApiConfig.timeout);

      // Limpiar cookies y datos locales
      _sessionCookie = null;
      await StorageService.clearAll();
      
      return true;
    } catch (e) {
      print('Error en logout: $e');
      // Aunque falle la petición, limpiamos local
      _sessionCookie = null;
      await StorageService.clearAll();
      return true;
    }
  }

  // ==================== OBTENER USUARIO ACTUAL ====================
  static Future<UserModel?> getCurrentUser() async {
    final userData = await StorageService.getUserData();
    if (userData != null) {
      return UserModel.fromJson(userData);
    }
    return null;
  }

  // ==================== VERIFICAR SI ESTÁ LOGUEADO ====================
  static Future<bool> isLoggedIn() async {
    return await StorageService.isLoggedIn();
  }

  // ==================== HELPERS PRIVADOS ====================
  
  // Guardar cookies de la respuesta
  static void _saveCookies(http.Response response) {
    final rawCookie = response.headers['set-cookie'];
    if (rawCookie != null) {
      _sessionCookie = rawCookie.split(';')[0]; // Solo la parte de la cookie
      print('Cookie guardada: $_sessionCookie');
    }
  }

  // Obtener headers con cookies
  static Map<String, String> _getHeadersWithCookies() {
    final headers = Map<String, String>.from(ApiConfig.headers);
    if (_sessionCookie != null) {
      headers['Cookie'] = _sessionCookie!;
    }
    return headers;
  }

  // Extraer nombre del mensaje de respuesta
  // Ejemplo: "Login exitoso. Bienvenido Juan" → "Juan"
  static String _extractNameFromMessage(String message) {
    try {
      // Buscar después de "Bienvenido " o "Bienvenida "
      if (message.contains('Bienvenido ')) {
        return message.split('Bienvenido ')[1].trim();
      } else if (message.contains('Bienvenida ')) {
        return message.split('Bienvenida ')[1].trim();
      }
    } catch (e) {
      print('No se pudo extraer el nombre del mensaje');
    }
    return 'Usuario'; // Valor por defecto
  }

  // Método para hacer peticiones autenticadas (para usar en otras partes de la app)
  static Future<http.Response> authenticatedGet(String endpoint) async {
    return await _client.get(
      Uri.parse('${ApiConfig.baseUrl}$endpoint'),
      headers: _getHeadersWithCookies(),
    ).timeout(ApiConfig.timeout);
  }

  static Future<http.Response> authenticatedPost(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    return await _client.post(
      Uri.parse('${ApiConfig.baseUrl}$endpoint'),
      headers: _getHeadersWithCookies(),
      body: json.encode(body),
    ).timeout(ApiConfig.timeout);
  }
}
