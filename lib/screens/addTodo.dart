import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:date_field/date_field.dart';
import 'package:week7_networking_discussion/models/todo_model.dart';
import 'package:week7_networking_discussion/models/user_models.dart';
import 'package:week7_networking_discussion/providers/todo_provider.dart';
import 'package:week7_networking_discussion/providers/user_providers.dart';

class AddTodo extends StatefulWidget {
  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController contextController = TextEditingController();
  List<String> sharedTodo = ["0"];
  DateTime? dealineDateTime;
  late int count;

  void set dateTime(DateTime value) => this.dealineDateTime = value;

  @override
  initState() {
    count = 1;
    // dealineDateTime = DateTime(20);
    super.initState();
    // Add listeners to this class
  }



  @override
  Widget build(BuildContext context) {
      final deadline = DateTimeFormField(
    decoration: const InputDecoration(
      hintStyle: TextStyle(color: Colors.black45),
      errorStyle: TextStyle(color: Colors.redAccent),
      suffixIcon: Icon(Icons.event_note),
    ),
    mode: DateTimeFieldPickerMode.dateAndTime,
    autovalidateMode: AutovalidateMode.always,
    validator: (e) => (e?.day ?? 0) == 1 ? 'Please not the first day' : null,
    onDateSelected: (DateTime value) {
      dealineDateTime = value;
    },
  );
    UserModel userInfo = context.read<UserProvider>().userModel;
    IconButton delete = IconButton(
        onPressed: () {
          setState(() {
            if (count != 1) {
              count -= 1;
            }
          });
        },
        icon: const Icon(Icons.delete));

    IconButton add = IconButton(
        onPressed: () {
          setState(() {
            count += 1;
          });
        },
        icon: const Icon(Icons.add));

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
                                        child: TextFormField(),
                                      )
                                    ]),
                                    leading: add,
                                    trailing: delete);
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
                        deadline: dealineDateTime);

                    context.read<TodoListProvider>().addTodo(temp);
                  }
                },
              ),
            )
          ],
        ));
  }
}
