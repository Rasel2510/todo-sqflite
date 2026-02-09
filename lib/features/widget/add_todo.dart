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
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late Color containerColor;

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(text: widget.item?.name ?? '');
    descriptionController = TextEditingController(text: widget.item?.age ?? '');

    containerColor =
        widget.containerColor ??
        Colors.primaries[DateTime.now().millisecondsSinceEpoch %
            Colors.primaries.length];
  }

  //SAVE TO-DO
  Future<void> _saveTodo() async {
    final provider = Provider.of<TodoProvider>(context, listen: false);

    if (titleController.text.trim().isEmpty &&
        descriptionController.text.trim().isEmpty) {
      return;
    }

    if (widget.item != null) {
      await provider.updateTodo(
        ModelClass(
          id: widget.item!.id,
          name: titleController.text,
          age: descriptionController.text,
        ),
      );
    } else {
      await provider.addTodo(
        ModelClass(
          id: DateTime.now().millisecondsSinceEpoch,
          name: titleController.text,
          age: descriptionController.text,
        ),
      );
    }
  }

  @override
  void dispose() {
    _saveTodo();
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textColor =
        ThemeData.estimateBrightnessForColor(containerColor) == Brightness.dark
        ? Colors.white
        : Colors.black87;

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        _saveTodo(); // save on back
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.chevron_left, size: 30),
              ),
              IconButton(
                icon: const Icon(Icons.save_outlined),
                onPressed: () async {
                  FocusScope.of(context).unfocus();
                  await _saveTodo();

                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              _saveTodo();
            },
            child: Container(
              width: double.infinity,
              height: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [containerColor.withAlpha(60), containerColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TITLE
                  TextField(
                    controller: titleController,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Title',
                      border: InputBorder.none,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // DESCRIPTION
                  Expanded(
                    child: TextField(
                      controller: descriptionController,
                      maxLines: null,
                      style: TextStyle(fontSize: 18, color: textColor),
                      decoration: const InputDecoration(
                        hintText: 'Write your note...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
