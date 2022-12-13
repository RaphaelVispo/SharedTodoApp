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
import 'package:week7_networking_discussion/screens/editSharedTodo.dart';
import 'package:week7_networking_discussion/screens/editTodo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:week7_networking_discussion/screens/searchFriends.dart';
import 'package:week7_networking_discussion/screens/sendFriendRequest.dart';
import 'package:week7_networking_discussion/screens/sentFriendRequest.dart';

class notifications extends StatefulWidget {
  const notifications({super.key});

  @override
  State<notifications> createState() => _notificationsState();
}

class _notificationsState extends State<notifications> {
  @override
  Widget build(BuildContext context) {
    context.read<NotificationProvider>().getNotifications();
    Stream<QuerySnapshot> notificationStream =
        context.watch<NotificationProvider>().notifs;
    final Future<DocumentSnapshot> userInfo =
        context.watch<UserProvider>().info;
    UserModel? user;

    addspacing(double h) {
      return Container(
        height: h,
      );
    }

    showNotifications(Notifications notif, int index) {
      return Card(
          child: Dismissible(
              key: UniqueKey(),
              onDismissed: (direction) {
                context.read<NotificationProvider>().deleteNotif(notif.id!);

                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${notif.title} dismissed')));
              },
              background: Container(
                color: Colors.red,
                child: const Icon(Icons.delete),
              ),
              child: ListTile(
                title: Text(notif.title!),
                subtitle: Column(
                  children: [
                    Text(notif.context!),
                    Text('${notif.time!}'),
                  ],
                ),
              )));
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
              title: Text("Nontifications"),
            ),
            body: StreamBuilder(
              stream: notificationStream,
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
                    child: Text("No Notificatinoons Found"),
                  );
                }

                return Padding(
                  padding: EdgeInsets.all(15),
                  child: ListView.builder(
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: ((context, index) {
                      Notifications notif = Notifications.fromJson(
                          snapshot.data?.docs[index].data()
                              as Map<String, dynamic>);
                      // print('Todo ${todo.userId} == ${user?.id}');

                      if (notif.toUserId!.contains(user?.id)) {
                        return Column(children: [
                          showNotifications(notif, index),
                          addspacing(10),
                        ]);
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
