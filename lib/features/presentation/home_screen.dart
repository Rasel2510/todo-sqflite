import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/features/data/provider.dart';
import 'package:todo/features/presentation/details_screen.dart';
import 'package:todo/features/widget/add_todo.dart';

class HomeF extends StatefulWidget {
  const HomeF({super.key});

  @override
  State<HomeF> createState() => _HomeFState();
}

class _HomeFState extends State<HomeF> {
  // List of background colors to cycle through
  final List<Color> containerColors = [
    Colors.cyanAccent.shade100,
    Colors.orangeAccent.shade100,
    Colors.greenAccent.shade100,
    Colors.pinkAccent.shade100,
    Colors.purpleAccent.shade100,
    Colors.amberAccent.shade100,
    Colors.tealAccent.shade100,
    Colors.lightBlueAccent.shade100,
    Colors.limeAccent.shade100,
    Colors.deepOrangeAccent.shade100,
  ];

  @override
  void initState() {
    super.initState();

    // Load todos after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TodoProvider>(context, listen: false).loadTodos();
    });
  }

  // Determine text color based on background brightness
  Color getTextColor(Color bgColor) {
    return ThemeData.estimateBrightnessForColor(bgColor) == Brightness.dark
        ? Colors.white
        : Colors.black87;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Center(
          child: Text("TODO", style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
      body: Consumer<TodoProvider>(
        builder: (context, todoProvider, child) {
          // Loading state
          if (todoProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Empty state
          if (todoProvider.todos.isEmpty) {
            return const Center(
              child: Text(
                "No todos Yet",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          // List of todos
          return ListView.builder(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            itemCount: todoProvider.todos.length,
            itemBuilder: (context, index) {
              final item = todoProvider.todos[index];
              final containerColor =
                  containerColors[index % containerColors.length];
              final textColor = getTextColor(containerColor);

              return Dismissible(
                key: ValueKey(item.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  padding: const EdgeInsets.only(right: 20),
                  alignment: Alignment.centerRight,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                onDismissed: (_) async {
                  await todoProvider.deleteTodo(item.id);
                },
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailsScreen(
                          item: item,
                          containerColor:
                              containerColors[index % containerColors.length],
                        ),
                      ),
                    );
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [containerColor.withAlpha(60), containerColor],
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      title: Text(
                        item.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      subtitle: Text(
                        item.age,
                        style: TextStyle(color: textColor),
                      ),
                      // trailing: IconButton(
                      //   onPressed: () async {
                      //     await todoProvider.deleteTodo(item.id);
                      //   },
                      //   icon: Icon(Icons.remove, color: textColor),
                      // ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        foregroundColor: Colors.cyanAccent,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddTodo()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
