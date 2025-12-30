import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/features/model/add_todo_model.dart';
import 'package:todo/features/data/db_helper.dart';
import 'package:todo/features/data/provider.dart';
import 'package:todo/features/widget/textformfild.dart';

class Todo extends StatefulWidget {
  const Todo({super.key});

  @override
  State<Todo> createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  final name = TextEditingController();
  final ageint = TextEditingController();
  final DbHelper dbHelper = DbHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.greenAccent,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextField(controller: name, hintText: "Titel"),
              const SizedBox(height: 20),

              CustomTextField(
                controller: ageint,
                hintText: 'Description',
                minLines: 3,
                maxLines: 5,
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[200],
                        ),
                        onPressed: () {
                          name.clear();
                          ageint.clear();
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel'),
                      ),
                    ),
                  ),

                  const SizedBox(width: 20),

                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[200],
                        ),
                        onPressed: () async {
                          //   Validation
                          if (name.text.isEmpty || ageint.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Filed the form',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                backgroundColor: Color.fromARGB(
                                  129,
                                  255,
                                  82,
                                  82,
                                ),
                                duration: Duration(milliseconds: 1000),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                            return;
                          }
                          final todoProvider = Provider.of<TodoProvider>(
                            context,
                            listen: false,
                          );
                          await todoProvider.addTodo(
                            ModelClass(
                              id: DateTime.now().millisecondsSinceEpoch,
                              name: name.text,
                              age: ageint.text,
                            ),
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'successfully added TODO',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              backgroundColor: Color.fromARGB(168, 18, 214, 25),
                              behavior: SnackBarBehavior.floating,
                              duration: Duration(milliseconds: 1000),
                              elevation: 6,
                            ),
                          );

                          name.clear();
                          ageint.clear();

                          Navigator.pop(context);
                        },
                        child: const Text('Submit'),
                      ),
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
