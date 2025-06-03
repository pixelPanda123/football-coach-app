import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/payment.dart';
import '../models/fee_structure.dart';

class FeeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fee Structure Methods
  Future<void> createFeeStructure(FeeStructure feeStructure) async {
    try {
      await _firestore.collection('feeStructures').doc(feeStructure.id).set(feeStructure.toMap());
    } catch (e) {
      throw Exception('Failed to create fee structure: $e');
    }
  }

  Future<FeeStructure?> getFeeStructure(String id) async {
    try {
      final doc = await _firestore.collection('feeStructures').doc(id).get();
      if (doc.exists) {
        return FeeStructure.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get fee structure: $e');
    }
  }

  Future<List<FeeStructure>> getActiveFeeStructures() async {
    try {
      final now = DateTime.now();
      final querySnapshot = await _firestore
          .collection('feeStructures')
          .where('validUntil', isGreaterThanOrEqualTo: now)
          .get();
      
      return querySnapshot.docs
          .map((doc) => FeeStructure.fromMap(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to get active fee structures: $e');
    }
  }

  // Payment Methods
  Future<void> createPayment(Payment payment) async {
    try {
      await _firestore.collection('payments').doc(payment.id).set(payment.toMap());
    } catch (e) {
      throw Exception('Failed to create payment: $e');
    }
  }

  Future<List<Payment>> getStudentPayments(String studentId) async {
    try {
      final querySnapshot = await _firestore
          .collection('payments')
          .where('studentId', isEqualTo: studentId)
          .orderBy('paymentDate', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => Payment.fromMap(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to get student payments: $e');
    }
  }

  // Report Generation Methods
  Future<Map<String, double>> generateBatchWiseReport(
    String batchId,
    DateTime startDate,
    DateTime endDate
  ) async {
    try {
      final querySnapshot = await _firestore
          .collection('payments')
          .where('paymentDate', isGreaterThanOrEqualTo: startDate)
          .where('paymentDate', isLessThanOrEqualTo: endDate)
          .get();

      Map<String, double> report = {
        'totalCollected': 0,
        'pending': 0,
        'overdue': 0,
      };

      for (var doc in querySnapshot.docs) {
        final payment = Payment.fromMap(doc.data());
        if (payment.status == 'completed') {
          report['totalCollected'] = (report['totalCollected'] ?? 0) + payment.amount;
        } else if (payment.status == 'pending') {
          report['pending'] = (report['pending'] ?? 0) + payment.amount;
        } else if (payment.status == 'overdue') {
          report['overdue'] = (report['overdue'] ?? 0) + payment.amount;
        }
      }

      return report;
    } catch (e) {
      throw Exception('Failed to generate batch-wise report: $e');
    }
  }

  Future<Map<String, dynamic>> generateFinancialDashboardData() async {
    try {
      final now = DateTime.now();
      final startOfMonth = DateTime(now.year, now.month, 1);
      final endOfMonth = DateTime(now.year, now.month + 1, 0);

      final querySnapshot = await _firestore
          .collection('payments')
          .where('paymentDate', isGreaterThanOrEqualTo: startOfMonth)
          .where('paymentDate', isLessThanOrEqualTo: endOfMonth)
          .get();

      Map<String, dynamic> dashboardData = {
        'currentMonthCollection': 0.0,
        'paymentMethods': <String, double>{},
        'dailyCollection': <String, double>{},
        'pendingPayments': 0.0,
        'overduePayments': 0.0,
      };

      for (var doc in querySnapshot.docs) {
        final payment = Payment.fromMap(doc.data());
        
        if (payment.status == 'completed') {
          dashboardData['currentMonthCollection'] += payment.amount;

          // Update payment method statistics
          dashboardData['paymentMethods'][payment.paymentMethod] = 
              (dashboardData['paymentMethods'][payment.paymentMethod] ?? 0.0) + payment.amount;

          // Update daily collection
          final dateKey = payment.paymentDate.toString().split(' ')[0];
          dashboardData['dailyCollection'][dateKey] = 
              (dashboardData['dailyCollection'][dateKey] ?? 0.0) + payment.amount;
        } else if (payment.status == 'pending') {
          dashboardData['pendingPayments'] += payment.amount;
        } else if (payment.status == 'overdue') {
          dashboardData['overduePayments'] += payment.amount;
        }
      }

      return dashboardData;
    } catch (e) {
      throw Exception('Failed to generate financial dashboard data: $e');
    }
  }

  // Utility Methods
  Future<double> calculateStudentDues(String studentId) async {
    try {
      final feeStructures = await getActiveFeeStructures();
      final payments = await getStudentPayments(studentId);
      
      double totalDue = 0;
      double totalPaid = 0;

      for (var structure in feeStructures) {
        totalDue += structure.amount;
      }

      for (var payment in payments) {
        if (payment.status == 'completed') {
          totalPaid += payment.amount;
        }
      }

      return totalDue - totalPaid;
    } catch (e) {
      throw Exception('Failed to calculate student dues: $e');
    }
  }
} 