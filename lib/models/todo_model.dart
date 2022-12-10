/*
  Author: Raphael S. Vispo
  Section: D3L
  Date created: 18/ 11 /2022 
  Exercise number: 7
  Program Description:Todo app with the user authentication 
  and test cases
*/

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  String? userId;
  String? id;
  String? title;
  bool? completed;
  String? context;
  DateTime? deadline;
  List? sharedTo;
  List? editHistory;

  Todo(
      {required this.userId,
      this.id,
      this.title,
      this.completed,
      this.context,
      this.deadline,
      this.sharedTo,
      this.editHistory});

  // Factory constructor to instantiate object from json format
  factory Todo.fromJson(Map<String, dynamic> json) {
    // print(json);
    return Todo(
        userId: json['userId'],
        id: json['id'],
        title: json['title'],
        context: json['context'],
        completed: json['completed'],
        deadline: DateTime.fromMicrosecondsSinceEpoch(
            json['deadline'].seconds * 1000000),
        sharedTo: json['sharedTo'],
        editHistory :json['editHistory'] );
  }

  static List<Todo> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<Todo>((dynamic d) => Todo.fromJson(d)).toList();
  }

  Map<String, dynamic> toJson(Todo todo) {
    return {
      'id': '1',
      'userId': todo.userId,
      'title': todo.title,
      'context': todo.context,
      'completed': todo.completed,
      'deadline': todo.deadline,
      'sharedTo': todo.sharedTo,
      'editHistory':todo.editHistory
    };
  }
}
