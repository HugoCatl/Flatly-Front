import 'package:flutter/material.dart';
import '../models/saldos_model.dart';

class SaldoCard extends StatelessWidget {
  final SaldoUsuario usuario;

  const SaldoCard({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    // Lógica de colores visual
    Color colorMonto;
    String textoEstado;
    IconData iconoEstado;

    if (usuario.monto == 0) {
      colorMonto = Colors.grey;
      textoEstado = "Al día";
      iconoEstado = Icons.check_circle_outline;
    } else if (usuario.soyDeudor) {
      colorMonto = Colors.redAccent;
      textoEstado = "Debes pagar";
      iconoEstado = Icons.arrow_outward;
    } else {
      colorMonto = Colors.green;
      textoEstado = "Te deben";
      iconoEstado = Icons.arrow_back;
    }

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(usuario.avatarUrl),
              onBackgroundImageError: (_, __) => const Icon(Icons.person),
            ),
            const SizedBox(width: 15),

            // Nombre y Estado
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    usuario.nombre,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: usuario.esCurrentUser
                          ? Colors.indigo
                          : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(iconoEstado, size: 14, color: colorMonto),
                      const SizedBox(width: 4),
                      Text(
                        textoEstado,
                        style: TextStyle(
                          color: colorMonto,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // El Dinero
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: colorMonto.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: colorMonto.withOpacity(0.3)),
              ),
              child: Text(
                "${usuario.monto.toStringAsFixed(2)} €",
                style: TextStyle(
                  color: colorMonto,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
