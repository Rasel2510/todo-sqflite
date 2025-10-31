import 'package:flutter/material.dart';
import 'package:todo/model/model_class.dart';
import 'package:todo/servise/db_helper.dart';
import 'package:todo/ui/todo.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final DbHelper dbHelper = DbHelper();

  List<ModelClass> items = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    final data = await dbHelper.readData();
    setState(() {
      items = data;
    });
  }

  Future<void> deleteitem(int id) async {
    await dbHelper.deleteData(id);
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return ListTile(
            title: Text(item.name),
            subtitle: Text(item.age.toString()),
            trailing: IconButton(
              onPressed: () {
                dbHelper.deleteData(item.id);
              },
              icon: Icon(Icons.delete, color: Colors.red[300]),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red[200],
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => Todo()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
