// lib/features/auth/models/auth_response.dart
import 'user_model.dart';

class AuthResponse {
  final bool success;
  final String message;
  final UserModel? user;

  AuthResponse({
    required this.success,
    required this.message,
    this.user,
  });

  // Constructor para respuestas exitosas
  factory AuthResponse.success(String message, UserModel user) {
    return AuthResponse(
      success: true,
      message: message,
      user: user,
    );
  }

  // Constructor para respuestas de error
  factory AuthResponse.error(String message) {
    return AuthResponse(
      success: false,
      message: message,
    );
  }
}
