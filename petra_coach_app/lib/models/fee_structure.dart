import 'package:cloud_firestore/cloud_firestore.dart';

class FeeStructure {
  final String id;
  final String name;
  final String description;
  final double amount;
  final String frequency; // monthly, quarterly, annually
  final DateTime validFrom;
  final DateTime validUntil;
  final List<String> applicableBatches;
  final Map<String, double> components; // breakdown of fee components

  FeeStructure({
    required this.id,
    required this.name,
    required this.description,
    required this.amount,
    required this.frequency,
    required this.validFrom,
    required this.validUntil,
    required this.applicableBatches,
    required this.components,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'amount': amount,
      'frequency': frequency,
      'validFrom': Timestamp.fromDate(validFrom),
      'validUntil': Timestamp.fromDate(validUntil),
      'applicableBatches': applicableBatches,
      'components': components,
    };
  }

  factory FeeStructure.fromMap(Map<String, dynamic> map) {
    return FeeStructure(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      amount: (map['amount'] ?? 0.0).toDouble(),
      frequency: map['frequency'] ?? '',
      validFrom: (map['validFrom'] as Timestamp).toDate(),
      validUntil: (map['validUntil'] as Timestamp).toDate(),
      applicableBatches: List<String>.from(map['applicableBatches'] ?? []),
      components: Map<String, double>.from(map['components'] ?? {}),
    );
  }
} 