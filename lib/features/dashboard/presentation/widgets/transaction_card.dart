import 'package:flutter/material.dart';

class TransactionCard extends StatelessWidget {
  final String type; // 'Spent' or 'Deposited'
  final double amount;
  final DateTime date;
  final String description;
  const TransactionCard({super.key, required this.type, required this.amount, required this.date, required this.description});

  @override
  Widget build(BuildContext context) {
    final color = type == 'Spent' ? Colors.red : Colors.green;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Icon(type == 'Spent' ? Icons.remove_circle : Icons.add_circle, color: color),
        title: Text('₹${amount.toStringAsFixed(2)}', style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        subtitle: Text('${date.day}/${date.month}/${date.year}\n$description'),
        isThreeLine: true,
        trailing: Text(type, style: TextStyle(color: color)),
      ),
    );
  }
}
