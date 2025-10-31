import 'package:flutter/material.dart';
import 'package:todo/model/model_class.dart';
import 'package:todo/servise/db_helper.dart';

class TodoProvider with ChangeNotifier {
  List<ModelClass> _list = [];

  List<ModelClass> get list => _list;

  Future<void> loadData() async {
    _list = await DbHelper().readData();
    notifyListeners();
  }

  Future<void> addData(ModelClass model) async {
    await DbHelper().insertData(model);
    await loadData();
  }

  Future<void> removeData(int id) async {
    await DbHelper().deleteData(id);
    await loadData();
  }
}
