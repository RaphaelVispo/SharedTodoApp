/*
  Author: Raphael S. Vispo
  Section: D3L
  Date created: 18/ 11 /2022 
  Exercise number: 7
  Program Description:Todo app with the user authentication 
  and test cases
*/

import 'package:flutter/material.dart';
import 'package:week7_networking_discussion/api/firebase_todo_api.dart';
import 'package:week7_networking_discussion/models/todo_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TodoListProvider with ChangeNotifier {
  String? userId;
  late FirebaseTodoAPI firebaseService;
  late Stream<QuerySnapshot> _todosStream;
  Todo? _selectedTodo;

  //{required todosList}
  TodoListProvider() {
    firebaseService = FirebaseTodoAPI();
    fetchTodos();
  }

  // getter
  Stream<QuerySnapshot> get todos => _todosStream;
  Todo get selected => _selectedTodo!;

  changeSelectedTodo(Todo item) {
    _selectedTodo = item;
  }

  void fetchTodos() {
    _todosStream = firebaseService.getAllTodos();
    //notifyListeners();
  }

  void addTodo(Todo item) async {
    String message = await firebaseService.addTodo(item.toJson(item));
    print(message);
    notifyListeners();
  }

  void editTodo(Todo item) async {
    Map<String, dynamic> todo = item.toJson(item);
    // todo.remove('id');
    // todo.remove('userId');
    todo['id'] = item.id;

    String message = await firebaseService.editTodo(todo);
    print("Edit");
    notifyListeners();
  }

  void deleteTodo() async {
    String message = await firebaseService.deleteTodo(_selectedTodo!.id);
    print(message);
    notifyListeners();
  }

  void toggleStatus(Todo item, bool status)async {
    Map<String, dynamic> todo = item.toJson(item);
    // todo.remove('id');
    // todo.remove('userId');
    todo['id'] = item.id;
    todo['completed'] = status;

    String message = await firebaseService.editTodo(todo);
    print("Toggle Status");
    notifyListeners();
  }
}
