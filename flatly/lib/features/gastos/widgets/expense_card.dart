// --------------------------------------------------------
// Archivo: lib/widgets/expense_card.dart
// --------------------------------------------------------
import 'package:flatly/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import '../models/bill_model.dart';

class ExpenseCard extends StatelessWidget {
  final Bill bill;

  const ExpenseCard({super.key, required this.bill});

  // --- Lógica Visual Interna (Movida desde la página principal) ---

  Color _getCategoryColor(String type) {
    switch (type) {
      case 'RENT':
        return AppColors.indigo;
      case 'ELECTRICITY':
        return AppColors.amber;
      case 'WATER':
        return AppColors.cyan;
      case 'INTERNET':
        return AppColors.violet;
      case 'OTHER':
        return AppColors.pink;
      default:
        return AppColors.textSecondary;
    }
  }

  String _getCategoryName(String type) {
    switch (type) {
      case 'RENT':
        return 'Alquiler';
      case 'ELECTRICITY':
        return 'Electricidad';
      case 'WATER':
        return 'Agua';
      case 'INTERNET':
        return 'Internet';
      case 'OTHER':
        return 'Varios';
      default:
        return type;
    }
  }

  IconData _getCategoryIcon(String type) {
    switch (type) {
      case 'RENT':
        return Icons.apartment;
      case 'ELECTRICITY':
        return Icons.lightbulb;
      case 'WATER':
        return Icons.water_drop;
      case 'INTERNET':
        return Icons.wifi;
      case 'OTHER':
        return Icons.shopping_cart;
      default:
        return Icons.attach_money;
    }
  }

  String _getUserName(int userId) {
    switch (userId) {
      case 1:
        return 'Alex (Yo)';
      case 2:
        return 'Julia';
      case 3:
        return 'Guillermo';
      default:
        return 'Desconocido';
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getCategoryColor(bill.type);
    final icon = _getCategoryIcon(bill.type);
    final name = _getCategoryName(bill.type);
    final userName = _getUserName(bill.createdBy);

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
          // Icono
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(width: 16),
          // Textos
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "Pagado por $userName",
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          // Precio
          Text(
            '${bill.amountTotal.toStringAsFixed(2)} €',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
