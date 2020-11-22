import 'dart:convert';

import 'package:expense_manager/app/ad_manager.dart';
import 'package:expense_manager/app/initdb.dart';
import 'package:expense_manager/models/expense_db_model.dart';
import 'package:expense_manager/models/expense_model.dart';
import 'package:expense_manager/network/network_endpoints.dart';
import 'package:expense_manager/repositories/function.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ExpenseBloc extends ChangeNotifier {
  final initDb = InitDb.instance;
  final dbExpense = ExpenseDbModel.instance;

  List<ExpenseModel> _expense;
  List<ExpenseModel> get listExpense => _expense;
  set listExpense(List<ExpenseModel> val) {
    _expense = val;
    notifyListeners();
  }

  String _jsonString;
  String get jsonString => _jsonString;
  set jsonString(String val) {
    _jsonString = val;
    notifyListeners();
  }

  BannerAd _homeBanner;
  BannerAd get homeBanner => _homeBanner;
  set homeBanner(BannerAd val){
    _homeBanner =val;
    notifyListeners();
  }

  Future<String> fetchWidget() async {
    final prin = await initDb.initdb();
    print(prin);
    final _expense = await dbExpense.sum('expense') ?? 0;
    final _income = await dbExpense.sum('income') ?? 0;
    int amt = _income - _expense;
    String balance = 'Balance: Rp. ' + amt.toString();

    var result = await http.get(NetworkEndpoints.BASE_URL + '/dynamictext');
    List dynWidget = await json.decode(result.body);
    Map<String, dynamic> _style = new Map();
    _style.addAll({
      'color': dynWidget[0]['color'],
      'fontSize': dynWidget[0]['fontSize'],
      'fontWeight': dynWidget[0]['fontWeight']
    });
    //, 'style': _style
    Map<String, dynamic> _jsonWidget = new Map();
    _jsonWidget.addAll({'type': 'Text', 'data': balance, 'style': _style});
    jsonString = jsonEncode(_jsonWidget);
    print(jsonString);
    return jsonString;
  }

  Future<List<ExpenseModel>> fetchData() async {
    final allRows = await dbExpense.queryAllRows();
    //List data = List<Map<String,dynamic>>.from(allRows);
    List<ExpenseModel> data = List<ExpenseModel>.from(
        allRows.map((e) => ExpenseModel.fromJson(e)));
    data.sort((a, b) {
      //return b['_transDate'].compareTo(a['_transDate']);
      return b.transDate.compareTo(a.transDate);
    });
    data.sort((a, b) {
      //return b['_transDate'].compareTo(a['_transDate']);
      return b.createDate.compareTo(a.createDate);
    });
    listExpense = data;
    return listExpense;
  }

  Future<void> buildBannerAd(double mediaQuery, String string) async{
    // TODO: Initialize AdMob SDK
    //AdManager.appId
    if(FunctionRepo.equalsIgnoreCase(string, 'large')){
      //FirebaseAdMob.instance.initialize(appId: FirebaseAdMob.testAppId);
      homeBanner = BannerAd(
          //adUnitId: BannerAd.testAdUnitId,
          adUnitId: BannerAd.testAdUnitId,
          size: AdSize.largeBanner,
          listener: (MobileAdEvent event) {
            if (event == MobileAdEvent.loaded) {
              homeBanner
                ..show(
                    anchorType: AnchorType.top,
                    anchorOffset: mediaQuery);//MediaQuery.of(context).size.height * 0.15);
            }
          });
    } else if (FunctionRepo.equalsIgnoreCase(string, 'small')){
      FirebaseAdMob.instance.initialize(appId: AdManager.appId);
      homeBanner = BannerAd(
          adUnitId: AdManager.bannerAdUnitId,
          //adUnitId: BannerAd.testAdUnitId,
          size: AdSize.banner,
          listener: (MobileAdEvent event) {
            if (event == MobileAdEvent.loaded) {
              homeBanner..show();
            }
          });
    }

    return homeBanner;
  }
}
