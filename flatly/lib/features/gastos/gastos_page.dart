import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gradients.dart';

class GastosPage extends StatelessWidget {
  const GastosPage({super.key});

  @override
  Widget build(BuildContext context) {
    // MOCK DATA
    const totalGastado = 482.35;
    const presupuesto = 800.00;
    final progreso = (totalGastado / presupuesto).clamp(0.0, 1.0);

    // Lista de gastos por categoría
    final gastosPorCategoria = [
      {
        'categoria': 'Comida',
        'total': 142.50,
        'gastos': [
          {'nombre': 'Supermercado', 'monto': 60.30, 'pagado': true},
          {'nombre': 'Restaurante', 'monto': 45.20, 'pagado': true},
          {'nombre': 'Delivery', 'monto': 37.00, 'pagado': false},
        ],
      },
      {
        'categoria': 'Luz',
        'total': 85.20,
        'gastos': [
          {'nombre': 'Factura enero', 'monto': 85.20, 'pagado': true},
        ],
      },
      {
        'categoria': 'Agua',
        'total': 42.15,
        'gastos': [
          {'nombre': 'Factura diciembre', 'monto': 42.15, 'pagado': false},
        ],
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        children: [
          // HEADER: Gastos de la casa
          _HeaderCard(),
          const SizedBox(height: 20),

          // RESUMEN DEL MES (igual que antes)
          _ResumenGastosCard(
            totalGastado: totalGastado,
            presupuesto: presupuesto,
            progreso: progreso,
          ),
          const SizedBox(height: 20),

          // LISTA DE GASTOS POR CATEGORÍA
          const Text(
            'Gastos del mes',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          ...gastosPorCategoria.map((categoria) {
            return _CategoriaCard(
              nombre: categoria['categoria'] as String,
              total: categoria['total'] as double,
              gastos: categoria['gastos'] as List<Map<String, dynamic>>,
            );
          }).toList(),

          // BOTÓN PAGAR
          Container(
            margin: const EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
              gradient: AppGradients.success,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(18),
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () {
                  // TODO: Acción de pagar
                },
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.check_circle_rounded,
                          color: Colors.white, size: 22),
                      const SizedBox(width: 10),
                      const Text(
                        'Pagar',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),

          // GRÁFICO MENSUAL (simplificado)
          const Text(
            'Distribución mensual',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          _GraficoMensual(),
          const SizedBox(height: 20),

          // PAGINACIÓN
          _Paginacion(),
        ],
      ),
      // BOTÓN FLOTANTE + Añadir gasto
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Abrir modal añadir gasto
        },
        backgroundColor: AppColors.pink,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Añadir gasto',
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

// HEADER: Gastos de la casa
class _HeaderCard extends StatelessWidget {
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
            'Gastos de la casa',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Comparte y controla los gastos con tus compañeros',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// RESUMEN DE GASTOS (igual que antes)
class _ResumenGastosCard extends StatelessWidget {
  final double totalGastado;
  final double presupuesto;
  final double progreso;

  const _ResumenGastosCard({
    required this.totalGastado,
    required this.presupuesto,
    required this.progreso,
  });

  @override
  Widget build(BuildContext context) {
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

            _GradientText(
              '€${totalGastado.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                letterSpacing: -1,
              ),
              gradient: AppGradients.primary,
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

// TARJETA DE CATEGORÍA (con gastos desplegables)
class _CategoriaCard extends StatefulWidget {
  final String nombre;
  final double total;
  final List<Map<String, dynamic>> gastos;

  const _CategoriaCard({
    required this.nombre,
    required this.total,
    required this.gastos,
  });

  @override
  State<_CategoriaCard> createState() => _CategoriaCardState();
}

class _CategoriaCardState extends State<_CategoriaCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // CABECERA CATEGORÍA
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.nombre,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Text(
                  '€${widget.total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: AppColors.indigo,
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _expanded = !_expanded;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundAlt,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _expanded
                          ? Icons.expand_less_rounded
                          : Icons.expand_more_rounded,
                      color: AppColors.indigo,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),

            // LISTA DE GASTOS (desplegable)
            if (_expanded) ...[
              const SizedBox(height: 12),
              ...widget.gastos.map((gasto) {
                return _GastoItem(
                  nombre: gasto['nombre'] as String,
                  monto: gasto['monto'] as double,
                  pagado: gasto['pagado'] as bool,
                );
              }).toList(),
            ],
          ],
        ),
      ),
    );
  }
}

// ITEM DE GASTO (con checkbox)
class _GastoItem extends StatefulWidget {
  final String nombre;
  final double monto;
  final bool pagado;

  const _GastoItem({
    required this.nombre,
    required this.monto,
    required this.pagado,
  });

  @override
  State<_GastoItem> createState() => _GastoItemState();
}

class _GastoItemState extends State<_GastoItem> {
  late bool _pagado;

  @override
  void initState() {
    super.initState();
    _pagado = widget.pagado;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColors.borderSoft, width: 1),
        ),
      ),
      child: Row(
        children: [
          Checkbox(
            value: _pagado,
            onChanged: (value) {
              setState(() {
                _pagado = value ?? false;
              });
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            activeColor: AppColors.green,
            checkColor: Colors.white,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.nombre,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _pagado
                        ? AppColors.textDisabled
                        : AppColors.textPrimary,
                    decoration:
                        _pagado ? TextDecoration.lineThrough : TextDecoration.none,
                  ),
                ),
                Text(
                  'Hace 2 días', // TODO: fecha dinámica
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '€${widget.monto.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: _pagado ? AppColors.green : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

// GRÁFICO MENSUAL SIMPLIFICADO
class _GraficoMensual extends StatelessWidget {
  final List<Map<String, dynamic>> datos = [
    {'categoria': 'Comida', 'monto': 142.50, 'color': AppColors.pink},
    {'categoria': 'Luz', 'monto': 85.20, 'color': AppColors.amber},
    {'categoria': 'Agua', 'monto': 42.15, 'color': AppColors.cyan},
    {'categoria': 'Internet', 'monto': 38.50, 'color': AppColors.green},
  ];

  @override
  Widget build(BuildContext context) {
    final maxMonto = datos.map((e) => e['monto'] as double).reduce((a, b) => a > b ? a : b);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ...datos.map((item) {
              final porcentaje = (item['monto'] as double) / maxMonto;
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item['categoria'] as String,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          '€${(item['monto'] as double).toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        value: porcentaje,
                        minHeight: 10,
                        backgroundColor: AppColors.borderSoft,
                        valueColor: AlwaysStoppedAnimation(item['color'] as Color),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}

// PAGINACIÓN
class _Paginacion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.backgroundAlt,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.chevron_left_rounded, color: AppColors.indigo),
        ),
        const SizedBox(width: 12),
        const Text(
          '1 - 200',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.backgroundAlt,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.chevron_right_rounded, color: AppColors.indigo),
        ),
      ],
    );
  }
}

// TEXTO CON GRADIENTE (reutilizado)
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
      child: Text(
        text,
        style: style.copyWith(color: Colors.white),
      ),
    );
  }
}