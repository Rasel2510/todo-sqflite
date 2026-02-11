import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  // List of background colors
  final List<Color> containerColors = [
    Colors.pinkAccent.shade100,
    Colors.cyanAccent.shade100,
    Colors.orangeAccent.shade100,
    Colors.greenAccent.shade100,
    Colors.purpleAccent.shade100,
    Colors.amberAccent.shade100,
    Colors.tealAccent.shade100,
    Colors.lightBlueAccent.shade100,
    Colors.limeAccent.shade100,
    Colors.deepOrangeAccent.shade100,
    Colors.indigoAccent.shade100,
    Colors.redAccent.shade100,
    Colors.yellowAccent.shade100,
    Colors.blueAccent.shade100,
    Colors.deepPurpleAccent.shade100,
    Colors.lightGreenAccent.shade100,
  ];

  // Timer? _timer;
  // int _tick = 0;

  // Color randomColor() {
  //   final random = Random(_tick);
  //   int r = 150 + random.nextInt(106);
  //   int g = 150 + random.nextInt(106);
  //   int b = 150 + random.nextInt(106);
  //   return Color.fromARGB(255, r, g, b);
  // }

  @override
  void initState() {
    super.initState();
    // _timer?.cancel();
    // _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
    //   setState(() {
    //     _tick++;
    //   });
    // });
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

  String getDisplayDate(String createdAt) {
    try {
      DateTime dt = DateFormat("MMM d, yyyy hh:mm a").parse(createdAt);

      DateTime now = DateTime.now();
      if (dt.year == now.year && dt.month == now.month && dt.day == now.day) {
        return DateFormat("hh:mm a").format(dt);
      } else {
        return DateFormat("MMM d, yyyy").format(dt);
      }
    } catch (e) {
      return createdAt;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Center(
          child: Text("NOTES", style: TextStyle(fontWeight: FontWeight.bold)),
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
          final todos = [...todoProvider.todos];
          todos.sort((a, b) => b.id.compareTo(a.id));

          // List of todos
          return ListView.builder(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final item = todos[index];
              final containerColor =
                  containerColors[index % containerColors.length];
              // final containerColor = getRandomPastelColor();

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
                    width: double.infinity,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ListTile(
                        //   title: Text(
                        //     item.name,
                        //     maxLines: 1,
                        //     style: TextStyle(
                        //       fontWeight: FontWeight.bold,
                        //       color: textColor,
                        //     ),
                        //   ),
                        //   subtitle: Text(
                        //     item.age,
                        //     maxLines: 2,
                        //     style: TextStyle(color: textColor),
                        //   ),

                        //   // trailing: IconButton(
                        //   //   onPressed: () async {
                        //   //     await todoProvider.deleteTodo(item.id);
                        //   //   },
                        //   //   icon: Icon(Icons.remove, color: textColor),
                        //   // ),
                        // ),
                        Text(
                          item.name,
                          maxLines: 1,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          item.age,
                          maxLines: 2,
                          style: TextStyle(color: textColor),
                        ),
                        SizedBox(height: 4),
                        Text(
                          getDisplayDate(item.createdAt),
                          style: TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,

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
