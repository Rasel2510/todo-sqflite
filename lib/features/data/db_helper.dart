import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:todo/features/model/add_todo_model.dart';

class DbHelper {
  Database? _database;

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }
    // find path and create table
    Directory directory = await getApplicationDocumentsDirectory();

    String path = join(directory.path, 'mydatabase.db');

    // open  db file and create table
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
    CREATE TABLE DatabaseTable (
      id INTEGER PRIMARY KEY,
      name TEXT,
      age TEXT
    )
  ''');
      },
    );
    return _database!;
  }
  // insert data to table

  Future<void> insertData(ModelClass modelClass) async {
    final db = await database;
    await db!.insert('DatabaseTable', modelClass.toMap());
  }

  //read data
  Future<List<ModelClass>> readData() async {
    Database? db = await database;
    final List<Map<String, dynamic>> result = await db!.query('DatabaseTable');
    return result.map((e) => ModelClass.fromMap(e)).toList();
  }

  //deleate data
  Future<int> deleteData(int id) async {
    final db = await database;
    return await db!.delete('DatabaseTable', where: 'id = ?', whereArgs: [id]);
  }
}
