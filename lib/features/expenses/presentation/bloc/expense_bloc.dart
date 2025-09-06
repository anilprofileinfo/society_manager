import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/transaction_model.dart';
import '../../data/repositories/transaction_repository.dart';

part 'expense_event.dart';
part 'expense_state.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final TransactionRepository repository;
  ExpenseBloc({required this.repository}) : super(ExpenseLoading()) {
    on<FetchTransactions>(_onFetchTransactions);
    on<AddTransaction>(_onAddTransaction);
    on<DeleteTransaction>(_onDeleteTransaction);
    on<UpdateTransaction>(_onUpdateTransaction);
  }

  Future<void> _onFetchTransactions(FetchTransactions event, Emitter<ExpenseState> emit) async {
    emit(ExpenseLoading());
    try {
      final transactions = await repository.getTransactions();
      emit(ExpenseLoaded(transactions));
    } catch (e) {
      emit(ExpenseError('Failed to fetch transactions'));
    }
  }

  Future<void> _onAddTransaction(AddTransaction event, Emitter<ExpenseState> emit) async {
    try {
      await repository.addTransaction(event.transaction);
      add(FetchTransactions());
    } catch (e) {
      emit(ExpenseError('Failed to add transaction'));
    }
  }

  Future<void> _onDeleteTransaction(DeleteTransaction event, Emitter<ExpenseState> emit) async {
    try {
      await repository.deleteTransaction(event.id);
      add(FetchTransactions());
    } catch (e) {
      emit(ExpenseError('Failed to delete transaction'));
    }
  }

  Future<void> _onUpdateTransaction(UpdateTransaction event, Emitter<ExpenseState> emit) async {
    try {
      await repository.updateTransaction(event.transaction);
      add(FetchTransactions());
    } catch (e) {
      emit(ExpenseError('Failed to update transaction'));
    }
  }
}
