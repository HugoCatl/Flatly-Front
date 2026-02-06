import '../models/saldos_model.dart';

class SaldosService {
  // Simulamos que pedimos los datos al backend
  Future<List<SaldoUsuario>> obtenerSaldos() async {
    // 1.5 segundos de espera falsa (loading)
    await Future.delayed(const Duration(milliseconds: 1500));

    return [
      SaldoUsuario(
        id: "1",
        nombre: "Juan (Tú)",
        avatarUrl: "https://i.pravatar.cc/150?img=12",
        monto: 0.0,
        soyDeudor: false,
        esCurrentUser: true,
      ),
      SaldoUsuario(
        id: "2",
        nombre: "Ana García",
        avatarUrl: "https://i.pravatar.cc/150?img=5",
        monto: 32.50,
        soyDeudor: true, // Rojo: Debes pagarle
      ),
      SaldoUsuario(
        id: "3",
        nombre: "Carlos Ruiz",
        avatarUrl: "https://i.pravatar.cc/150?img=3",
        monto: 15.00,
        soyDeudor: false, // Verde: Te deben
      ),
      SaldoUsuario(
        id: "4",
        nombre: "María López",
        avatarUrl: "https://i.pravatar.cc/150?img=9",
        monto: 0.0,
        soyDeudor: false, // Gris: En paz
      ),
    ];
  }
}
