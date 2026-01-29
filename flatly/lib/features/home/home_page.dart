import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gradients.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // MOCK (luego API)
    const nombre = 'Hugo';
    const diasProximoPago = 6;

    const totalGastado = 482.35;
    const presupuesto = 800.00;
    const cambioPct = -8.2;

    final progreso = (totalGastado / presupuesto).clamp(0.0, 1.0);

    final pendientes = <_PendingBill>[
      _PendingBill(type: 'RENT', amount: 450.00, dueDate: DateTime(2026, 2, 1)),
      _PendingBill(type: 'ELECTRICITY', amount: 60.25, dueDate: DateTime(2026, 1, 30)),
    ];

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        _HeaderCard(nombre: nombre, diasProximoPago: diasProximoPago),
        const SizedBox(height: 16),

        _ResumenMesCard(
          totalGastado: totalGastado,
          presupuesto: presupuesto,
          progreso: progreso,
          cambioPct: cambioPct,
        ),
        const SizedBox(height: 16),

        _SectionTitle('Pagos pendientes'),
        const SizedBox(height: 12),
        _PendingBillsCard(items: pendientes),
        const SizedBox(height: 16),

        _SectionTitle('Acciones rápidas'),
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
                  // TODO: cambiar a tab 0 (mapa)
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
                  // TODO: modal añadir gasto
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/* ----------------- UI ----------------- */

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
                        '${cambioPct.abs().toStringAsFixed(1)}%',
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

class _PendingBillsCard extends StatelessWidget {
  final List<_PendingBill> items;
  const _PendingBillsCard({required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: const [
              Icon(Icons.check_circle_rounded, color: AppColors.green),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'No tienes pagos pendientes 🎉',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            for (int i = 0; i < items.length; i++) ...[
              _PendingBillRow(item: items[i]),
              if (i != items.length - 1) const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }
}

class _PendingBillRow extends StatelessWidget {
  final _PendingBill item;
  const _PendingBillRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final icon = _billIcon(item.type);
    final label = _billLabel(item.type);
    final due = _formatDate(item.dueDate);

    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.amber.withOpacity(0.12),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.amber.withOpacity(0.25)),
          ),
          child: Icon(icon, color: AppColors.amber),
        ),
        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Vence: $due',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),

        Text(
          '€${item.amount.toStringAsFixed(2)}',
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            color: AppColors.textPrimary,
          ),
        ),
      ],
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

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
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
      shaderCallback: (bounds) =>
          gradient.createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
      child: Text(text, style: style.copyWith(color: Colors.white)),
    );
  }
}

/* ----------------- MOCK MODEL ----------------- */

class _PendingBill {
  final String type; // RENT/ELECTRICITY/...
  final double amount;
  final DateTime dueDate;

  const _PendingBill({
    required this.type,
    required this.amount,
    required this.dueDate,
  });
}

IconData _billIcon(String type) {
  switch (type) {
    case 'RENT':
      return Icons.home_rounded;
    case 'ELECTRICITY':
      return Icons.bolt_rounded;
    case 'WATER':
      return Icons.water_drop_rounded;
    case 'INTERNET':
      return Icons.wifi_rounded;
    default:
      return Icons.receipt_long_rounded;
  }
}

String _billLabel(String type) {
  switch (type) {
    case 'RENT':
      return 'Alquiler';
    case 'ELECTRICITY':
      return 'Luz';
    case 'WATER':
      return 'Agua';
    case 'INTERNET':
      return 'Internet';
    default:
      return 'Otro';
  }
}

String _formatDate(DateTime d) {
  final dd = d.day.toString().padLeft(2, '0');
  final mm = d.month.toString().padLeft(2, '0');
  final yyyy = d.year.toString();
  return '$dd/$mm/$yyyy';
}
