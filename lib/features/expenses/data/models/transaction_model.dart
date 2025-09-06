import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  final String id;
  final String type; // 'Spent' or 'Deposited'
  final double amount;
  final Timestamp date;
  final String description;

  TransactionModel({
    required this.id,
    required this.type,
    required this.amount,
    required this.date,
    required this.description,
  });

  factory TransactionModel.fromMap(Map<String, dynamic> map, String id) {
    return TransactionModel(
      id: id,
      type: map['type'] ?? 'Spent',
      amount: (map['amount'] as num).toDouble(),
      date: map['date'] ?? Timestamp.now(),
      description: map['description'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'amount': amount,
      'date': date,
      'description': description,
    };
  }
}
