import 'package:flutter/material.dart';
// Asegúrate de que las rutas sean correctas según tu proyecto
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gradients.dart';

// ---------------------------------------------------------------------------
// 1. UTILIDADES Y MODELOS (MANTENIDOS DE TU CÓDIGO ACTUAL)
// ---------------------------------------------------------------------------

class SlowScrollPhysics extends ScrollPhysics {
  final double velocityFactor;
  const SlowScrollPhysics({ScrollPhysics? parent, this.velocityFactor = 0.5}) : super(parent: parent);

  @override
  SlowScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return SlowScrollPhysics(parent: buildParent(ancestor), velocityFactor: velocityFactor);
  }

  @override
  SpringDescription get spring => const SpringDescription(mass: 100, stiffness: 100, damping: 1);

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) => offset;

  @override
  Simulation? createBallisticSimulation(ScrollMetrics position, double velocity) {
    final double adjustedVelocity = velocity * velocityFactor;
    if (adjustedVelocity.abs() < tolerance.velocity) return null;
    return ScrollSpringSimulation(spring, position.pixels, position.pixels + adjustedVelocity * 0.3, adjustedVelocity, tolerance: tolerance);
  }
}

// Modelos basados en tu esquema SQL
class Bill {
  final int id;
  final int householdId;
  final String type; // RENT, ELECTRICITY, etc.
  final double amountTotal;
  final int periodYear;
  final int periodMonth;
  final DateTime? dueDate;
  final int createdBy;
  final DateTime createdAt;
  final String status;

  Bill({
    required this.id, required this.householdId, required this.type, required this.amountTotal,
    required this.periodYear, required this.periodMonth, this.dueDate, required this.createdBy,
    required this.createdAt, required this.status,
  });
}

class BillSplit {
  final int billId;
  final int userId;
  final double amount;
  final String userName;

  BillSplit({required this.billId, required this.userId, required this.amount, required this.userName});
}

// ---------------------------------------------------------------------------
// 2. PÁGINA DE GASTOS (DISEÑO TRICOUNT + LÓGICA SQL)
// ---------------------------------------------------------------------------

class GastosPage extends StatefulWidget {
  const GastosPage({Key? key}) : super(key: key);

  @override
  State<GastosPage> createState() => _GastosPageState();
}

class _GastosPageState extends State<GastosPage> {
  // DATOS MOCK (Tus datos originales)
  final List<Bill> mockBills = [
    Bill(id: 1, householdId: 1, type: 'RENT', amountTotal: 800.00, periodYear: 2026, periodMonth: 2, dueDate: DateTime(2026, 2, 5), createdBy: 1, createdAt: DateTime(2026, 2, 1), status: 'paid'),
    Bill(id: 2, householdId: 1, type: 'ELECTRICITY', amountTotal: 85.50, periodYear: 2026, periodMonth: 2, dueDate: DateTime(2026, 2, 10), createdBy: 2, createdAt: DateTime(2026, 2, 3), status: 'pending'),
    Bill(id: 3, householdId: 1, type: 'WATER', amountTotal: 45.00, periodYear: 2026, periodMonth: 2, dueDate: DateTime(2026, 2, 15), createdBy: 1, createdAt: DateTime(2026, 2, 5), status: 'pending'),
    Bill(id: 4, householdId: 1, type: 'INTERNET', amountTotal: 50.00, periodYear: 2026, periodMonth: 2, dueDate: DateTime(2026, 2, 1), createdBy: 3, createdAt: DateTime(2026, 1, 25), status: 'paid'),
    Bill(id: 5, householdId: 1, type: 'OTHER', amountTotal: 120.00, periodYear: 2026, periodMonth: 2, dueDate: DateTime(2026, 2, 20), createdBy: 1, createdAt: DateTime(2026, 2, 8), status: 'pending'),
  ];

  // Helper para simular nombres (en la app real vendría de la tabla 'users')
  String getUserName(int userId) {
    switch (userId) {
      case 1: return 'Alex (Yo)';
      case 2: return 'Julia';
      case 3: return 'Guillermo';
      default: return 'Desconocido';
    }
  }

  List<Bill> get currentMonthBills {
    // Aquí podrías filtrar por mes actual si quisieras
    return mockBills; 
  }

  double get totalExpenses {
    return currentMonthBills.fold(0.0, (sum, bill) => sum + bill.amountTotal);
  }

  // Calculamos "Mis Gastos" (Asumiendo que el usuario logueado es ID 1)
  double get myExpenses {
    return currentMonthBills
        .where((bill) => bill.createdBy == 1)
        .fold(0.0, (sum, bill) => sum + bill.amountTotal);
  }

  // Mapeo de ENUM SQL a Colores de AppColors
  Color getCategoryColor(String type) {
    switch (type) {
      case 'RENT': return AppColors.indigo;       // Alquiler
      case 'ELECTRICITY': return AppColors.amber; // Luz
      case 'WATER': return AppColors.cyan;        // Agua
      case 'INTERNET': return AppColors.violet;   // Internet
      case 'OTHER': return AppColors.pink;        // Otros
      default: return AppColors.textSecondary;
    }
  }

