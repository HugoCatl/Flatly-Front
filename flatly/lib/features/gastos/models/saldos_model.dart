class SaldoUsuario {
  final String id;
  final String nombre;
  final String avatarUrl;
  final double monto; // La cantidad de dinero
  final bool soyDeudor; // true = Yo le debo a él | false = Él me debe a mí
  final bool esCurrentUser; // Para saber si soy "Yo" (opcional)

  SaldoUsuario({
    required this.id,
    required this.nombre,
    required this.avatarUrl,
    required this.monto,
    required this.soyDeudor,
    this.esCurrentUser = false,
  });
}
