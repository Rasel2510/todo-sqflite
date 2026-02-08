import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/features/model/add_todo_model.dart';
import 'package:todo/features/data/provider.dart';

class AddTodo extends StatefulWidget {
  final ModelClass? item;
  final Color? containerColor;
  const AddTodo({super.key, this.item, this.containerColor});

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  late TextEditingController todoController;
  late Color containerColor;

  @override
  void initState() {
    super.initState();
    todoController = TextEditingController(
      text: widget.item != null ? widget.item!.name : '',
    );
    containerColor =
        widget.containerColor ??
        Colors.primaries[DateTime.now().millisecondsSinceEpoch %
            Colors.primaries.length];
  }

  @override
  void dispose() {
    todoController.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    final provider = Provider.of<TodoProvider>(context, listen: false);

    if (todoController.text.trim().isEmpty) {
      // Don't save empty todo
      return true;
    }

    if (widget.item != null) {
      // Update existing todo
      await provider.updateTodo(
        ModelClass(
          id: widget.item!.id,
          name: todoController.text,
          age: widget.item!.age,
        ),
      );
    } else {
      // Add new todo
      await provider.addTodo(
        ModelClass(
          id: DateTime.now().millisecondsSinceEpoch,
          name: todoController.text,
          age: '',
        ),
      );
    }

    return true; // allow back navigation
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        _onWillPop();
      },
      canPop: true,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [containerColor.withAlpha(50), containerColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: TextField(
                controller: todoController,
                autofocus: true,
                maxLines: null,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color:
                      ThemeData.estimateBrightnessForColor(containerColor) ==
                          Brightness.dark
                      ? Colors.white
                      : Colors.black87,
                ),
                decoration: const InputDecoration(
                  hintText: 'add note here...',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
