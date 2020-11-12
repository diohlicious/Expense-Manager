import 'package:expense_manager/app/route.dart';
import 'package:expense_manager/provider/expense_bloc.dart';
import 'package:expense_manager/views/home_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpenseManagerApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ExpenseBloc>.value(
        value: ExpenseBloc(),
        child: MaterialApp(
          title: 'Expense Manager',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: HomeView(title: 'Expense Manager'),
          onGenerateRoute: Routes.generateRoute,
        ));
  }
}
