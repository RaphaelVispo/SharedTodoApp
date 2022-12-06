/*

Author: Raphael Vispo
Section: D3L
Exercise number: 6
Program Description: View, Add and delete friends

*/

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:week7_networking_discussion/models/user_models.dart';
import 'package:week7_networking_discussion/providers/user_providers.dart';

class FriendRequest extends StatefulWidget {
  const FriendRequest({super.key});

  @override
  State<FriendRequest> createState() => _FriendRequestState();
}

class _FriendRequestState extends State<FriendRequest> {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.green),
                  onPressed: () {
                    print("Accepting Friend Request ${id} ");

                    context.read<UserProvider>().acceptFriendRequest(id);
                  },
                  child: Text("Accept")),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.red),
                  onPressed: () {
                    print("Deleting Friend Request ${id} ");

                   context.read<UserProvider>().cancelFriendRequest(id);
                  },
                  child: Text("Decline"))
            ],
          )
        ],
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    //auto update
    context.read<UserProvider>().getAllFriendRequest();

    Stream<QuerySnapshot> todosStream =
        context.watch<UserProvider>().friendRequests;

    return Scaffold(
      appBar: AppBar(
        title: Text("Friend Requests"),
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
      ),
    );
  }
}
