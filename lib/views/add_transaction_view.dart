
import 'package:flutter/material.dart';

import 'expense_form_view.dart';
import 'income_form_view.dart';

class AddTransactionView extends StatefulWidget {
  static const String routeName = '/addTransaction';

  final List data;
  AddTransactionView({Key key, this.data}) : super(key: key);

  @override
  _AddTransactionViewState createState() => _AddTransactionViewState();
}

class _AddTransactionViewState extends State<AddTransactionView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Transaction')),
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: 43,
            backgroundColor: Colors.blue[400],
            elevation: 0,
            title: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.arrow_upward, color: Colors.red,)),
                Tab(icon: Icon(Icons.arrow_downward, color: Colors.green)),
              ],
              indicatorColor: Colors.white,
              indicatorWeight: 5,
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              ExpenseFormView(),
              IncomeFormView(),
            ],
          ),
        ),
      ),
    );
  }
  }
