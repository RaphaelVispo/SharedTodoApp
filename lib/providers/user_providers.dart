/*

Author: Raphael Vispo
Section: D3L
Exercise number: 6
Program Description: View, Add and delete friends

*/

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:week7_networking_discussion/api/firebase_api.dart';
import 'package:week7_networking_discussion/api/firebase_auth_api.dart';
import 'package:week7_networking_discussion/models/user_models.dart';

class UserProvider with ChangeNotifier {
  String? userId;
  //late FirebaseAuthAPI authService;
  late FirebaseUserAPI userService;
  Stream<QuerySnapshot>? _allFriendRequest;
  Stream<QuerySnapshot>? _allUsers;
  Stream<QuerySnapshot>? _friendList;
  Stream<QuerySnapshot>? _sentFriendRequest;

  Future<DocumentSnapshot>? user;
  late UserModel userModel;

  UserProvider({required this.userId}) {
    userService = FirebaseUserAPI();
    user = userService.getuserInfo(this.userId!);
    getUserData();
  }

  Stream<QuerySnapshot> get friendRequests => _allFriendRequest!;
  Stream<QuerySnapshot> get allUser => _allUsers!;
  Stream<QuerySnapshot> get friends => _friendList!;
  Stream<QuerySnapshot> get sentFriendRequest => _sentFriendRequest!;
  Future<DocumentSnapshot> get info => user!;

  void getUserData() async {
    //getting the current user's data

    print("getting the user ...");

    try {
      DocumentSnapshot uModel = await userService.getuserInfo(this.userId!);
      userModel = UserModel.fromJson(uModel.data() as Map<String, dynamic>);

      getAllFriend();
      getAllFriendRequest();
      getAllUsers();
      getSentFriendRequest();

    } catch (e) {
      print("There is no user");
    }

  }

  void getAllFriendRequest() {
    _allFriendRequest = userService
        .getAllFriendRequest(userModel.receivedFriendRequest as List);
  }

  void getAllFriend() {
    _friendList = userService.getFriends(userModel.friends as List);
  }

  void getAllUsers() {
    _allUsers = userService.getAllUsers(
        userModel.friends as List,
        userModel.sentFriendRequest as List,
        userModel.receivedFriendRequest as List,
        userModel.id);
  }

  void getSentFriendRequest() {
    _sentFriendRequest =
        userService.getSentFriendRequest(userModel.sentFriendRequest);
  }

  void sendFriendRequest(String id) async {
    userModel.sentFriendRequest?.add(id);

    String message = await userService.addSentFriendRequest(
        this.userId, id, userModel.sentFriendRequest!);
    print(message);
    notifyListeners();
  }

  void cancelsentFriendRequest(String id) async {
    userModel.sentFriendRequest?.remove(id);

    String message = await userService.cancelSentFriendRequest(
        this.userId, id, userModel.sentFriendRequest!);
    print(message);
    notifyListeners();
  }

  void acceptFriendRequest(String id) async {
    userModel.receivedFriendRequest?.remove(id);
    userModel.friends?.add(id);

    String message = await userService.acceptFriendRequest(
        this.userId, id, userModel.receivedFriendRequest!, userModel.friends!);
    print(message);
    notifyListeners();
  }

  void cancelFriendRequest(String id) async {
    userModel.receivedFriendRequest?.remove(id);

    String message = await userService.cancelFriendRequest(
        this.userId, id, userModel.receivedFriendRequest!);
    print(message);
    notifyListeners();
  }

  void unfriend(String id) async {
    userModel.friends?.remove(id);

    String message =
        await userService.unfriend(this.userId, id, userModel.friends!);
    print(message);
    notifyListeners();
  }
}
