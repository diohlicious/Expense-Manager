
import 'package:expense_manager/app/initdb.dart';
import 'package:expense_manager/models/expense_db_model.dart';
import 'package:expense_manager/models/expense_model.dart';
import 'package:expense_manager/provider/expense_bloc.dart';
import 'package:expense_manager/repositories/function.dart';
import 'package:expense_manager/views/add_transaction_view.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeView extends StatelessWidget {
  static const String routeName = '/home';

  HomeView({Key key, this.title}) : super(key: key);

  final String title;

/*  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {*/
  //List<Map<String, dynamic>> data;
  final initDb = InitDb.instance;
  final dbExpense = ExpenseDbModel.instance;

  @override
  Widget build(BuildContext context) {
    final ExpenseBloc expenseBloc = Provider.of<ExpenseBloc>(context);
    expenseBloc.calculate();
    final int _balance = expenseBloc.balance;
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: expenseBloc.balance == null
        ? Center(
        child: CircularProgressIndicator(),
    )
        : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Card(
              margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  'Balance Rp: ' + _balance.toString(), //_balance.toString(),
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: //listView,
                HomeListWidget(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: //_insertExpense,
        () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTransactionView(),
            ),
          );
        },
        tooltip: 'Add Expense',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class HomeListWidget extends StatelessWidget {

  _expenseIcon(String _typeStr) {
    if (FunctionRepo.equalsIgnoreCase(_typeStr, 'expense')) {
      return Icon(
        Icons.arrow_upward_sharp,
        color: Colors.red,
        size: 60,
      );
    } else {
      return Icon(
        Icons.arrow_downward_sharp,
        color: Colors.green,
        size: 60,
      );
    }
  }

  String _transDate(String _dateStr) {
    DateFormat dateFormat = DateFormat('yyyy-MM-ddTHH:mm:ss');
    String _transDateTime = _dateStr; //data[index]['_transDate'];
    DateTime dateTime = dateFormat.parse(_transDateTime);
    String formattedDate = DateFormat('d MMM yyyy').format(dateTime);
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    final ExpenseBloc expenseBloc = Provider.of<ExpenseBloc>(context);
    expenseBloc.fetchData();
    return expenseBloc.listExpense == null
        ? Center(
      child: CircularProgressIndicator(),
    )
        : ListView.builder(
        itemCount: expenseBloc.listExpense.length,
        itemBuilder: (BuildContext context, int index) {
          final ExpenseModel data = expenseBloc.listExpense[index];
          return Card(
              margin: EdgeInsets.fromLTRB(5, 1, 5, 5),
              child: Container(
                  padding: EdgeInsets.fromLTRB(3, 10, 3, 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: _expenseIcon(data.type),
                      ),
                      Expanded(
                        flex: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'RP ' + data.amt.toString(),
                              style:
                                  TextStyle(color: Colors.black, fontSize: 18),
                            ),
                            Text(
                              data.category,
                              style: TextStyle(
                                  color: Colors.grey[700], fontSize: 15),
                            ),
                            Text(
                              data.description,
                              style: TextStyle(
                                  color: Colors.grey[700], fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: 50,
                          alignment: Alignment.topLeft,
                          child: Text(_transDate(data.transDate),
                            //Text(data[index]['_transDate']),
                        ),
                      ),
                      )],
                  )));
        });
  }
}
