import 'package:expense_manager/models/category_db_model.dart';
import 'package:expense_manager/models/category_model.dart';
import 'package:flutter/foundation.dart';

class CategoryBloc extends ChangeNotifier {
  //-------------------------------------------------------------query data
  final dbCat = CategoryDbModel.instance;
  List<CategoryModel> _category;
  List<CategoryModel> get listCategory => _category;

  set listCategory(List<CategoryModel> val) {
    _category = val;
    notifyListeners();
  }

  Future<List<CategoryModel>> fetchData() async {
    final allRows = await dbCat.queryAllRows();
     List<CategoryModel> data = List<CategoryModel>.from(allRows.map((e) => CategoryModel.fromJson(e)));
     listCategory = data;
     //print(listCategory.toString());
     return listCategory;
  }
  //-------------------------------------------------------------insert data
  //String _categoryName;
  //String get categoryName => _categoryName;
  /*String get getDisplayText => _categoryName;
  void setCategoryText(String text) {
    _categoryName = text;
    notifyListeners();
  }*/
  void insert(String _catStr) async {
    // row to insert
    Map<String, dynamic> row = {CategoryDbModel.columnCat: _catStr};
    final id = await dbCat.insert(row);
    print('inserted row id: $id');
  }





}
