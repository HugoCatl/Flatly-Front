import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_gradients.dart';

// ScrollPhysics personalizado para scroll más lento
class SlowScrollPhysics extends ScrollPhysics {
  final double velocityFactor;

  const SlowScrollPhysics({
    ScrollPhysics? parent,
    this.velocityFactor = 0.5, // 0.5 = mitad de velocidad, 0.3 = más lento aún
  }) : super(parent: parent);

  @override
  SlowScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return SlowScrollPhysics(
      parent: buildParent(ancestor),
      velocityFactor: velocityFactor,
    );
  }

  @override
  SpringDescription get spring => const SpringDescription(
        mass: 100,
        stiffness: 100,
        damping: 1,
      );

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    return offset;
  }

  @override
  Simulation? createBallisticSimulation(
    ScrollMetrics position,
    double velocity,
  ) {
    // Reducir la velocidad multiplicando por el factor
    final double adjustedVelocity = velocity * velocityFactor;

    if (adjustedVelocity.abs() < tolerance.velocity) {
      return null;
    }

    return ScrollSpringSimulation(
      spring,
      position.pixels,
      position.pixels + adjustedVelocity * 0.3,
      adjustedVelocity,
      tolerance: tolerance,
    );
  }
}

// Modelos basados en tu BD
class Bill {
  final int id;
  final int householdId;
  final String type; // RENT, ELECTRICITY, WATER, INTERNET, OTHER
  final double amountTotal;
  final int periodYear;
  final int periodMonth;
  final DateTime? dueDate;
  final int createdBy;
  final DateTime createdAt;
  final String status; // pending, paid, overdue

  Bill({
    required this.id,
    required this.householdId,
    required this.type,
    required this.amountTotal,
    required this.periodYear,
    required this.periodMonth,
    this.dueDate,
    required this.createdBy,
    required this.createdAt,
    required this.status,
  });
}

class BillSplit {
  final int billId;
  final int userId;
  final double amount;
  final String userName;

  BillSplit({
    required this.billId,
    required this.userId,
    required this.amount,
    required this.userName,
  });
}

class GastosPage extends StatefulWidget {
  const GastosPage({Key? key}) : super(key: key);

  @override
  State<GastosPage> createState() => _GastosPageState();
}

class _GastosPageState extends State<GastosPage> {
  // Datos mock basados en tu estructura de BD
  final List<Bill> mockBills = [
    Bill(
      id: 1,
      householdId: 1,
      type: 'RENT',
      amountTotal: 800.00,
      periodYear: 2026,
      periodMonth: 2,
      dueDate: DateTime(2026, 2, 5),
      createdBy: 1,
      createdAt: DateTime(2026, 2, 1),
      status: 'paid',
    ),
    Bill(
      id: 2,
      householdId: 1,
      type: 'ELECTRICITY',
      amountTotal: 85.50,
      periodYear: 2026,
      periodMonth: 2,
      dueDate: DateTime(2026, 2, 10),
      createdBy: 2,
      createdAt: DateTime(2026, 2, 3),
      status: 'pending',
    ),
    Bill(
      id: 3,
      householdId: 1,
      type: 'WATER',
      amountTotal: 45.00,
      periodYear: 2026,
      periodMonth: 2,
      dueDate: DateTime(2026, 2, 15),
      createdBy: 1,
      createdAt: DateTime(2026, 2, 5),
      status: 'pending',
    ),
    Bill(
      id: 4,
      householdId: 1,
      type: 'INTERNET',
      amountTotal: 50.00,
      periodYear: 2026,
      periodMonth: 2,
      dueDate: DateTime(2026, 2, 1),
      createdBy: 3,
      createdAt: DateTime(2026, 1, 25),
      status: 'paid',
    ),
    Bill(
      id: 5,
      householdId: 1,
      type: 'OTHER',
      amountTotal: 120.00,
      periodYear: 2026,
      periodMonth: 2,
      dueDate: DateTime(2026, 2, 20),
      createdBy: 1,
      createdAt: DateTime(2026, 2, 8),
      status: 'pending',
    ),
    // Mes anterior para gráfica de evolución
    Bill(
      id: 6,
      householdId: 1,
      type: 'RENT',
      amountTotal: 800.00,
      periodYear: 2026,
      periodMonth: 1,
      createdBy: 1,
      createdAt: DateTime(2026, 1, 1),
      status: 'paid',
    ),
    Bill(
      id: 7,
      householdId: 1,
      type: 'ELECTRICITY',
      amountTotal: 92.00,
      periodYear: 2026,
      periodMonth: 1,
      createdBy: 2,
      createdAt: DateTime(2026, 1, 5),
      status: 'paid',
    ),
  ];

