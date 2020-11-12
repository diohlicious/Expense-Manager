import 'package:expense_manager/widgets/form_widget.dart';
import 'package:flutter/material.dart';

class IncomeFormView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            "Income",
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
          toolbarHeight: 40,
          backgroundColor: Colors.blue[300],
        ),
        body: FormWidget(type: 'income',));
  }
}
