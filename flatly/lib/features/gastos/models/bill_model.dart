// --------------------------------------------------------
// Archivo: lib/models/bill_model.dart
// --------------------------------------------------------

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
