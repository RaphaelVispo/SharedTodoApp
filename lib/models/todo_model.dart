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
  Timestamp? deadline;
  List? sharedTo;

  Todo(
      {required this.userId,
      this.id,
      this.title,
      this.completed,
      this.context,
      this.deadline,
      this.sharedTo});

  // Factory constructor to instantiate object from json format
  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
        userId: json['userId'],
        id: json['id'],
        title: json['title'],
        context: json['context'],
        completed: json['completed'],
        deadline: json['deadline'],
        sharedTo: json['sharedTo']);
  }

  static List<Todo> fromJsonArray(String jsonData) {
    final Iterable<dynamic> data = jsonDecode(jsonData);
    return data.map<Todo>((dynamic d) => Todo.fromJson(d)).toList();
  }

  Map<String, dynamic> toJson(Todo todo) {
    return {
      'userId': todo.userId,
      'title': todo.title,
      'completed': todo.completed,
    };
  }
}