  final Map<int, List<BillSplit>> mockSplits = {
    1: [
      BillSplit(billId: 1, userId: 1, amount: 266.67, userName: 'Carlos'),
      BillSplit(billId: 1, userId: 2, amount: 266.67, userName: 'Ana'),
      BillSplit(billId: 1, userId: 3, amount: 266.66, userName: 'Luis'),
    ],
    2: [
      BillSplit(billId: 2, userId: 1, amount: 28.50, userName: 'Carlos'),
      BillSplit(billId: 2, userId: 2, amount: 28.50, userName: 'Ana'),
      BillSplit(billId: 2, userId: 3, amount: 28.50, userName: 'Luis'),
    ],
    3: [
      BillSplit(billId: 3, userId: 1, amount: 15.00, userName: 'Carlos'),
      BillSplit(billId: 3, userId: 2, amount: 15.00, userName: 'Ana'),
      BillSplit(billId: 3, userId: 3, amount: 15.00, userName: 'Luis'),
    ],
    4: [
      BillSplit(billId: 4, userId: 1, amount: 16.67, userName: 'Carlos'),
      BillSplit(billId: 4, userId: 2, amount: 16.67, userName: 'Ana'),
      BillSplit(billId: 4, userId: 3, amount: 16.66, userName: 'Luis'),
    ],
    5: [
      BillSplit(billId: 5, userId: 1, amount: 40.00, userName: 'Carlos'),
      BillSplit(billId: 5, userId: 2, amount: 40.00, userName: 'Ana'),
      BillSplit(billId: 5, userId: 3, amount: 40.00, userName: 'Luis'),
    ],
  };

  List<Bill> get currentMonthBills {
    final now = DateTime.now();
    return mockBills
        .where((b) => b.periodYear == now.year && b.periodMonth == now.month)
        .toList();
  }

  double get totalExpenses {
    return currentMonthBills.fold(0.0, (sum, bill) => sum + bill.amountTotal);
  }

  Map<String, double> get expensesByCategory {
    final Map<String, double> categories = {};
    for (var bill in currentMonthBills) {
      categories[bill.type] = (categories[bill.type] ?? 0) + bill.amountTotal;
    }
    return categories;
  }

  Map<String, double> get userBalances {
    final Map<String, double> balances = {};
    for (var bill in currentMonthBills) {
      final splits = mockSplits[bill.id] ?? [];
      for (var split in splits) {
        balances[split.userName] = (balances[split.userName] ?? 0) + split.amount;
      }
    }
    return balances;
  }

  Color getCategoryColor(String type) {
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

  String getCategoryName(String type) {
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
        return 'Otros';
      default:
        return type;
    }
  }

