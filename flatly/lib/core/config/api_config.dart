// lib/core/config/api_config.dart

class ApiConfig {
  // URL base de tu backend Ktor
  static const String baseUrl = 'http://26.180.70.181:8080';
  
  // Endpoints
  static const String register = '/users/auth/register';
  static const String login = '/users/auth/login';
  static const String logout = '/users/auth/logout';
  static const String listUsers = '/users';
  
  // Headers básicos
  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  // Timeouts
  static const Duration timeout = Duration(seconds: 30);
}
