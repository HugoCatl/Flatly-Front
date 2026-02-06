// --------------------------------------------------------
// Archivo: lib/pages/gastos_page.dart
// --------------------------------------------------------
import 'package:flatly/features/gastos/pages/anadir_gasto_page.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_gradients.dart';

// Importamos lo que hemos separado
import '../data/mock_data.dart';
import '../widgets/expense_card.dart';

class GastosPage extends StatefulWidget {
  const GastosPage({Key? key}) : super(key: key);

  @override
  State<GastosPage> createState() => _GastosPageState();
}

class _GastosPageState extends State<GastosPage> {
  // Lógica de cálculo (Totales)
  double get totalExpenses {
    return mockBills.fold(0.0, (sum, bill) => sum + bill.amountTotal);
  }

  double get myExpenses {
    // Asumiendo que yo soy ID 1
    return mockBills
        .where((bill) => bill.createdBy == 1)
        .fold(0.0, (sum, bill) => sum + bill.amountTotal);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // 1. CABECERA
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
                        ),
                      ],
                      image: const DecorationImage(
                        image: NetworkImage(
                          'https://picsum.photos/seed/flat/200',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Piso Madrid Centro",
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

            // 2. PESTAÑAS
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
                        gradient: AppGradients.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text(
                          "Gastos",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        "Saldos",
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        "Estadísticas",
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 3. RESUMEN
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSummaryItem("Mis Gastos", myExpenses, AppColors.indigo),
                  _buildSummaryItem(
                    "Gastos Totales",
                    totalExpenses,
                    AppColors.textPrimary,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 4. LISTA DE GASTOS (Usando el Widget separado)
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: mockBills.length + 1, // +1 para el título de fecha
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return const Padding(
                      padding: EdgeInsets.only(left: 4, bottom: 8, top: 10),
                      child: Text(
                        "Febrero 2026",
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    );
                  }
                  // Aquí usamos el widget limpio que importamos
                  return ExpenseCard(bill: mockBills[index - 1]);
                },
              ),
            ),
          ],
        ),
      ),

      // BOTÓN FLOTANTE
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddExpensePage()),
            );
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(Icons.add, color: Colors.white, size: 32),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildSummaryItem(String label, double amount, Color amountColor) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${amount.toStringAsFixed(2)} €',
          style: TextStyle(
            color: amountColor,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
