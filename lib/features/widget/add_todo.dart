// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:todo/features/model/add_todo_model.dart';
// import 'package:todo/features/data/db_helper.dart';
// import 'package:todo/features/data/provider.dart';
// import 'package:todo/features/widget/textformfild.dart';

// class Todo extends StatefulWidget {
//   const Todo({super.key});

//   @override
//   State<Todo> createState() => _TodoState();
// }

// class _TodoState extends State<Todo> {
//   final name = TextEditingController();
//   final ageint = TextEditingController();
//   final DbHelper dbHelper = DbHelper();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.greenAccent,
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               CustomTextField(controller: name, hintText: "Titel"),
//               const SizedBox(height: 20),

//               CustomTextField(
//                 controller: ageint,
//                 hintText: 'Description',
//                 minLines: 3,
//                 maxLines: 5,
//               ),

//               const SizedBox(height: 20),

//               Row(
//                 children: [
//                   Expanded(
//                     child: SizedBox(
//                       height: 50,
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.red[200],
//                         ),
//                         onPressed: () {
//                           name.clear();
//                           ageint.clear();
//                           Navigator.pop(context);
//                         },
//                         child: const Text('Cancel'),
//                       ),
//                     ),
//                   ),

//                   const SizedBox(width: 20),

//                   Expanded(
//                     child: SizedBox(
//                       height: 50,
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.green[200],
//                         ),
//                         onPressed: () async {
//                           //   Validation
//                           if (name.text.isEmpty || ageint.text.isEmpty) {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(
//                                 content: Text(
//                                   'Filed the form',
//                                   style: TextStyle(fontWeight: FontWeight.bold),
//                                 ),
//                                 backgroundColor: Color.fromARGB(
//                                   129,
//                                   255,
//                                   82,
//                                   82,
//                                 ),
//                                 duration: Duration(milliseconds: 1000),
//                                 behavior: SnackBarBehavior.floating,
//                               ),
//                             );
//                             return;
//                           }
//                           final todoProvider = Provider.of<TodoProvider>(
//                             context,
//                             listen: false,
//                           );
//                           await todoProvider.addTodo(
//                             ModelClass(
//                               id: DateTime.now().millisecondsSinceEpoch,
//                               name: name.text,
//                               age: ageint.text,
//                             ),
//                           );

//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                               content: Text(
//                                 'successfully added TODO',
//                                 style: TextStyle(fontWeight: FontWeight.bold),
//                               ),
//                               backgroundColor: Color.fromARGB(168, 18, 214, 25),
//                               behavior: SnackBarBehavior.floating,
//                               duration: Duration(milliseconds: 1000),
//                               elevation: 6,
//                             ),
//                           );

//                           name.clear();
//                           ageint.clear();

//                           Navigator.pop(context);
//                         },
//                         child: const Text('Submit'),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/features/data/provider.dart';
import 'package:todo/features/model/add_todo_model.dart';
import 'package:todo/features/widget/textformfild.dart';

class AddTodoSheetDynamic extends StatefulWidget {
  const AddTodoSheetDynamic({super.key});

  @override
  State<AddTodoSheetDynamic> createState() => _AddTodoSheetDynamicState();
}

class _AddTodoSheetDynamicState extends State<AddTodoSheetDynamic> {
  final nameController = TextEditingController();
  final descController = TextEditingController();

  final List<Color> containerColors = [
    Colors.cyanAccent,
    Colors.orangeAccent,
    Colors.greenAccent,
    Colors.pinkAccent,
    Colors.purpleAccent,
    Colors.amberAccent,
    Colors.tealAccent,
    Colors.lightBlueAccent,
    Colors.limeAccent,
    Colors.deepOrangeAccent,
  ];

  Color getTextColor(Color bgColor) {
    return ThemeData.estimateBrightnessForColor(bgColor) == Brightness.dark
        ? Colors.white
        : Colors.black87;
  }

  @override
  Widget build(BuildContext context) {
    // pick a dynamic color based on current timestamp
    final containerColor =
        containerColors[DateTime.now().millisecondsSinceEpoch %
            containerColors.length];
    final textColor = getTextColor(containerColor);

    return Padding(
      padding: MediaQuery.of(context).viewInsets, // safe area for keyboard
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          gradient: LinearGradient(
            colors: [containerColor.withAlpha(80), containerColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Add New Todo",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: nameController,
                hintText: "Title",
                textColor: textColor,
                fillColor: Colors.white,
                minLines: 1,
              ),
              const SizedBox(height: 15),
              CustomTextField(
                controller: descController,
                hintText: "Description",
                textColor: textColor,
                fillColor: Colors.white,
                minLines: 3,
                maxLines: 5,
              ),
              const SizedBox(height: 25),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context); // close sheet
                      },
                      child: const Text("Cancel"),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.greenAccent.shade400,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        if (nameController.text.isEmpty ||
                            descController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please fill all fields"),
                              backgroundColor: Colors.redAccent,
                              duration: Duration(seconds: 1),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                          return;
                        }

                        final provider = Provider.of<TodoProvider>(
                          context,
                          listen: false,
                        );
                        await provider.addTodo(
                          ModelClass(
                            id: DateTime.now().millisecondsSinceEpoch,
                            name: nameController.text,
                            age: descController.text,
                          ),
                        );

                        Navigator.pop(context); // close sheet
                      },
                      child: const Text("Submit"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
