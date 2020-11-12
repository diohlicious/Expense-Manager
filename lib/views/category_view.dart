import 'package:expense_manager/models/category_db_model.dart';
import 'package:expense_manager/provider/category_bloc.dart';
import 'package:expense_manager/widgets/list_category_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryView extends StatefulWidget {
  static const String routeName = '/category';

  CategoryView({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _CategoryViewState createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  List<Map<String, dynamic>> data;
  final dbCat = CategoryDbModel.instance;
  Widget listCategory;

  TextEditingController categoryNameController = new TextEditingController();

  /*void _insert(String _catStr) async {
    // row to insert
    Map<String, dynamic> row = {CategoryDbModel.columnCat: _catStr};
    final id = await dbCat.insert(row);
    print('inserted row id: $id');
  }*/
  _addCategoryDialog(BuildContext context) async {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text('Cancel'),
      onPressed: () {
        Navigator.pop(context, 'false');
      },
    );
    Widget continueButton = FlatButton(
      child: Text('Save'),
      onPressed: () {
        Navigator.pop(context, categoryNameController.text);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text('Create Category'),
      content: TextField(
        controller: categoryNameController,
        decoration: InputDecoration(
          labelText: 'Category Name',
        ),
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    StatefulBuilder _builder = StatefulBuilder(
      builder: (context, setState) {
        return alert;
      },
    );

    // show the dialog
    final result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return _builder;
      },
    );
    if('$result' != 'false'){
      //_insert('$result');
      CategoryBloc().insert('$result');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CategoryBloc>.value(
      value: CategoryBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Category'),
        ),
        body: Container(
          child: ListCategory(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await _addCategoryDialog(context);
          },
          tooltip: 'Add Category',
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
