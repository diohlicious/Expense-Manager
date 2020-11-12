
import 'package:expense_manager/views/add_transaction_view.dart';
import 'package:expense_manager/views/category_view.dart';
import 'package:expense_manager/views/home_view.dart';
import 'package:flutter/material.dart';



class Routes {
  static const String home = HomeView.routeName;
  static const String addTransaction = HomeView.routeName;


  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => HomeView());
      case addTransaction:
        return MaterialPageRoute(builder: (_) => AddTransactionView());
      case addTransaction:
        return MaterialPageRoute(builder: (_) => CategoryView());
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
              body: Center(
                  child: Text('No route defined for ${settings.name}')),
            ));
    }
  }

//OpenContainerBuilder

}
