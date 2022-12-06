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

class SentFriendRequest extends StatefulWidget {
  const SentFriendRequest({super.key});

  @override
  State<SentFriendRequest> createState() => _SentFriendRequestState();
}

class _SentFriendRequestState extends State<SentFriendRequest> {
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
                print("to be moved ${id}");

                context.read<UserProvider>().cancelsentFriendRequest(id);
              },
              child: Text("Cancel"))
        ],
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    //auto update
    context.read<UserProvider>().getSentFriendRequest();
    Stream<QuerySnapshot> todosStream =
        context.watch<UserProvider>().sentFriendRequest;

    return Scaffold(
        appBar: AppBar(
          title: Text("Sent Friend Request"),
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

                  return ListView.builder(
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: ((context, index) {
                      UserModel user = UserModel.fromJson(
                          snapshot.data?.docs[index].data()
                              as Map<String, dynamic>);

                      return _friendCard('${user.firstName!} ${user.lastName!}',
                          user.email!, user.id);
                    }),
                  );
                })));
  }
}
