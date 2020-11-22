import 'package:expense_manager/models/category_db_model.dart';
import 'package:expense_manager/models/category_model.dart';
import 'package:expense_manager/provider/category_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListCategory extends StatelessWidget {
  final dbCat = CategoryDbModel.instance;

  void _delete(int _id) async {
    // Assuming that the number of rows is the id for the last row.
    //final id = await dbCat.queryRowCount();
    final rowDeleted = await dbCat.delete(_id);
    print('deleted $rowDeleted row(s): row $_id');
  }

  _deleteCategoryDialog(BuildContext context, int _int) async {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text('Cancel'),
      onPressed: () {
        Navigator.pop(context, false);
      },
    );
    Widget continueButton = FlatButton(
      child: Text('Delete'),
      onPressed: () {
        Navigator.pop(context, true);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text('Warning'),
      content: Row(
        children: [
          Icon(
            CupertinoIcons.exclamationmark_triangle,
            color: Colors.red,
          ),
          Container(
              margin: EdgeInsets.only(left: 18),
              width: MediaQuery.of(context).size.width * 0.5,
              child: Text('Are you sure want to delete this item? '))
        ],
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    final result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
    print('$result');
    if ('$result' == 'true') {
      _delete(_int);
    }
  }

  /*
  * Navigator.pop(context, 'Yep!');*/

  @override
  Widget build(BuildContext context) {
    final CategoryBloc categoryBloc = Provider.of<CategoryBloc>(context);
    categoryBloc.fetchData();
    return Selector<CategoryBloc, List<CategoryModel>>(
      selector: (_, fetchData) => fetchData.listCategory,
      builder: (_, listCategory, __) {
        return Container(
          child: categoryBloc.listCategory == null
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  itemCount: categoryBloc.listCategory.length,
                  itemBuilder: (BuildContext context, int index) {
                    final CategoryModel data = categoryBloc.listCategory[index];
                    return Card(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context, data.category);
                        },
                        child: Container(
                          padding: EdgeInsets.all(18),
                          child: Row(children: [
                            Expanded(
                              flex: 7,
                              child: Text(
                                data.category,
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: GestureDetector(
                                child: Icon(CupertinoIcons.trash),
                                onTap: () {
                                  _deleteCategoryDialog(
                                      context, data.idCategory);
                                },
                              ),
                            ),
                          ]),
                        ),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
