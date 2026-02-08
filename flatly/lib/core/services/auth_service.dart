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

      _saveCookies(response);

      if (response.statusCode == 201 || response.statusCode == 200) {
        final user = UserModel(name: name, email: email);
        await StorageService.saveUserData(user.toJson());
        return AuthResponse.success(response.body, user);
      } else if (response.statusCode == 409) {
        return AuthResponse.error(
          'El usuario ya existe o los datos son inválidos',
        );
      } else {
        return AuthResponse.error('Error en el registro: ${response.body}');
      }
    } on SocketException {
      return AuthResponse.error(
        'No se pudo conectar al servidor. Verifica tu conexión.',
      );
    } catch (e) {
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
            body: json.encode({'email': email, 'password': password}),
          )
          .timeout(ApiConfig.timeout);

      _saveCookies(response);

      if (response.statusCode == 200) {
        String name = _extractNameFromMessage(response.body);
        final user = UserModel(name: name, email: email);
        await StorageService.saveUserData(user.toJson());
        return AuthResponse.success(response.body, user);
      } else if (response.statusCode == 401) {
        return AuthResponse.error('Credenciales incorrectas');
      } else {
        return AuthResponse.error('Error en el login: ${response.body}');
      }
    } on SocketException {
      return AuthResponse.error('No se pudo conectar al servidor.');
    } catch (e) {
      return AuthResponse.error('Error de conexión: $e');
    }
  }

  // ==================== LOGOUT ====================
  static Future<bool> logout() async {
    try {
      // Cambiado a POST según el nuevo documento del backend
      await _client
          .post(
            Uri.parse('${ApiConfig.baseUrl}${ApiConfig.logout}'),
            headers: _getHeadersWithCookies(),
          )
          .timeout(ApiConfig.timeout);

      _sessionCookie = null;
      await StorageService.clearAll();
      return true;
    } catch (e) {
      _sessionCookie = null;
      await StorageService.clearAll();
      return true;
    }
  }

  // ==================== OBTENER INFORMACIÓN DEL USUARIO (PERFIL) ====================
  // Ya no necesita userId, usa la ruta /users/me
  static Future<UserModel?> getUserInformation() async {
    try {
      final response = await _client
          .get(
            Uri.parse('${ApiConfig.baseUrl}${ApiConfig.userMe}'),
            headers: _getHeadersWithCookies(),
          )
          .timeout(ApiConfig.timeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return UserModel.fromJson(data);
      }
      return null;
    } catch (e) {
      print('Error obteniendo información: $e');
      return null;
    }
  }

  // ==================== ACTUALIZAR INFORMACIÓN DEL USUARIO ====================
  static Future<bool> updateUserInformation({
    required String name,
    String? phone,
    String? avatarUrl,
  }) async {
    try {
      // Ajustado a los nombres de campos del PDF: name, phone, avatarUrl
      final body = {
        'name': name,
        'phone': phone ?? '',
        'avatarUrl': avatarUrl ?? '',
      };

      final response = await _client
          .put(
            Uri.parse('${ApiConfig.baseUrl}${ApiConfig.userMe}'),
            headers: _getHeadersWithCookies(),
            body: json.encode(body),
          )
          .timeout(ApiConfig.timeout);

      if (response.statusCode == 200) {
        final currentUser = await getCurrentUser();
        if (currentUser != null) {
          final updatedUser = currentUser.copyWith(
            name: name,
            phone: phone,
            avatarUrl: avatarUrl,
          );
          await StorageService.saveUserData(updatedUser.toJson());
        }
        return true;
      }
      return false;
    } catch (e) {
      print('Error actualizando usuario: $e');
      return false;
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

  static Future<bool> isLoggedIn() async {
    return await StorageService.isLoggedIn();
  }

  // ==================== HELPERS PRIVADOS ====================

  static void _saveCookies(http.Response response) {
    final rawCookie = response.headers['set-cookie'];
    if (rawCookie != null) {
      _sessionCookie = rawCookie.split(';')[0];
    }
  }

  static Map<String, String> _getHeadersWithCookies() {
    final headers = Map<String, String>.from(ApiConfig.headers);
    if (_sessionCookie != null) {
      headers['Cookie'] = _sessionCookie!;
    }
    return headers;
  }

  static String _extractNameFromMessage(String message) {
    try {
      if (message.contains('Bienvenido ')) {
        return message.split('Bienvenido ')[1].trim();
      } else if (message.contains('Bienvenida ')) {
        return message.split('Bienvenida ')[1].trim();
      }
    } catch (e) {}
    return 'Usuario';
  }

  static Future<http.Response> authenticatedGet(String endpoint) async {
    return await _client
        .get(
          Uri.parse('${ApiConfig.baseUrl}$endpoint'),
          headers: _getHeadersWithCookies(),
        )
        .timeout(ApiConfig.timeout);
  }

  static Future<http.Response> authenticatedPost(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    return await _client
        .post(
          Uri.parse('${ApiConfig.baseUrl}$endpoint'),
          headers: _getHeadersWithCookies(),
          body: json.encode(body),
        )
        .timeout(ApiConfig.timeout);
  }
}
