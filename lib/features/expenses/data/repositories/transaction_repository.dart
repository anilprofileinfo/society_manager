import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/transaction_model.dart';

class TransactionRepository {
  final CollectionReference transactions = FirebaseFirestore.instance.collection('transactions');

  Future<List<TransactionModel>> getTransactions() async {
    final query = await transactions.orderBy('date', descending: true).get();
    return query.docs.map((doc) => TransactionModel.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    await transactions.add(transaction.toMap());
  }

  Future<void> deleteTransaction(String id) async {
    await transactions.doc(id).delete();
  }

  Future<void> updateTransaction(TransactionModel transaction) async {
    await transactions.doc(transaction.id).update(transaction.toMap());
  }
}
