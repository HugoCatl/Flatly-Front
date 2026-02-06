// lib/core/config/api_config.dart

class ApiConfig {
  // URL base de tu backend Ktor
  static const String baseUrl = 'http://26.173.14.24:8080';
  
  // Endpoints
  static const String register = '/users/auth/register';
  static const String login = '/users/auth/login';
  static const String logout = '/users/auth/logout';
  static const String listUsers = '/users';
  
  // Nuevas rutas de usuario
  static String userInformation(int id) => '/users/information/$id';
  static const String updateUserInfo = '/users/actualizeInfo';
  
  // Headers básicos
  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  // Timeouts
  static const Duration timeout = Duration(seconds: 30);
}