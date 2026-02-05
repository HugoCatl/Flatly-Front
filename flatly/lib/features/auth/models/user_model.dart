// lib/features/auth/models/user_model.dart

class UserModel {
  final int? id; // Puede ser null si aún no lo tenemos del backend
  final String name;
  final String email;
  final String? phone;
  final String? avatarUrl;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    this.phone,
    this.avatarUrl,
  });

  // Crear UserModel desde JSON del backend
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      avatarUrl: json['avatar_url'],
    );
  }

  // Convertir UserModel a JSON (para guardar localmente)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'avatar_url': avatarUrl,
    };
  }
  
  String get initials {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, 1).toUpperCase();
  }

  // Método para crear una copia con campos actualizados
  UserModel copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    String? avatarUrl,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}