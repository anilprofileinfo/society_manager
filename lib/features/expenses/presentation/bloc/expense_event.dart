part of 'expense_bloc.dart';

abstract class ExpenseEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchTransactions extends ExpenseEvent {}
class AddTransaction extends ExpenseEvent {
  final TransactionModel transaction;
  AddTransaction(this.transaction);
  @override
  List<Object?> get props => [transaction];
}
class DeleteTransaction extends ExpenseEvent {
  final String id;
  DeleteTransaction(this.id);
  @override
  List<Object?> get props => [id];
}
class UpdateTransaction extends ExpenseEvent {
  final TransactionModel transaction;
  UpdateTransaction(this.transaction);
  @override
  List<Object?> get props => [transaction];
}
