// lib/core/services/storage_service.dart
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class StorageService {
  static const String _userKey = 'user_data';
  static const String _isLoggedInKey = 'is_logged_in';
  
  // Guardar datos del usuario localmente
  static Future<bool> saveUserData(Map<String, dynamic> userData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userKey, json.encode(userData));
      await prefs.setBool(_isLoggedInKey, true);
      return true;
    } catch (e) {
      print('Error guardando datos de usuario: $e');
      return false;
    }
  }
  
  // Obtener datos del usuario
  static Future<Map<String, dynamic>?> getUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userStr = prefs.getString(_userKey);
      if (userStr != null) {
        return json.decode(userStr) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      print('Error obteniendo datos de usuario: $e');
      return null;
    }
  }
  
  // Verificar si el usuario está logueado
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }
  
  // Cerrar sesión (borrar todo)
  static Future<bool> clearAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userKey);
      await prefs.remove(_isLoggedInKey);
      return true;
    } catch (e) {
      print('Error limpiando datos: $e');
      return false;
    }
  }
}
