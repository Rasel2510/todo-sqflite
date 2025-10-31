import 'package:flutter/material.dart';
import 'package:todo/model/model_class.dart';
import 'package:todo/servise/db_helper.dart';
import 'package:todo/ui/todo.dart';

class HomeF extends StatelessWidget {
  final DbHelper dbHelper = DbHelper();
  HomeF({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.menu),
            Text("TODO", style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FutureBuilder<List<ModelClass>>(
          future: dbHelper.readData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('error${snapshot.error}'));
            }
            if (snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text("Empty data"));
            }
            final items = snapshot.data!;
            return ListView.builder(
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  title: Text(item.name),
                  subtitle: Text(item.age),
                  trailing: IconButton(
                    onPressed: () async {
                      await dbHelper.deleteData(item.id);
                    },
                    icon: Icon(Icons.remove),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red[200],
        foregroundColor: Colors.white,

        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => Todo()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
