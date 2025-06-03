import 'package:cloud_firestore/cloud_firestore.dart';

class Payment {
  final String id;
  final String studentId;
  final double amount;
  final DateTime paymentDate;
  final String paymentMethod;
  final String status;
  final String description;
  final String receiptNumber;
  final String feeStructureId;

  Payment({
    required this.id,
    required this.studentId,
    required this.amount,
    required this.paymentDate,
    required this.paymentMethod,
    required this.status,
    required this.description,
    required this.receiptNumber,
    required this.feeStructureId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'studentId': studentId,
      'amount': amount,
      'paymentDate': Timestamp.fromDate(paymentDate),
      'paymentMethod': paymentMethod,
      'status': status,
      'description': description,
      'receiptNumber': receiptNumber,
      'feeStructureId': feeStructureId,
    };
  }

  factory Payment.fromMap(Map<String, dynamic> map) {
    return Payment(
      id: map['id'] ?? '',
      studentId: map['studentId'] ?? '',
      amount: (map['amount'] ?? 0.0).toDouble(),
      paymentDate: (map['paymentDate'] as Timestamp).toDate(),
      paymentMethod: map['paymentMethod'] ?? '',
      status: map['status'] ?? '',
      description: map['description'] ?? '',
      receiptNumber: map['receiptNumber'] ?? '',
      feeStructureId: map['feeStructureId'] ?? '',
    );
  }
} 