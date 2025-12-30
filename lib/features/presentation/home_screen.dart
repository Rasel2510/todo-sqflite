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
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TodoProvider>(context, listen: false).loadTodos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.greenAccent,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.greenAccent,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("TODO", style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      body: Consumer<TodoProvider>(
        builder: (context, todoProvider, child) {
          // Show loading indicator
          if (todoProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Show empty state
          if (todoProvider.todos.isEmpty) {
            return const Center(
              child: Text(
                "No todos Yet",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          // Show todo list
          return ListView.builder(
            physics: BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            itemCount: todoProvider.todos.length,
            itemBuilder: (context, index) {
              final item = todoProvider.todos[index];
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
                        builder: (context) => DetailsScreen(item: item),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.cyanAccent, width: 2),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.white, Colors.white],
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white54,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      title: Text(
                        item.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(item.age),
                      trailing: IconButton(
                        onPressed: () async {
                          await todoProvider.deleteTodo(item.id);
                        },
                        icon: const Icon(Icons.remove, color: Colors.red),
                      ),
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
            MaterialPageRoute(builder: (_) => const Todo()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
