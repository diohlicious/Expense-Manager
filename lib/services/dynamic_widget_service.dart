
import 'dart:convert';
import 'dart:core';

import 'package:expense_manager/network/network_endpoints.dart';
import 'package:http/http.dart' as http;

class DynamicWidgetService {
  dynamic data;

  Future<List> fetchWidget() async {

    var result = await http.get(NetworkEndpoints.BASE_URL+'/dynamictext');
    data = json.decode(result.body);
    return data;
  }
}
