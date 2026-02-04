// lib/features/auth/models/user_model.dart

class UserModel {
  final String name;
  final String email;

  UserModel({
    required this.name,
    required this.email,
  });

  // Crear UserModel desde datos locales
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      email: json['email'],
    );
  }

  // Convertir UserModel a JSON (para guardar localmente)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
    };
  }
  
  String get initials {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, 1).toUpperCase();
  }
}
