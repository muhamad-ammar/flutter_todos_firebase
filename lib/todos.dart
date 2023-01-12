import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class todos extends StatefulWidget {
  const todos({super.key});

  @override
  State<todos> createState() => _todosState();
}

class _todosState extends State<todos> {
  List todos = [];
  String input = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    todos.add("item1");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Center(
        child: Text('Todo_list'),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Add Todo'),
                  content: TextField(
                    onChanged: (String value) {
                      input = value;
                    },
                  ),
                  actions: <Widget>[
                    FloatingActionButton(
                      onPressed: () {
                        setState(() {
                          todos.add(input);
                        });
                        Navigator.of(context).pop();
                      },
                      child: Text("Add"),
                    )
                  ],
                );
              });
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: ListView.builder(
          itemCount: todos.length,
          itemBuilder: (BuildContext context, int index) {
            {
              return Dismissible(
                  key: Key(todos[index]),
                  child: Card(
                    child: ListTile(
                      title: Text(todos[index]),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          setState(() {
                            todos.removeAt(index);
                          });
                        },
                      ),
                    ),
                  ));
            }
          }),
    );
  }
}
