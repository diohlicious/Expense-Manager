import 'package:animations/animations.dart';
import 'package:expense_manager/provider/expense_bloc.dart';
import 'package:expense_manager/repositories/function.dart';
import 'package:dynamic_widget/dynamic_widget.dart';
import 'package:expense_manager/views/add_transaction_view.dart';
import 'package:expense_manager/widgets/home_list_widget.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

const double _fabDimension = 56.0;

class HomeView extends StatelessWidget {
  static const String routeName = '/home';

  HomeView({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    ContainerTransitionType _transitionType = ContainerTransitionType.fade;
    final ExpenseBloc expenseBloc =
        Provider.of<ExpenseBloc>(context, listen: false);
    expenseBloc.fetchWidget();
    expenseBloc.buildBannerAd(MediaQuery.of(context).size.height * 0.15, 'small');
    expenseBloc.homeBanner..load();
    //final String jsonString = expenseBloc.jsonString;
    //print('ok'+expenseBloc.jsonString) ;
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      bottomSheet: Padding(padding: EdgeInsets.only(bottom: 100.0)),
      body: Selector<ExpenseBloc, String>(
          selector: (_, fetchWidget) => fetchWidget.jsonString,
          builder: (_, jsonString, __) {
            return Container(
              //margin: EdgeInsets.fromLTRB(0, 120, 0, 0),
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
      floatingActionButton: /*OpenContainer(
        transitionType: _transitionType,
        openBuilder: (BuildContext context, VoidCallback _) {
          expenseBloc.homeBanner..load();
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
      ),*/
      FloatingActionButton(
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
