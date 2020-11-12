import 'package:expense_manager/app/initdb.dart';
import 'package:expense_manager/models/expense_db_model.dart';
import 'package:expense_manager/models/expense_model.dart';
import 'package:flutter/foundation.dart';

class ExpenseBloc extends ChangeNotifier {
  final initDb = InitDb.instance;
  final dbExpense = ExpenseDbModel.instance;
  List<ExpenseModel> _expense;
  List<ExpenseModel> get listExpense => _expense;

  set listExpense(List<ExpenseModel> val) {
    _expense = val;
    notifyListeners();
  }

  var _balance;
  int get balance => _balance;
  set balance(int val) {
    _balance = val;
    notifyListeners();
  }

  Future<List<ExpenseModel>> fetchData() async {
    final prin = await initDb.initdb();
    //print(prin);
    final allRows = await dbExpense.queryAllRows();
    //List data = List<Map<String,dynamic>>.from(allRows);
    List<ExpenseModel> data = List<ExpenseModel>.from(allRows.map((e) => ExpenseModel.fromJson(e)));
    data.sort((a, b) {
      //return b['_transDate'].compareTo(a['_transDate']);
      return b.transDate.compareTo(a.transDate);
    });
    listExpense = data;
    return listExpense;
  }

  Future<int> calculate() async {
    final _expense = await dbExpense.sum('expense') ?? 0;
    final _income = await dbExpense.sum('income') ?? 0;

    balance = _income - _expense;
    return balance;
  }
}
