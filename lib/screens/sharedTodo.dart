import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week7_networking_discussion/models/todo_model.dart';
import 'package:week7_networking_discussion/models/user_models.dart';
import 'package:week7_networking_discussion/providers/todo_provider.dart';
import 'package:week7_networking_discussion/providers/user_providers.dart';
import 'package:week7_networking_discussion/screens/editSharedTodo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

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

    printEditHistory(List? listHistory) {
      return Column(
        children: [
          Text("Edited by:"),
          ListView(
            shrinkWrap: true,
            children: [
              for (String change in listHistory!)
                if (change != "0") Text(change)
            ],
          )
        ],
      );
    }

    showTodos(Todo todo, int index) {

      return Card(
          child: Padding(
        padding: EdgeInsets.all(10),
        child: ListTile(
          title: Text(todo.title!),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              addspacing(10),
              Text(todo.context!),
              addspacing(10),
              Text(
                  'Deadline: ${DateFormat().add_yMMMMEEEEd().format(todo.deadline!)} at ${DateFormat().add_Hm().format(todo.deadline!)}'),
              addspacing(10),
              ((todo.editHistory?.length ?? 0) > 1)
                  ? printEditHistory(todo.editHistory)
                  : SizedBox(),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: todo.completed,
                onChanged: (bool? value) {},
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => editSharedTodo(
                              todo: todo,
                            )),
                  );
                },
                icon: const Icon(Icons.create_outlined),
              ),
            ],
          ),
        ),
      ));
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
              title: Text("Shared Todos"),
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

                      

                      if (todo.sharedTo!.contains(user?.id) && user!.friends!.contains(todo.userId)) {
                        return Column(
                          children: [
                            showTodos(todo, index),
                            addspacing(20),
                          ],
                        );
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
