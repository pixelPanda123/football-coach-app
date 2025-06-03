enum PaymentMethod { upi, card, cash }

enum PaymentStatus { pending, completed, failed, refunded }

class Payment {
  final String id;
  final String studentId;
  final double amount;
  final DateTime date;
  final PaymentMethod method;
  final PaymentStatus status;
  final String? transactionId;
  final String? receiptNumber;
  final String? notes;

  Payment({
    required this.id,
    required this.studentId,
    required this.amount,
    required this.date,
    required this.method,
    required this.status,
    this.transactionId,
    this.receiptNumber,
    this.notes,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'] as String,
      studentId: json['studentId'] as String,
      amount: json['amount'] as double,
      date: DateTime.parse(json['date'] as String),
      method: PaymentMethod.values.firstWhere(
        (method) => method.toString() == 'PaymentMethod.${json['method']}',
      ),
      status: PaymentStatus.values.firstWhere(
        (status) => status.toString() == 'PaymentStatus.${json['status']}',
      ),
      transactionId: json['transactionId'] as String?,
      receiptNumber: json['receiptNumber'] as String?,
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'amount': amount,
      'date': date.toIso8601String(),
      'method': method.toString().split('.').last,
      'status': status.toString().split('.').last,
      'transactionId': transactionId,
      'receiptNumber': receiptNumber,
      'notes': notes,
    };
  }
}

class FeeStructure {
  final String id;
  final String batchId;
  final double monthlyFee;
  final double registrationFee;
  final double? equipmentFee;
  final Map<String, double>? additionalFees;
  final bool isActive;

  FeeStructure({
    required this.id,
    required this.batchId,
    required this.monthlyFee,
    required this.registrationFee,
    this.equipmentFee,
    this.additionalFees,
    required this.isActive,
  });

  factory FeeStructure.fromJson(Map<String, dynamic> json) {
    return FeeStructure(
      id: json['id'] as String,
      batchId: json['batchId'] as String,
      monthlyFee: json['monthlyFee'] as double,
      registrationFee: json['registrationFee'] as double,
      equipmentFee: json['equipmentFee'] as double?,
      additionalFees: (json['additionalFees'] as Map<String, dynamic>?)?.map(
        (key, value) => MapEntry(key, value as double),
      ),
      isActive: json['isActive'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'batchId': batchId,
      'monthlyFee': monthlyFee,
      'registrationFee': registrationFee,
      'equipmentFee': equipmentFee,
      'additionalFees': additionalFees,
      'isActive': isActive,
    };
  }

  double get totalFees {
    double total = monthlyFee + registrationFee;
    if (equipmentFee != null) total += equipmentFee!;
    if (additionalFees != null) {
      total += additionalFees!.values.reduce((a, b) => a + b);
    }
    return total;
  }
}

class StudentFeeStatus {
  final String studentId;
  final String batchId;
  final FeeStructure feeStructure;
  final List<Payment> payments;
  final DateTime lastPaymentDate;
  final double totalPaid;
  final double totalDue;

  StudentFeeStatus({
    required this.studentId,
    required this.batchId,
    required this.feeStructure,
    required this.payments,
    required this.lastPaymentDate,
    required this.totalPaid,
    required this.totalDue,
  });

  factory StudentFeeStatus.calculate({
    required String studentId,
    required String batchId,
    required FeeStructure feeStructure,
    required List<Payment> payments,
  }) {
    final completedPayments = payments
        .where((payment) => payment.status == PaymentStatus.completed)
        .toList();

    final totalPaid = completedPayments.fold<double>(
      0,
      (sum, payment) => sum + payment.amount,
    );

    final lastPaymentDate = completedPayments.isEmpty
        ? DateTime(1970)
        : completedPayments
            .reduce((a, b) => a.date.isAfter(b.date) ? a : b)
            .date;

    return StudentFeeStatus(
      studentId: studentId,
      batchId: batchId,
      feeStructure: feeStructure,
      payments: payments,
      lastPaymentDate: lastPaymentDate,
      totalPaid: totalPaid,
      totalDue: feeStructure.totalFees - totalPaid,
    );
  }

  bool get hasPendingDues => totalDue > 0;
  bool get isFullyPaid => totalDue <= 0;
} 