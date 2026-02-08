import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/features/model/add_todo_model.dart';
import 'package:todo/features/data/provider.dart';

class DetailsScreen extends StatefulWidget {
  final ModelClass item;
  final Color containerColor;

  const DetailsScreen({
    super.key,
    required this.item,
    required this.containerColor,
  });

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late TextEditingController nameController;
  late TextEditingController descController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.item.name);
    descController = TextEditingController(text: widget.item.age);
  }

  @override
  void dispose() {
    nameController.dispose();
    descController.dispose();
    super.dispose();
  }

  // Auto save on back
  Future<bool> _onWillPop() async {
    final provider = Provider.of<TodoProvider>(context, listen: false);

    widget.item.name = nameController.text;
    widget.item.age = descController.text;

    await provider.updateTodo(widget.item);

    return true;  
  }

  Color getTextColor(Color bgColor) {
    return ThemeData.estimateBrightnessForColor(bgColor) == Brightness.dark
        ? Colors.white
        : Colors.black87;
  }

  @override
  Widget build(BuildContext context) {
    final textColor = getTextColor(widget.containerColor);

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        _onWillPop();
      },
      canPop: true,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      widget.containerColor.withAlpha(60),
                      widget.containerColor,
                    ],
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: nameController,
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Title",
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: descController,
                        style: TextStyle(fontSize: 20, color: textColor),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Description",
                        ),
                        minLines: 3,
                        maxLines: 6,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
