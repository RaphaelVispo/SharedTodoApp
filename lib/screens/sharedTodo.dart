import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week7_networking_discussion/models/todo_model.dart';
import 'package:week7_networking_discussion/providers/todo_provider.dart';
import 'package:week7_networking_discussion/providers/auth_provider.dart';
import 'package:week7_networking_discussion/screens/FriendRequest.dart';
import 'package:week7_networking_discussion/screens/addTodo.dart';
import 'package:week7_networking_discussion/screens/editTodo.dart';
import 'package:week7_networking_discussion/screens/modal_todo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:week7_networking_discussion/screens/searchFriends.dart';
import 'package:week7_networking_discussion/screens/sendFriendRequest.dart';
import 'package:week7_networking_discussion/screens/sentFriendRequest.dart';

class sharedTodo extends StatefulWidget {
  const sharedTodo({super.key});

  @override
  State<sharedTodo> createState() => _sharedTodoState();
}

class _sharedTodoState extends State<sharedTodo> {
  String convertNewLine(String content) {
    print("Converting");
    return content.replaceAll(r'\n', '\n');
  }

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> todosStream = context.watch<TodoListProvider>().todos;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: StreamBuilder(
        stream: todosStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error encountered! ${snapshot.error}"),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (!snapshot.hasData) {
            return Center(
              child: Text("No Todos Found"),
            );
          }

          return Padding(
            padding: EdgeInsets.only(top: 70, left: 30, right: 30),
            child: Column(children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Shared Todo",
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                height: 60,
              ),
              ListView.builder(
                itemCount: snapshot.data?.docs.length,
                itemBuilder: ((context, index) {
                  Todo todo = Todo.fromJson(snapshot.data?.docs[index].data()
                      as Map<String, dynamic>);
                  return Dismissible(
                    key: Key(todo.id.toString()),
                    onDismissed: (direction) {
                      context.read<TodoListProvider>().changeSelectedTodo(todo);
                      context.read<TodoListProvider>().deleteTodo();

                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${todo.title} dismissed')));
                    },
                    background: Container(
                      color: Colors.red,
                      child: const Icon(Icons.delete),
                    ),
                    child: ListTile(
                      title: Text(todo.title!),
                      subtitle: Text('${convertNewLine(todo.context!)}'),
                      leading: Checkbox(
                        value: todo.completed,
                        onChanged: (value) => {},
                      ),
                    ),
                  );
                }),
              )
            ]),
          );
        },
      ),

    );
  }
}
