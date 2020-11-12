import 'dart:convert';

List<ExpenseModel> expenseModelFromJson(String str) => List<ExpenseModel>.from(
    json.decode(str).map((x) => ExpenseModel.fromJson(x)));

String expenseModelToJson(List<ExpenseModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ExpenseModel {
  int id;
  String transDate;
  String category;
  int amt;
  String description;
  String type;

  ExpenseModel(
      {this.id,
      this.transDate,
      this.category,
      this.amt,
      this.description,
      this.type});

  factory ExpenseModel.fromJson(Map<String, dynamic> json) => ExpenseModel(
        id: json["_id"],
        transDate: json["_transDate"],
        category: json["_category"],
        amt: json["_amt"],
        description: json["_description"],
        type: json["_type"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "_transDate": transDate,
        "_category": category,
        "_amt": amt,
        "_description": description,
        "_type": type,
      };
}
