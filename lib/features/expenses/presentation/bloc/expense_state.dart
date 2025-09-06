part of 'expense_bloc.dart';

abstract class ExpenseState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ExpenseLoading extends ExpenseState {}
class ExpenseLoaded extends ExpenseState {
  final List<TransactionModel> transactions;
  ExpenseLoaded(this.transactions);
  @override
  List<Object?> get props => [transactions];
}
class ExpenseError extends ExpenseState {
  final String message;
  ExpenseError(this.message);
  @override
  List<Object?> get props => [message];
}
