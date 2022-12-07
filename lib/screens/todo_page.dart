/*
  Author: Raphael S. Vispo
  Section: D3L
  Date created: 18/ 11 /2022 
  Exercise number: 7
  Program Description:Todo app with the user authentication 
  and test cases
*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week7_networking_discussion/models/todo_model.dart';
import 'package:week7_networking_discussion/models/user_models.dart';
import 'package:week7_networking_discussion/providers/todo_provider.dart';
import 'package:week7_networking_discussion/providers/auth_provider.dart';
import 'package:week7_networking_discussion/providers/user_providers.dart';
import 'package:week7_networking_discussion/screens/FriendRequest.dart';
import 'package:week7_networking_discussion/screens/addTodo.dart';
import 'package:week7_networking_discussion/screens/editTodo.dart';
import 'package:week7_networking_discussion/screens/modal_todo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:week7_networking_discussion/screens/profile.dart';
import 'package:week7_networking_discussion/screens/searchFriends.dart';
import 'package:week7_networking_discussion/screens/sendFriendRequest.dart';
import 'package:week7_networking_discussion/screens/sentFriendRequest.dart';
import 'package:week7_networking_discussion/screens/sharedTodo.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  String convertNewLine(String content) {
    print("Converting");
    return content.replaceAll(r'\n', '\n');
  }

  @override
  Widget build(BuildContext context) {
    // access the list of todos in the provider
    Stream<QuerySnapshot> todosStream = context.watch<TodoListProvider>().todos;
    final Future<DocumentSnapshot> userInfo =
        context.watch<UserProvider>().info;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      drawer: Drawer(
          child: FutureBuilder(
              future: userInfo,
              builder: ((context, snapshot) {
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

                UserModel user = UserModel.fromJson(
                    snapshot.data?.data() as Map<String, dynamic>);

                return ListView(padding: EdgeInsets.only(top: 80), children: [
                  ListTile(
                    title: Text(
                      'Hello!',
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      '${user.firstName!}',
                      style:
                          TextStyle(fontSize: 60, fontWeight: FontWeight.w100),
                    ),
                  ),
                  Container(
                    height: 300,
                  ),
                  ListTile(
                      title: const Text('Shared Todo'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const sharedTodo()),
                        );
                      }),
                  ListTile(
                      title: const Text('Profile'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Profile()),
                        );
                      }),
                  ListTile(
                    title: const Text('Friends'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SearchFriends()),
                      );
                    },
                  ),
                  ListTile(
                    title: const Text('Send Friend Request'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SendFriendRequest()),
                      );
                    },
                  ),
                  ListTile(
                    title: const Text('View Sent Friend Request'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SentFriendRequest()),
                      );
                    },
                  ),
                  ListTile(
                    title: const Text('Received Friends Request'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FriendRequest()),
                      );
                    },
                  ),
                  ListTile(
                      title: const Text('Logout'),
                      onTap: () {
                        context.read<AuthProvider>().signOut();
                        Navigator.pop(context);
                      }),
                ]);
              }))),
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
            padding: EdgeInsets.all(15),
            child: ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: ((context, index) {
                Todo todo = Todo.fromJson(
                    snapshot.data?.docs[index].data() as Map<String, dynamic>);
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
                    subtitle: Column (children: [
                       Text(convertNewLine(todo.title!)),
                      Text(todo.context!),
                      Text('${todo.deadline!}'),
                    ],),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: todo.completed,
                          onChanged: (bool? value) {
                            context
                                .read<TodoListProvider>()
                                .toggleStatus(index, value!);
                          },
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const EditTodo()),
                            );
                          },
                          icon: const Icon(Icons.create_outlined),
                        ),
                        IconButton(
                          onPressed: () {
                            context
                                .read<TodoListProvider>()
                                .changeSelectedTodo(todo);
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => TodoModal(
                                type: 'Delete',
                              ),
                            );
                          },
                          icon: const Icon(Icons.delete_outlined),
                        )
                      ],
                    ),
                  ),
                );
              }),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>  AddTodo()),
          );
        },
        child: const Icon(Icons.add_outlined),
      ),
    );
  }
}
