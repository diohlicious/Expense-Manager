import 'package:expense_manager/models/expense_model.dart';
import 'package:expense_manager/provider/expense_bloc.dart';
import 'package:expense_manager/repositories/function.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';


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
    final ExpenseBloc expenseBloc =
    Provider.of<ExpenseBloc>(context, listen: false);
    expenseBloc.fetchData();
    return Selector<ExpenseBloc, List<ExpenseModel>>(
      selector: (_, fetchData) => fetchData.listExpense,
      builder: (_, listExpense, __) {
        return Container(
           child: expenseBloc.listExpense == null
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
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18),
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
                            child: Text(
                              _transDate(data.transDate),
                              //Text(data[index]['_transDate']),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }),
        );
      },
    );
  }
}
