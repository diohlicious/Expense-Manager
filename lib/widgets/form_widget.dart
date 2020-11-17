import 'package:expense_manager/models/expense_db_model.dart';
import 'package:expense_manager/provider/expense_bloc.dart';
import 'package:expense_manager/views/category_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class FormWidget extends StatefulWidget {
  const FormWidget({this.data, this.type});

  final List data;
  final String type;

  @override
  _FormWidgetState createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  final dbExpense = ExpenseDbModel.instance;
  var _txtCat = TextEditingController();
  var _txtDate = TextEditingController();
  var _txtAmt = TextEditingController();
  var _txtDesc = TextEditingController();
  DateTime selectedDate = DateTime.now();
  String storedDate;
  DateTime now = DateTime.now();
  bool _validate = false;

  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    this._validation();
    super.dispose();
  }

  void _insert(String _dateStr, String _catStr, String _amtStr, String _descStr, String _typeStr, String _createStr ) async {
    // row to insert
    Map<String, dynamic> row = {ExpenseDbModel.columnTransDate: _dateStr,
      ExpenseDbModel.columnCategory: _catStr,
      ExpenseDbModel.columnAmount: _amtStr,
      ExpenseDbModel.columnDescription: _descStr,
      ExpenseDbModel.columnType: _typeStr,
      ExpenseDbModel.columnCreateDate: _createStr,};
    final id = await dbExpense.insert(row);
    print('inserted row id: $id');
  }

  void _validation(){
    setState(() {
      _txtDate.text.isEmpty ? _validate = true : _validate = false;
      _txtCat.text.isEmpty ? _validate = true : _validate = false;
      _txtAmt.text.isEmpty ? _validate = true : _validate = false;
      _txtDesc.text.isEmpty ? _validate = true : _validate = false;
    });
    DateTime _dateTime= new DateTime.now();
    if (!_validate){
      _insert(storedDate,_txtCat.text,_txtAmt.text,_txtDesc.text,widget.type,_dateTime.toIso8601String());
      //final ExpenseBloc expenseBloc = Provider.of<ExpenseBloc>(context, listen: false);
      //expenseBloc.fetchWidget();
      return Navigator.pop(context, 'true');
    }
  }

  void _selectDate() async {
    FocusScope.of(context).requestFocus(new FocusNode());
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(now.year, now.month),
        lastDate: DateTime(now.year, now.month + 3, now.day + 30 - now.day));
    if (picked != null && picked != selectedDate)
      setState(() {
        String formattedDate = DateFormat('d MMM yyyy').format(picked);
        print(picked);
        _txtDate.text = formattedDate;
        storedDate = picked.toIso8601String();
      });
  }

  void _selectCategory() async {
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
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(5, 20, 5, 0),
        height: 510,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 3,
              ),
              TextFormField(
                controller: _txtDate,
                decoration: InputDecoration(
                    labelText: 'Transaction Date',
                    border: OutlineInputBorder(),
                  errorText: _validate ? 'Value Can\'t Be Empty' : null,),
                onTap: _selectDate,
              ),
              SizedBox(
                height: 25,
              ),
              TextFormField(
                controller: _txtCat,
                decoration: InputDecoration(
                    labelText: 'Select Category', border: OutlineInputBorder(),
                  errorText: _validate ? 'Value Can\'t Be Empty' : null,),
                onTap: _selectCategory,
              ),
              SizedBox(
                height: 25,
              ),
              TextFormField(
                controller: _txtAmt,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: 'Amount', border: OutlineInputBorder(),
                  errorText: _validate ? 'Value Can\'t Be Empty' : null,),
              ),
              SizedBox(
                height: 25,
              ),
              TextFormField(
                controller: _txtDesc,
                decoration: InputDecoration(
                    labelText: 'Description', border: OutlineInputBorder(),
                  errorText: _validate ? 'Value Can\'t Be Empty' : null,),
              ),
              SizedBox(
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: Visibility(
                      child: RaisedButton(
                        animationDuration: Duration(seconds: 2),
                        textColor: Colors.white,
                        color: Colors.red,
                        elevation: 10.0,
                        splashColor: Colors.white70,
                        onPressed: null,
                        child: Text(
                          'Delete',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                      maintainSize: false,
                      maintainAnimation: true,
                      maintainState: true,
                      visible: true,
                    ),
                  ),
                  SizedBox(width: 6),
                  Expanded(
                    child: RaisedButton(
                      animationDuration: Duration(seconds: 2),
                      textColor: Colors.white,
                      color: Colors.blue,
                      elevation: 10.0,
                      splashColor: Colors.white70,
                      onPressed: _validation,
                      child: Text(
                        'Save',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                  SizedBox(width: 6),
                ],
              ),
            ],
          ),
        ));
  }
}