  // Mapeo de ENUM SQL a Nombres legibles
  String getCategoryName(String type) {
    switch (type) {
      case 'RENT': return 'Alquiler';
      case 'ELECTRICITY': return 'Electricidad';
      case 'WATER': return 'Agua';
      case 'INTERNET': return 'Internet';
      case 'OTHER': return 'Varios';
      default: return type;
    }
  }

  // Mapeo de ENUM SQL a Iconos
  IconData getCategoryIcon(String type) {
    switch (type) {
      case 'RENT': return Icons.apartment;        // Icono Hotel/Piso
      case 'ELECTRICITY': return Icons.lightbulb; // Icono Luz
      case 'WATER': return Icons.water_drop;      // Icono Agua
      case 'INTERNET': return Icons.wifi;         // Icono Wifi
      case 'OTHER': return Icons.shopping_cart;   // Icono Picnic/Compra
      default: return Icons.attach_money;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Usamos AppColors.background para mantener la coherencia con tu tema
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            
            // ------------------------------------------------------
            // 1. CABECERA (Imagen y Título) - Estilo Tricount
            // ------------------------------------------------------
            Center(
              child: Column(
                children: [
                  Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        )
                      ],
                      // Imagen de ejemplo (cambiar por asset local si tienes)
                      image: const DecorationImage(
                        image: NetworkImage('https://picsum.photos/seed/flat/200'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Piso Madrid Centro", // Título del Household
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ------------------------------------------------------
            // 2. PESTAÑAS (Gastos | Saldos | Fotos)
            // ------------------------------------------------------
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: AppColors.borderSoft),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        gradient: AppGradients.primary, // Indigo -> Violet
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.indigo.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: const Center(
                        child: Text("Gastos", 
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)
                        ),
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text("Saldos", 
                        style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w500)
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text("Fotos", 
                        style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w500)
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ------------------------------------------------------
            // 3. RESUMEN (Mis Gastos vs Totales)
            // ------------------------------------------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Usa tus datos calculados reales 'myExpenses'
                  _buildSummaryItem("Mis Gastos", myExpenses, AppColors.indigo),
                  // Usa 'totalExpenses'
                  _buildSummaryItem("Gastos Totales", totalExpenses, AppColors.textPrimary),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ------------------------------------------------------
            // 4. LISTA DE GASTOS
            // ------------------------------------------------------
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                physics: const SlowScrollPhysics(velocityFactor: 0.4),
                // +1 para poner un título de fecha al principio
                itemCount: currentMonthBills.length + 1, 
                itemBuilder: (context, index) {
                  if (index == 0) {
                    // Cabecera de fecha simulada (Estilo Tricount)
                    return const Padding(
                      padding: EdgeInsets.only(left: 4, bottom: 8, top: 10),
                      child: Text("Febrero 2026", 
                        style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold, fontSize: 14)
                      ),
                    );
                  }

                  final bill = currentMonthBills[index - 1];
                  return _buildExpenseCard(bill);
                },
              ),
            ),
          ],
        ),
      ),

      // ------------------------------------------------------
      // BOTÓN FLOTANTE (Gradient Rosa - Estilo botón +)
      // ------------------------------------------------------
      floatingActionButton: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: AppGradients.addExpense, 
          boxShadow: [
            BoxShadow(
              color: AppColors.pink.withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () {
            // AQUÍ IRÍA LA NAVEGACIÓN A LA PANTALLA "AÑADIR GASTO"
            // Navigator.push(...)
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(Icons.add, color: Colors.white, size: 32),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  // WIDGET: Resumen Superior
  Widget _buildSummaryItem(String label, double amount, Color amountColor) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text('${amount.toStringAsFixed(2)} €', style: TextStyle(color: amountColor, fontSize: 22, fontWeight: FontWeight.bold)),
      ],
    );
  }

  // WIDGET: Tarjeta de Gasto Individual
  Widget _buildExpenseCard(Bill bill) {
    final color = getCategoryColor(bill.type);
    final icon = getCategoryIcon(bill.type);
    final userName = getUserName(bill.createdBy);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderSoft),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icono cuadrado con fondo suave (Estilo Tricount)
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(width: 16),
          
          // Título y Pagador
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  getCategoryName(bill.type), // Ejemplo: "Alquiler"
                  style: const TextStyle(
                    fontSize: 16, 
                    fontWeight: FontWeight.bold, 
                    color: AppColors.textPrimary
                  )
                ),
                const SizedBox(height: 2),
                Text(
                  "Pagado por $userName",
                  style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          
          // Precio a la derecha
          Text(
            '${bill.amountTotal.toStringAsFixed(2)} €',
            style: const TextStyle(
              fontSize: 18, 
              fontWeight: FontWeight.bold, 
              color: AppColors.textPrimary
            ),
          ),
        ],
      ),
    );
  }
}