  IconData getCategoryIcon(String type) {
    switch (type) {
      case 'RENT':
        return Icons.home;
      case 'ELECTRICITY':
        return Icons.bolt;
      case 'WATER':
        return Icons.water_drop;
      case 'INTERNET':
        return Icons.wifi;
      case 'OTHER':
        return Icons.receipt_long;
      default:
        return Icons.attach_money;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Gastos del piso',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        physics: const SlowScrollPhysics(velocityFactor: 0.4), // Ajusta este valor: 0.4 = lento, 0.6 = menos lento
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMonthSelector(),
            const SizedBox(height: 20),
            _buildSummaryCards(),
            const SizedBox(height: 24),
            _buildCategoryChart(),
            const SizedBox(height: 24),
            _buildMonthlyEvolutionChart(),
            const SizedBox(height: 24),
            _buildUserBalances(),
            const SizedBox(height: 24),
            _buildExpensesList(),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppGradients.primary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.indigo.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.chevron_left, color: Colors.white),
          ),
          const Column(
            children: [
              Text(
                'Febrero 2026',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Mes actual',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.chevron_right, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            'Total gastado',
            '${totalExpenses.toStringAsFixed(2)}€',
            Icons.account_balance_wallet,
            AppGradients.addExpense,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSummaryCard(
            'Gastos totales',
            '${currentMonthBills.length}',
            Icons.receipt,
            AppGradients.search,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    IconData icon,
    LinearGradient gradient,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderSoft),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChart() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderSoft),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Gastos por categoría',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: PieChart(
                    PieChartData(
                      sections: expensesByCategory.entries.map((entry) {
                        final percentage = (entry.value / totalExpenses) * 100;
                        return PieChartSectionData(
                          value: entry.value,
                          title: '${percentage.toStringAsFixed(0)}%',
                          color: getCategoryColor(entry.key),
                          radius: 60,
                          titleStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        );
                      }).toList(),
                      sectionsSpace: 2,
                      centerSpaceRadius: 40,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: expensesByCategory.entries.map((entry) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: getCategoryColor(entry.key),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                getCategoryName(entry.key),
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyEvolutionChart() {
    // Datos de los últimos 6 meses (mock)
    final monthlyData = [
      {'month': 'Sep', 'amount': 950.0},
      {'month': 'Oct', 'amount': 1020.0},
      {'month': 'Nov', 'amount': 980.0},
      {'month': 'Dic', 'amount': 1100.0},
      {'month': 'Ene', 'amount': 892.0},
      {'month': 'Feb', 'amount': totalExpenses},
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderSoft),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Evolución mensual',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 1200,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= 0 && value.toInt() < monthlyData.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              monthlyData[value.toInt()]['month'] as String,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}€',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 200,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: AppColors.borderSoft,
                      strokeWidth: 1,
                    );
                  },
                ),
                borderData: FlBorderData(show: false),
                barGroups: monthlyData.asMap().entries.map((entry) {
                  return BarChartGroupData(
                    x: entry.key,
                    barRods: [
                      BarChartRodData(
                        toY: entry.value['amount'] as double,
                        gradient: AppGradients.primary,
                        width: 20,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(4),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserBalances() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderSoft),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'División por compañero',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...userBalances.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.indigo.withOpacity(0.1),
                    child: Text(
                      entry.key[0],
                      style: const TextStyle(
                        color: AppColors.indigo,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.key,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Debe pagar',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${entry.value.toStringAsFixed(2)}€',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildExpensesList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Gastos del mes',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...currentMonthBills.map((bill) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderSoft),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: getCategoryColor(bill.type).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        getCategoryIcon(bill.type),
                        color: getCategoryColor(bill.type),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            getCategoryName(bill.type),
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            bill.dueDate != null
                                ? 'Vence: ${bill.dueDate!.day}/${bill.dueDate!.month}/${bill.dueDate!.year}'
                                : 'Sin fecha',
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${bill.amountTotal.toStringAsFixed(2)}€',
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: bill.status == 'paid'
                                ? AppColors.green.withOpacity(0.1)
                                : bill.status == 'overdue'
                                    ? AppColors.red.withOpacity(0.1)
                                    : AppColors.amber.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            bill.status == 'paid'
                                ? 'Pagado'
                                : bill.status == 'overdue'
                                    ? 'Vencido'
                                    : 'Pendiente',
                            style: TextStyle(
                              color: bill.status == 'paid'
                                  ? AppColors.green
                                  : bill.status == 'overdue'
                                      ? AppColors.red
                                      : AppColors.amber,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                if (mockSplits[bill.id] != null) ...[
                  const Divider(height: 24),
                  Column(
                    children: mockSplits[bill.id]!.map((split) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          children: [
                            const SizedBox(width: 42),
                            Expanded(
                              child: Text(
                                split.userName,
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            Text(
                              '${split.amount.toStringAsFixed(2)}€',
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          );
        }).toList(),
      ],
    );
  }
}