import '../../../../core/errors/failure.dart';
import '../../domain/entities/expense.dart';
import '../../domain/repositories/expense_repository.dart';
import '../datasources/expense_local_datasource.dart';
import '../models/expense_model.dart';

/// Hive implementation of [ExpenseRepository].
///
/// Converts between [ExpenseModel] (data layer) and
/// [Expense] entity (domain layer).
///
/// Wraps all data source errors in [CacheFailure] so
/// the domain layer never sees raw Hive exceptions.
class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseLocalDatasource _datasource;

  const ExpenseRepositoryImpl(this._datasource);

  @override
  Future<Expense> addExpense(Expense expense) async {
    try {
      final model = ExpenseModel.fromEntity(expense);
      await _datasource.saveExpense(model);
      return expense;
    } catch (e) {
      throw CacheFailure('Failed to add expense: $e');
    }
  }

  @override
  Future<List<Expense>> getExpensesByGroup(String groupId) async {
    try {
      final models = await _datasource.getExpensesByGroup(groupId);
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw CacheFailure('Failed to retrieve expenses: $e');
    }
  }

  @override
  Future<Expense?> getExpenseById(String id) async {
    try {
      final model = await _datasource.getExpenseById(id);
      return model?.toEntity();
    } catch (e) {
      throw CacheFailure('Failed to retrieve expense: $e');
    }
  }

  @override
  Future<Expense> updateExpense(Expense expense) async {
    try {
      final model = ExpenseModel.fromEntity(expense);
      await _datasource.saveExpense(model);
      return expense;
    } catch (e) {
      throw CacheFailure('Failed to update expense: $e');
    }
  }

  @override
  Future<void> deleteExpense(String id) async {
    try {
      await _datasource.deleteExpense(id);
    } catch (e) {
      throw CacheFailure('Failed to delete expense: $e');
    }
  }
}
