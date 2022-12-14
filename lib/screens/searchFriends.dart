/*

Author: Raphael Vispo
Section: D3L
Program Description: View, Add and delete friends

*/

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:week7_networking_discussion/models/todo_model.dart';
import 'package:week7_networking_discussion/models/user_models.dart';
import 'package:week7_networking_discussion/providers/todo_provider.dart';
import 'package:week7_networking_discussion/providers/user_providers.dart';
import 'package:week7_networking_discussion/screens/viewFriendProfile.dart';

class SearchFriends extends StatefulWidget {
  const SearchFriends({super.key});

  @override
  State<SearchFriends> createState() => _SearchFriendsState();
}

class _SearchFriendsState extends State<SearchFriends> {
  TextEditingController _searchController = TextEditingController();
  String searchText = '';
  List<QueryDocumentSnapshot<Object?>>? documents = [];

  TextField _search() {
    return TextField(
      onChanged: (value) {
        setState(() {
          searchText = value;
        });
      },
      decoration: InputDecoration(
          hintText: "Search friend using the name",
          filled: true,
          fillColor: Color.fromARGB(0, 2, 2, 2),
          prefix: Icon(Icons.search),
          prefixIconColor: Colors.black,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide.none)),
    );
  }

  @override
  Widget build(BuildContext context) {
    context.read<UserProvider>().getAllFriend();
    // context.read<UserProvider>().getUser();
    UserModel user = context.watch<UserProvider>().userModel;

    Stream<QuerySnapshot> friendStream = context.watch<UserProvider>().friends;

    Card _friendCard(
        String userName, String name, String id, UserModel friend) {
      return Card(
        child: Column(
          children: [
            ListTile(
              title: Text(userName),
              subtitle: Text(name),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => viewFriendProfile(
                            friend: friend,
                          )),
                );
              },
              trailing: ElevatedButton(
                child: Text("Unfriend"),
                onPressed: () {
                  print("Unfreind user: ${name} id: ${id}");
                  context.read<UserProvider>().unfriend(id);

                  // FutureBuilder(
                  //   future: user,
                  //   builder: (context, snapshot) {
                  //     UserModel users = UserModel.fromJson(
                  //         snapshot.data?.data() as Map<String, dynamic>);

                  //     print("Unfreind user: ${name} id: ${id}");
                  //     // context.read<UserProvider>().unfriend(id);
                  //     print(user);

                  //     StreamBuilder(
                  //       stream: todosStream,
                  //       builder: (context, snapshot) {
                  //         documents = snapshot.data?.docs;
                  //         for (QueryDocumentSnapshot<Object?> todoData
                  //             in documents!) {
                  //           Todo todo = Todo.fromJson(
                  //               todoData.data() as Map<String, dynamic>);
                  //           print(todo);
                  //           if (todo.userId == users.id) {
                  //             todo.sharedTo = todo.sharedTo!
                  //                 .toSet()
                  //                 .difference(users.friends!.toSet())
                  //                 .toList();

                  //             print(todo.sharedTo);
                  //             context.read<TodoListProvider>().editTodo(todo);
                  //           }
                  //         }
                  //         return SizedBox();
                  //       },
                  //     );

                  //     return SizedBox();
                  //   },
                  // );
                },
              ),
            )
          ],
        ),
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: Text("Friends"),
        ),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                _search(),
                Expanded(
                  child: StreamBuilder(
                    stream: friendStream,
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

                      documents = snapshot.data?.docs;

                      if (searchText.length > 0) {
                        documents = documents?.where((element) {
                          return element
                              .get('firstName')
                              .toString()
                              .toLowerCase()
                              .contains(searchText.toLowerCase());
                        }).toList();
                      }

                      return ListView.builder(
                        itemCount: documents?.length,
                        itemBuilder: ((context, index) {
                          UserModel user = UserModel.fromJson(
                              documents?[index].data() as Map<String, dynamic>);

                          return _friendCard(
                            '${user.firstName!} ${user.lastName!}',
                            '${user.email}',
                            user.id,
                            user,
                          );
                        }),
                      );
                    },
                  ),
                )
              ],
            )));
  }
}
