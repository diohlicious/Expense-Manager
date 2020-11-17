
import 'package:expense_manager/widgets/form_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ExpenseFormView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            "Expense",
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
          toolbarHeight: 40,
          backgroundColor: Colors.blue[300],
        ),
        body: FormWidget(type: 'expense',),
    );
  }
}
