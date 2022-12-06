/*

Author: Raphael Vispo
Section: D3L
Exercise number: 6
Program Description: View, Add and delete friends

*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:week7_networking_discussion/models/user_models.dart';
import 'package:week7_networking_discussion/providers/user_providers.dart';

class SendFriendRequest extends StatefulWidget {
  const SendFriendRequest({super.key});

  @override
  State<SendFriendRequest> createState() => _SendFriendRequestState();
}

class _SendFriendRequestState extends State<SendFriendRequest> {
  Card _friendCard(String userName, String name, String id) {
    return Card(
        child: Padding(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text(userName),
            subtitle: Text(name),
          ),
          ElevatedButton(
              onPressed: () {
                print('Sending a friend request to ${name} ${id}');

                context.read<UserProvider>().sendFriendRequest(id);
              },
              child: Text("Send"))
        ],
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    // context.read<TodoListProvider>().getAllFriendRequest();
    context.read<UserProvider>().getAllUsers();
    Stream<QuerySnapshot> todosStream =
        context.watch<UserProvider>().allUser;
    return Scaffold(
        appBar: AppBar(
          title: Text("Send Friend Request"),
        ),
        body: Padding(
          padding: EdgeInsets.all(15),
          child: StreamBuilder(
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

              return ListView.builder(
                itemCount: snapshot.data?.docs.length,
                itemBuilder: ((context, index) {
                                  UserModel user = UserModel.fromJson(
                    snapshot.data?.docs[index].data() as Map<String, dynamic>);

                return _friendCard(
                    '${user.firstName!} ${user.lastName!}', user.email! , user.id);
                }),
              );
            },
          ),
        ));
  }
}
