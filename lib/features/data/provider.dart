import 'package:flutter/material.dart';
import 'package:todo/features/model/add_todo_model.dart';
import 'package:todo/features/data/db_helper.dart';

class TodoProvider with ChangeNotifier {
  final DbHelper _dbHelper = DbHelper();

  List<ModelClass> _todos = [];
  List<ModelClass> get todos => _todos;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Load all todos from database
  Future<void> loadTodos() async {
    _isLoading = true;
    notifyListeners();

    try {
      _todos = await _dbHelper.readData();
    } catch (e) {
      debugPrint('Error loading todos: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add a new todo
  Future<void> addTodo(ModelClass todo) async {
    try {
      await _dbHelper.insertData(todo);
      await loadTodos();
    } catch (e) {
      debugPrint('Error adding todo: $e');
    }
  }

  // Delete a todo by id
  Future<void> deleteTodo(int id) async {
    try {
      await _dbHelper.deleteData(id);
      await loadTodos();
    } catch (e) {
      debugPrint('Error deleting todo: $e');
    }
  }
}
