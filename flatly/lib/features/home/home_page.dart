import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gradients.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // MOCK (luego vendrá de API/estado)
    const nombre = 'Hugo';
    const diasProximoPago = 6;
    const totalGastado = 482.35;
    const presupuesto = 800.00;
    const cambioPct = -8.2; // negativo = bajó gasto (verde), positivo = subió (rojo)

    final progreso = (totalGastado / presupuesto).clamp(0.0, 1.0);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        _HeaderCard(
          nombre: nombre,
          diasProximoPago: diasProximoPago,
        ),
        const SizedBox(height: 16),

        _ResumenMesCard(
          totalGastado: totalGastado,
          presupuesto: presupuesto,
          progreso: progreso,
          cambioPct: cambioPct,
        ),
        const SizedBox(height: 16),

        const Text(
          'Acciones rápidas',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: _QuickActionButton(
                title: 'Buscar piso',
                subtitle: 'Explora cerca de ti',
                gradient: AppGradients.search,
                icon: Icons.search_rounded,
                onTap: () {
                  // TODO: cambiar a tab 0 (mapa) o navegar a búsqueda
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _QuickActionButton(
                title: 'Añadir gasto',
                subtitle: 'Registra en 10s',
                gradient: AppGradients.addExpense,
                icon: Icons.credit_card_rounded,
                onTap: () {
                  // TODO: abrir modal añadir gasto
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _HeaderCard extends StatelessWidget {
  final String nombre;
  final int diasProximoPago;

  const _HeaderCard({
    required this.nombre,
    required this.diasProximoPago,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      decoration: BoxDecoration(
        gradient: AppGradients.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hola, $nombre 👋',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: Colors.white.withOpacity(0.25)),
            ),
            child: Text(
              'Próximo pago en $diasProximoPago días',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ResumenMesCard extends StatelessWidget {
  final double totalGastado;
  final double presupuesto;
  final double progreso; // 0..1
  final double cambioPct;

  const _ResumenMesCard({
    required this.totalGastado,
    required this.presupuesto,
    required this.progreso,
    required this.cambioPct,
  });

  @override
  Widget build(BuildContext context) {
    final tendenciaColor = cambioPct <= 0 ? AppColors.green : AppColors.red;
    final tendenciaIcon = cambioPct <= 0 ? Icons.trending_down : Icons.trending_up;
    final tendenciaText = '${cambioPct.abs().toStringAsFixed(1)}%';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Resumen del mes',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _GradientText(
                    '€${totalGastado.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1,
                    ),
                    gradient: AppGradients.primary,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: tendenciaColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: tendenciaColor.withOpacity(0.25)),
                  ),
                  child: Row(
                    children: [
                      Icon(tendenciaIcon, size: 18, color: tendenciaColor),
                      const SizedBox(width: 6),
                      Text(
                        tendenciaText,
                        style: TextStyle(
                          color: tendenciaColor,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: progreso,
                minHeight: 10,
                backgroundColor: AppColors.borderSoft,
                valueColor: const AlwaysStoppedAnimation(AppColors.indigo),
              ),
            ),

            const SizedBox(height: 10),

            Text(
              '${(progreso * 100).toStringAsFixed(0)}% · Límite €${presupuesto.toStringAsFixed(0)}',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final LinearGradient gradient;
  final IconData icon;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.18),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white.withOpacity(0.25)),
              ),
              child: Icon(icon, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GradientText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final LinearGradient gradient;

  const _GradientText(
    this.text, {
    required this.style,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(text, style: style.copyWith(color: Colors.white)),
    );
  }
}
