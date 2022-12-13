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
import 'package:week7_networking_discussion/models/notofication_model.dart';
import 'package:week7_networking_discussion/models/todo_model.dart';
import 'package:week7_networking_discussion/models/user_models.dart';
import 'package:week7_networking_discussion/providers/notification_provider.dart';
import 'package:week7_networking_discussion/providers/todo_provider.dart';
import 'package:week7_networking_discussion/providers/auth_provider.dart';
import 'package:week7_networking_discussion/providers/user_providers.dart';
import 'package:week7_networking_discussion/screens/FriendRequest.dart';
import 'package:week7_networking_discussion/screens/addTodo.dart';
import 'package:week7_networking_discussion/screens/editTodo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:week7_networking_discussion/screens/notification.dart';
import 'package:week7_networking_discussion/screens/profile.dart';
import 'package:week7_networking_discussion/screens/searchFriends.dart';
import 'package:week7_networking_discussion/screens/sendFriendRequest.dart';
import 'package:week7_networking_discussion/screens/sentFriendRequest.dart';
import 'package:week7_networking_discussion/screens/sharedTodo.dart';
import 'package:intl/intl.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> todosStream = context.watch<TodoListProvider>().todos;
    final Future<DocumentSnapshot> userInfo =
        context.watch<UserProvider>().info;

    UserModel? user;
    final helloText = ListTile(
      title: Text(
        'Hello!',
        style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
      ),
    );
    greetUser(UserModel? user) {
      return ListTile(
          title: Text(
        '${user?.firstName}',
        style: TextStyle(fontSize: 60, fontWeight: FontWeight.w100),
      ));
    }

    final Notificationbutton = ListTile(
        title: const Text('Notifications'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const notifications()),
          );
        });
    final shareTodobutton = ListTile(
        title: const Text('Shared Todo'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const sharedTodo()),
          );
        });
    final profileButton = ListTile(
        title: const Text('Profile'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Profile()),
          );
        });
    final searchFriendsButton = ListTile(
      title: const Text('Friends'),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SearchFriends()),
        );
      },
    );
    final sendFriendRequestButton = ListTile(
      title: const Text('Send Friend Request'),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SendFriendRequest()),
        );
      },
    );
    final sentFriendRequestButton = ListTile(
      title: const Text('View Sent Friend Request'),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SentFriendRequest()),
        );
      },
    );
    final friendRequestButton = ListTile(
      title: const Text('Received Friends Request'),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const FriendRequest()),
        );
      },
    );
    final logoutButton = ListTile(
        title: const Text('Logout'),
        onTap: () {
          context.read<AuthProvider>().signOut();
          Navigator.pop(context);
        });

    addspacing(double h) {
      return Container(
        height: h,
      );
    }

    printSharedTo(List? sharedTo) {
      context.read<UserProvider>().getAllFriend();
      Stream<QuerySnapshot> friendsStream =
          context.watch<UserProvider>().friends;
      List? documents;
      return StreamBuilder(
        stream: friendsStream,
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

          documents = snapshot.data?.docs;
          String sharedText = 'Shared to: ';

          if (sharedTo!.length == 1) {
            return Text('Todo is currently private');
          }
          for (QueryDocumentSnapshot friend in documents!) {
            UserModel friendinfo =
                UserModel.fromJson(friend.data() as Map<String, dynamic>);

            if (sharedTo.contains(friendinfo.id)) {
              sharedText = sharedText +
                  friendinfo.firstName! +
                  ' ' +
                  friendinfo.lastName! +
                  ', ';
            }
          }

          return Text(sharedText);
        },
      );
    }

    printEditHistory(List? listHistory) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
      final date2 = DateTime.now();
      final differences = todo.deadline?.difference(date2).inDays;
      if (!(differences!.isNegative) && differences < 3 && differences != 0) {
        context.read<NotificationProvider>().addDeadlineNotification(
            "Only ${differences} till the deadline is for ${todo.title}",
            todo.sharedTo!);
      } else if (differences == 0) {
        context.read<NotificationProvider>().addDeadlineNotification(
            "Deadline is Up for ${todo.title}", todo.sharedTo!);
      }

      return Card(
          child: Padding(
        padding: EdgeInsets.all(10),
        child: ListTile(
          title: Text(todo.title!),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              printSharedTo(todo.sharedTo),
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
                onChanged: (bool? value) {
                  context.read<TodoListProvider>().toggleStatus(todo, value!);
                },
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditTodo(
                              todo: todo,
                            )),
                  );
                },
                icon: const Icon(Icons.create_outlined),
              ),
              IconButton(
                onPressed: () {
                  context.read<TodoListProvider>().changeSelectedTodo(todo);
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Delete todo'),
                        content: Text(
                            'Are you sure you want to delete ${todo.title}'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('No'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              context.read<TodoListProvider>().deleteTodo();
                            },
                            child: Text('Yes'),
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: const Icon(Icons.delete_outlined),
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
                title: Text("Todos"),
              ),
              drawer: Drawer(
                child: ListView(padding: EdgeInsets.only(top: 80), children: [
                  helloText,
                  greetUser(user),
                  addspacing(300),
                  Notificationbutton,
                  shareTodobutton,
                  profileButton,
                  searchFriendsButton,
                  sendFriendRequestButton,
                  sentFriendRequestButton,
                  friendRequestButton,
                  logoutButton
                ]),
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

                        if (todo.userId == user?.id) {
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
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddTodo()),
                  );
                },
                child: const Icon(Icons.add_outlined),
              ));
        });
  }
}
