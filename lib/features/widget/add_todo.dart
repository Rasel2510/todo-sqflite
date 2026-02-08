// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:todo/features/model/add_todo_model.dart';
// import 'package:todo/features/data/provider.dart';

// class AddTodo extends StatefulWidget {
//   final ModelClass? item;
//   final Color? containerColor;
//   const AddTodo({super.key, this.item, this.containerColor});

//   @override
//   State<AddTodo> createState() => _AddTodoState();
// }

// class _AddTodoState extends State<AddTodo> {
//   late TextEditingController todoController;
//   late TextEditingController todoControllerdis;
//   late Color containerColor;

//   @override
//   void initState() {
//     super.initState();
//     todoController = TextEditingController(
//       text: widget.item != null ? widget.item!.name : '',
//     );
//     containerColor =
//         widget.containerColor ??
//         Colors.primaries[DateTime.now().millisecondsSinceEpoch %
//             Colors.primaries.length];
//   }

//   @override
//   void dispose() {
//     _onWillPop();
//     todoController.dispose();
//     super.dispose();
//   }

//   Future<bool> _onWillPop() async {
//     final provider = Provider.of<TodoProvider>(context, listen: false);

//     if (todoController.text.trim().isEmpty) {
//       // Don't save empty todo
//       return true;
//     }

//     if (widget.item != null) {
//       // Update existing todo
//       await provider.updateTodo(
//         ModelClass(
//           id: widget.item!.id,
//           name: todoController.text,
//           age: widget.item!.age,
//         ),
//       );
//     } else {
//       // Add new todo
//       await provider.addTodo(
//         ModelClass(
//           id: DateTime.now().millisecondsSinceEpoch,
//           name: todoController.text,
//           age: todoControllerdis.text,
//         ),
//       );
//     }

//     return true; // allow back navigation
//   }

//   @override
//   Widget build(BuildContext context) {
//     return PopScope(
//       onPopInvokedWithResult: (didPop, result) {
//         _onWillPop();
//       },
//       canPop: true,
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         body: SafeArea(
//           child: GestureDetector(
//             onTap: () => FocusScope.of(context).unfocus(),
//             child: Container(
//               width: double.infinity,
//               height: double.infinity,
//               padding: const EdgeInsets.all(24),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [containerColor.withAlpha(50), containerColor],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//               ),
//               child: TextField(
//                 controller: todoController,
//                 autofocus: true,
//                 maxLines: null,
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.w500,
//                   color:
//                       ThemeData.estimateBrightnessForColor(containerColor) ==
//                           Brightness.dark
//                       ? Colors.white
//                       : Colors.black87,
//                 ),
//                 decoration: const InputDecoration(
//                   hintText: 'add note here...',
//                   border: InputBorder.none,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
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
    _saveTodo(); // ✅ SAVE FIRST
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
