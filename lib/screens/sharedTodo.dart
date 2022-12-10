import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week7_networking_discussion/models/todo_model.dart';
import 'package:week7_networking_discussion/models/user_models.dart';
import 'package:week7_networking_discussion/providers/todo_provider.dart';
import 'package:week7_networking_discussion/providers/auth_provider.dart';
import 'package:week7_networking_discussion/providers/user_providers.dart';
import 'package:week7_networking_discussion/screens/FriendRequest.dart';
import 'package:week7_networking_discussion/screens/addTodo.dart';
import 'package:week7_networking_discussion/screens/editSharedTodo.dart';
import 'package:week7_networking_discussion/screens/editTodo.dart';
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
    context.read<TodoListProvider>().fetchTodos();
    Stream<QuerySnapshot> todosStream = context.watch<TodoListProvider>().todos;
    final Future<DocumentSnapshot> userInfo =
        context.watch<UserProvider>().info;
    UserModel? user;

    addspacing(double h) {
      return Container(
        height: h,
      );
    }

    showTodos(Todo todo, int index) {
      return Dismissible(
        key: Key(todo.id.toString()),
        onDismissed: (direction) {
          context.read<TodoListProvider>().changeSelectedTodo(todo);
          context.read<TodoListProvider>().deleteTodo();

          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('${todo.title} dismissed')));
        },
        background: Container(
          color: Colors.red,
          child: const Icon(Icons.delete),
        ),
        child: ListTile(
          title: Text(todo.title!),
          subtitle: Column(
            children: [
              Text(convertNewLine(todo.title!)),
              Text(todo.context!),
              Text('${todo.deadline!}'),
              addspacing(50),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => editSharedTodo(todo: todo,)),
                  );
                },
                icon: const Icon(Icons.create_outlined),
              ),
            ],
          ),
        ),
      );
    }

    return FutureBuilder(
        future: userInfo,
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

          user =
              UserModel.fromJson(snapshot.data?.data() as Map<String, dynamic>);
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
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (!snapshot.hasData) {
                  return Center(
                    child: Text("No Todos Found"),
                  );
                }

                return Padding(
                  padding: EdgeInsets.all(15),
                  child: ListView.builder(
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: ((context, index) {
                      Todo todo = Todo.fromJson(snapshot.data?.docs[index]
                          .data() as Map<String, dynamic>);
                      print('Todo ${todo.userId} == ${user?.id}');

                      if (todo.sharedTo!.contains(user?.id)) {
                        return showTodos(todo, index);
                      } else {
                        return SizedBox();
                      }
                    }),
                  ),
                );
              },
            ),
          );
        });
  }
}
