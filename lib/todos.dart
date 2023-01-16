import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class Todos extends StatefulWidget {
  const Todos({super.key});

  @override
  State<Todos> createState() => _TodosState();
}

class _TodosState extends State<Todos> {
  String input = '';

  createTodos() {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('MyTodoList')
        .doc(input); //.document(input);
    // Map
    Map<String, String> todos = {'todoTitle': input};
    documentReference.set(todos).whenComplete(() {

    });
  }

  deleteTodos(item) {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('MyTodoList').doc(item);
    // Map
    documentReference.delete().whenComplete(() {
      print(item);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
                    TextButton(
                      onPressed: () {
                        createTodos();
                        Navigator.of(context).pop();
                        input = '';
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('Todo Added')));

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
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("MyTodoList").snapshots(),
        builder: (context, snapshots) {
          if (snapshots.data == null)
          {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          else{
            if(snapshots.data!.docs.length==0)
            {
              return Center(child: Text('There is no Todo in the List'),);
            }else{
          return ListView.builder(
              itemCount: snapshots.data!.docs.length,
              itemBuilder: (context, int index) {
                {
                  DocumentSnapshot documentSnapshot =
                      snapshots.data!.docs[index];
                  return Dismissible(
                      onDismissed: (direction) {
                        deleteTodos(documentSnapshot['todoTitle']);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('Todo Deleted')));

                      },
                      key: Key(documentSnapshot['todoTitle']),
                      child: Card(
                        child: ListTile(
                          title: Text(documentSnapshot['todoTitle']),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              deleteTodos(documentSnapshot['todoTitle']);
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('Todo Deleted')));

                            },
                          ),
                        ),
                      ));
                }
              });}}
        },
      ),
    );
  }
}
