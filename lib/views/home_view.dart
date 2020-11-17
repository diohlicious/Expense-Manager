import 'package:animations/animations.dart';
import 'package:expense_manager/models/expense_model.dart';
import 'package:expense_manager/provider/expense_bloc.dart';
import 'package:expense_manager/repositories/function.dart';
import 'package:dynamic_widget/dynamic_widget.dart';
import 'package:expense_manager/views/add_transaction_view.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const double _fabDimension = 56.0;

class HomeView extends StatelessWidget {
  static const String routeName = '/home';

  HomeView({Key key, this.title}) : super(key: key);

  final String title;

  /*void _addTransaction() async {
    FocusScope.of(context).requestFocus(new FocusNode());
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryView(),
      ),
    );
    if('$result'!='null')
      setState(() {
        _txtCat.text = '$result';
      });
  }*/

  @override
  Widget build(BuildContext context) {
    ContainerTransitionType _transitionType = ContainerTransitionType.fade;
    final ExpenseBloc expenseBloc =
        Provider.of<ExpenseBloc>(context, listen: false);
    expenseBloc.fetchWidget();
    //final String jsonString = expenseBloc.jsonString;
    //print('ok'+expenseBloc.jsonString) ;
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Selector<ExpenseBloc, String>(
          selector: (_, fetchWidget) => fetchWidget.jsonString,
          builder: (_, jsonString, __) {
            return Container(
              child: jsonString == null
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : FutureBuilder<Widget>(
                      future: homeWidget(context, jsonString),
                      builder: (BuildContext context,
                          AsyncSnapshot<Widget> snapshot) {
                        if (snapshot.hasError) {
                          print(snapshot.error);
                        }
                        return snapshot.hasData
                            ? SizedBox.expand(
                                child: snapshot.data,
                              )
                            : Text("Loading...");
                      },
                    ),
            );
          }),
      //HomeWidget(),
      floatingActionButton: OpenContainer(
        transitionType: _transitionType,
        openBuilder: (BuildContext context, VoidCallback _) {
          return AddTransactionView();
        },
        closedElevation: 6.0,
        closedShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(_fabDimension / 2),
          ),
        ),
        closedColor: Theme.of(context).colorScheme.secondary,
        transitionDuration: Duration(milliseconds: 800),
        closedBuilder: (BuildContext context, VoidCallback _) {
          return SizedBox(
            height: _fabDimension,
            width: _fabDimension,
            child: Center(
              child: Icon(
                Icons.add,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            ),
          );
        },
      ),
      /*FloatingActionButton(
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
      ),*/ // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<Widget> homeWidget(BuildContext context, String jsonString) async {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Card(
            margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: Container(
              alignment: Alignment.center,
              child: DynamicWidgetBuilder.build(
                  jsonString, context, DefaultClickListener()),
              /*Text(_jsonWidget.toString(), //_balance.toString(),
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),*/
            ),
          ),
        ),
        Expanded(
          flex: 7,
          child: //listView,
              HomeListWidget(),
        ),
      ],
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
    final ExpenseBloc expenseBloc =
    Provider.of<ExpenseBloc>(context, listen: false);
    expenseBloc.fetchData();
    return Selector<ExpenseBloc, List<ExpenseModel>>(
      selector: (_, fetchWidget) => fetchWidget.listExpense,
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

class DefaultClickListener implements ClickListener {
  @override
  void onClicked(String event) {
    print("Receive click event: " + event);
  }
}
