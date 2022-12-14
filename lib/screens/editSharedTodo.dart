import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_field/date_field.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:week7_networking_discussion/models/todo_model.dart';
import 'package:week7_networking_discussion/models/user_models.dart';
import 'package:week7_networking_discussion/providers/notification_provider.dart';
import 'package:week7_networking_discussion/providers/todo_provider.dart';
import 'package:week7_networking_discussion/providers/user_providers.dart';

class editSharedTodo extends StatefulWidget {
  final Todo todo;
  const editSharedTodo({super.key, required this.todo});

  @override
  State<editSharedTodo> createState() => _editSharedTodoState();
}

class _editSharedTodoState extends State<editSharedTodo> {
  late TextEditingController titleController;
  late TextEditingController contextController;
  final _formKey = GlobalKey<FormState>();
  List<String> sharedTodo = ["0"];
  DateTime? dealineDateTime;



  late int count;


  @override
  initState() {
    count = 1;
    titleController = TextEditingController(text: widget.todo.title);
    contextController = TextEditingController(text: widget.todo.context);

    super.initState();
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
      validator: (e) => (e?.day ?? 0) == 1 ? 'Please not the first day' : null,
      onDateSelected: (DateTime value) {},
    );
  }
  

  @override
  Widget build(BuildContext context) {
    Future<DocumentSnapshot<Object?>>? userInfo =
        context.watch<UserProvider>().info;
    context.read<UserProvider>().getAllFriend();
    UserModel? users;

    addEditHistory() async {
      DocumentSnapshot<Object?>? user = await userInfo;
       users=
          UserModel.fromJson(user.data() as Map<String, dynamic>);

      //print('edit histort ${widget.todo.editHistory}');

      DateTime now = DateTime.now();
      widget.todo.editHistory!
          .add('${users?.firstName} ${users?.lastName} at $now');

      return widget.todo.editHistory;
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
                onPressed: () async{
                  widget.todo.editHistory = await addEditHistory();
                  // print("shared todo ${widget.todo.sharedTo}");

                  Todo temp = Todo(
                      userId: widget.todo.userId,
                      id: widget.todo.id,
                      completed: false,
                      title: titleController.text,
                      context: contextController.text,
                      sharedTo: widget.todo.sharedTo,
                      deadline: dealineDateTime ?? widget.todo.deadline,
                      editHistory: widget.todo.editHistory);

                  context.read<TodoListProvider>().editTodo(temp);
                  context.read<NotificationProvider>().editiedtodo(
                    "${users?.firstName} ${users?.lastName} edited ${temp.title}",
                    [widget.todo.userId!]);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${temp.title} edited')));
                  Navigator.pop(context);
                },
              ),
            )
          ],
        ));
  }
}
