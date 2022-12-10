import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:date_field/date_field.dart';
import 'package:provider/provider.dart';
import 'package:week7_networking_discussion/models/todo_model.dart';
import 'package:week7_networking_discussion/models/user_models.dart';
import 'package:week7_networking_discussion/providers/todo_provider.dart';
import 'package:week7_networking_discussion/providers/user_providers.dart';

class EditTodo extends StatefulWidget {
  final Todo todo;
  const EditTodo({super.key, required this.todo});

  @override
  State<EditTodo> createState() => _EditTodoState();
}

class _EditTodoState extends State<EditTodo> {
  late TextEditingController titleController;
  late TextEditingController contextController;
  final _formKey = GlobalKey<FormState>();
  late MultiValueDropDownController _cntMulti;
  late int count;
  DateTime? dealineDateTime;

  List<DropDownValueModel> getFriendListInTodo(
      List<QueryDocumentSnapshot<Object?>>? documents) {
    List<DropDownValueModel> choiceFriends = [];

    for (QueryDocumentSnapshot<Object?> friend in documents!) {
      UserModel user =
          UserModel.fromJson(friend.data() as Map<String, dynamic>);
      // print('userid: ${user.id}');
      // print('shared to :${widget.todo.sharedTo}');
      if (widget.todo.sharedTo!.contains(user.id)) {
        choiceFriends.add(DropDownValueModel(
            name: '${user.firstName} ${user.lastName}', value: user.id));
      }
    }
    //print('choice: $choiceFriends');
    return choiceFriends;
  }

  List<DropDownValueModel> getFriendAllList(
      List<QueryDocumentSnapshot<Object?>>? documents) {
    List<DropDownValueModel> choiceFriends = [];

    for (QueryDocumentSnapshot<Object?> friend in documents!) {
      UserModel user =
          UserModel.fromJson(friend.data() as Map<String, dynamic>);

      choiceFriends.add(DropDownValueModel(
          name: '${user.firstName} ${user.lastName}', value: user.id));
    }
    // print('choice: $choiceFriends');
    return choiceFriends;
  }

  @override
  initState() {
    count = 1;
    titleController = TextEditingController(text: widget.todo.title);
    contextController = TextEditingController(text: widget.todo.context);

    super.initState();
  }

  @override
  void dispose() {
    _cntMulti.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<DocumentSnapshot<Object?>>? userInfo =
        context.watch<UserProvider>().user;
    context.read<UserProvider>().getAllFriend();
    Stream<QuerySnapshot> freindsStream = context.watch<UserProvider>().friends;
    List sharedTodo = ['0'];
    addEditHistory() async {
      DocumentSnapshot<Object?>? user = await userInfo;
      UserModel users =
          UserModel.fromJson(user?.data() as Map<String, dynamic>);

      //print('edit histort ${widget.todo.editHistory}');

      DateTime now = DateTime.now();
      widget.todo.editHistory!
          .add('${users.firstName} ${users.lastName} at $now');

      return widget.todo.editHistory;
    }

    deadline(DateTime? date) {
      return DateTimeFormField(
        initialDate: date,
        initialValue: date,
        decoration: const InputDecoration(
          hintStyle: TextStyle(color: Colors.black45),
          errorStyle: TextStyle(color: Colors.redAccent),
          suffixIcon: Icon(Icons.event_note),
        ),
        mode: DateTimeFieldPickerMode.dateAndTime,
        autovalidateMode: AutovalidateMode.always,
        validator: (e) =>
            (e?.day ?? 0) == 1 ? 'Please not the first day' : null,
        onDateSelected: (DateTime value) {
          dealineDateTime = value;
        },
      );
    }

    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 70, left: 30, right: 30),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Edit Todo",
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    height: 20,
                  ),
                  Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: titleController,
                            style: TextStyle(fontSize: 20),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(15),
                              hintText: "Title",
                            ),
                            onChanged: ((value) {}),
                          ),
                          Container(
                            height: 20,
                          ),
                          TextFormField(
                            controller: contextController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(15),
                              hintText: "Content",
                            ),
                            maxLines: 10,
                            minLines: 1,
                          ),
                          Container(
                            height: 60,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Share Todo",
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                          ),
                          ListView.builder(
                              itemCount: count,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                return ListTile(
                                  title: Row(children: [
                                    Expanded(
                                        child: StreamBuilder(
                                            stream: freindsStream,
                                            builder: (context, snapshot) {
                                              if (snapshot.hasError) {
                                                return Center(
                                                  child: Text(
                                                      "Error encountered! ${snapshot.error}"),
                                                );
                                              } else if (snapshot
                                                      .connectionState ==
                                                  ConnectionState.waiting) {
                                                return Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              } else if (!snapshot.hasData) {
                                                return Center(
                                                  child: Text("No Todos Found"),
                                                );
                                              }

                                              List<
                                                      QueryDocumentSnapshot<
                                                          Object?>>?
                                                  friendDocument =
                                                  snapshot.data?.docs;

                                              _cntMulti =
                                                  MultiValueDropDownController(
                                                      data: getFriendListInTodo(
                                                          friendDocument));

                                              return DropDownTextField
                                                  .multiSelection(
                                                controller: _cntMulti,
                                                clearOption: false,
                                                clearIconProperty: IconProperty(
                                                    color: Colors.green),
                                                validator: (value) {
                                                  if (value == null) {
                                                    return "Required field";
                                                  } else {
                                                    return null;
                                                  }
                                                },
                                                dropDownItemCount: 6,
                                                dropDownList: getFriendAllList(
                                                    friendDocument),
                                                onChanged: (val) {
                                                  for (DropDownValueModel user
                                                      in val) {
                                                    sharedTodo.add(user.value);
                                                  }
                                                },
                                              );
                                            }))
                                  ]),
                                );
                              }),
                          Container(
                            height: 60,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Deadline",
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            height: 20,
                          ),
                          deadline(widget.todo.deadline),
                        ],
                      ))
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                child: Text("Edit todo"),
                onPressed: () async {
                  widget.todo.editHistory = await addEditHistory();

                  Todo temp = Todo(
                      userId: widget.todo.userId,
                      id: widget.todo.id,
                      completed: false,
                      title: titleController.text,
                      context: contextController.text,
                      sharedTo:sharedTodo,
                      deadline: dealineDateTime ?? widget.todo.deadline,
                      editHistory: widget.todo.editHistory);

                  context.read<TodoListProvider>().editTodo(temp);
                  Navigator.pop(context);
                },
              ),
            )
          ],
        ));
  }
}
