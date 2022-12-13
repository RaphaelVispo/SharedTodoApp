import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:date_field/date_field.dart';
import 'package:week7_networking_discussion/models/todo_model.dart';
import 'package:week7_networking_discussion/models/user_models.dart';
import 'package:week7_networking_discussion/providers/notification_provider.dart';
import 'package:week7_networking_discussion/providers/todo_provider.dart';
import 'package:week7_networking_discussion/providers/user_providers.dart';

class AddTodo extends StatefulWidget {
  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController titleController;
  late TextEditingController contextController;
  late MultiValueDropDownController _cntMulti;

  DateTime? dealineDateTime;
  late int count;

  @override
  initState() {
    count = 1;
    titleController = TextEditingController();
    contextController = TextEditingController();
    _cntMulti = MultiValueDropDownController();
    super.initState();
  }

  @override
  void dispose() {
    _cntMulti.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.read<UserProvider>().getAllFriend();
    Stream<QuerySnapshot> freindsStream = context.watch<UserProvider>().friends;

    List<QueryDocumentSnapshot<Object?>>? documents = [];
    List<String> sharedTodo = ["0"];

    final deadline = DateTimeFormField(
      decoration: const InputDecoration(
        hintStyle: TextStyle(color: Colors.black45),
        errorStyle: TextStyle(color: Colors.redAccent),
        suffixIcon: Icon(Icons.event_note),
      ),
      mode: DateTimeFieldPickerMode.dateAndTime,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onDateSelected: (DateTime value) {
        dealineDateTime = value;
      },
      validator: (DateTime? selectedDateTime) {
        if (selectedDateTime == null) {
          return 'Please enter a date';
        }
        if (selectedDateTime.difference(DateTime.now()).isNegative) {
          return 'Enter a future Date';
        }
      },
    );

    UserModel userInfo = context.read<UserProvider>().userModel;

    List<DropDownValueModel> getFriendList(
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
                      "Create Todo",
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a title';
                              }
                            },
                          ),
                          Container(
                            height: 20,
                          ),
                          TextFormField(
                              keyboardType: TextInputType.multiline,
                              controller: contextController,
                              textInputAction: TextInputAction.newline,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(15),
                                hintText: "Content",
                              ),
                              maxLines: 10,
                              minLines: 1,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a title';
                                }
                              }),
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
                                                dropDownList: getFriendList(
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
                          deadline,
                        ],
                      ))
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                child: Text("Add todo"),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    print("Adding todo");
                    Todo temp = Todo(
                        userId: userInfo.id,
                        completed: false,
                        title: titleController.text,
                        context: contextController.text,
                        sharedTo: sharedTodo,
                        deadline: dealineDateTime,
                        editHistory: ['0']);

                    context.read<TodoListProvider>().addTodo(temp);

                    ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text('${temp.title} Added')));
                    Navigator.pop(context);
                  }
                },
              ),
            )
          ],
        ));
  }
}
