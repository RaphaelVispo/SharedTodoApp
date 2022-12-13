import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:week7_networking_discussion/api/firebase_api.dart';
import 'package:week7_networking_discussion/api/firebase_notifications_api.dart';
import 'package:week7_networking_discussion/models/notofication_model.dart';
import 'package:week7_networking_discussion/models/user_models.dart';

class NotificationProvider with ChangeNotifier {
  String? userId;
  //late FirebaseAuthAPI authService;
  late FirebaseUserAPI userService;
  late FirebaseNotificationAPI notificationService;

  late UserModel userModel;

  Stream<QuerySnapshot>? _NotificationStream;

  Stream<QuerySnapshot> get notifs => _NotificationStream!;

  NotificationProvider({required this.userId}) {
    notificationService = FirebaseNotificationAPI();
    userService = FirebaseUserAPI();
    getUserData();
  }

  void getUserData() async {
    //getting the current user's data

    try {
      print("getting the user ...");
      DocumentSnapshot uModel = await userService.getuserInfo(this.userId!);
      userModel = UserModel.fromJson(uModel.data() as Map<String, dynamic>);
    } catch (e) {
      print("There is no user");
    }
  }

  void getNotifications() {
    _NotificationStream = notificationService.getAllNotification();
  }

  void addDeadlineNotification(String? content, List sharedTodo) {
    sharedTodo.add(userId);
    Notifications temp = Notifications(
      id: "1",
      fromUserId: userId,
      toUserId: sharedTodo,
      context: content,
      title: "Deadline for the a todo",
      time: DateTime.now(),
    );

    notificationService.addNotification(temp.toJson(temp));
  }

  void deleteNotif(String id) {
    notificationService.deleteNotifications(id);
  }

  void editDeadlineNotification(Notifications notif, String context) {
    Notifications temp = Notifications(
      id: "1",
      fromUserId: userId,
      toUserId: notif.toUserId,
      context: context,
      title: "Deadline for the a todo",
      time: DateTime.now(),
    );

    notificationService.editNotification(temp.toJson(temp));
  }

  void editiedtodo(String? content, List sharedTodo) {
    Notifications temp = Notifications(
      id: "1",
      fromUserId: userId,
      toUserId: sharedTodo,
      context: content,
      title: "Edit a todo",
      time: DateTime.now(),
    );

    notificationService.addNotification(temp.toJson(temp));
  }

  void AddFriendRequest(String? content, List friend) {
    Notifications temp = Notifications(
      id: "1",
      fromUserId: userId,
      toUserId: friend,
      context: content,
      title: "Accepted Friend Request",
      time: DateTime.now(),
    );

    notificationService.addNotification(temp.toJson(temp));
  }



}
