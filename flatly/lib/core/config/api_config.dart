// lib/core/config/api_config.dart

class ApiConfig {
  // URL base de tu backend Ktor
  static const String baseUrl = 'http://26.173.14.24:8080';

  // --- MÓDULO: USUARIOS Y AUTH ---
  static const String register = '/users/auth/register';
  static const String login = '/users/auth/login';
  static const String loginFirebase = '/users/auth/firebase';
  static const String logout = '/users/logout';

  // --- MÓDULO: MI PERFIL (/users/me) ---
  static const String userMe =
      '/users/me'; // GET (ver), PUT (editar), DELETE (eliminar)
  static const String myFavorites = '/users/me/favorites';
  // Para quitar de favoritos: /users/me/favorites/123
  static String favoriteProperty(int propertyId) =>
      '/users/me/favorites/$propertyId';

  // --- MÓDULO: ESTUDIANTES (Students) ---
  static const String studentJoinHousehold = '/students/households/join';
  static const String studentHouseholdMe =
      '/students/households/me'; // GET y DELETE (abandonar)
  static const String studentExpenses = '/students/expenses';
  // Historial filtrado: /students/expenses/history?year=2026&month=2
  static String studentExpensesHistory(int year, int month) =>
      '/students/expenses?year=$year&month=$month';

  // --- MÓDULO: PROPIETARIOS (Owners) ---
  static const String ownerProperties =
      '/owners/properties'; // POST (crear) y GET (listar)
  static String ownerPropertyId(int propertyId) =>
      '/owners/properties/$propertyId'; // DELETE

  static const String ownerHouseholds = '/owners/households'; // POST (crear)
  static String ownerHouseholdId(int householdId) =>
      '/owners/households/$householdId'; // GET (ver alumnos) y DELETE (eliminar)

  // --- MÓDULO: ADMINISTRACIÓN (Admin) ---
  static const String adminUsers = '/admin/users';
  static String adminUserId(int userId) =>
      '/admin/users/$userId'; // DELETE (borrar usuario)
  static String adminChangeRole(int userId) =>
      '/admin/users/$userId/role'; // PUT
  static const String adminStats = '/admin/stats';

  // --- CONFIGURACIÓN TÉCNICA ---
  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static const Duration timeout = Duration(seconds: 30);
}
