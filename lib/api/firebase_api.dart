/*

Author: Raphael Vispo
Section: D3L
Exercise number: 6
Program Description: View, Add and delete friends

*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:week7_networking_discussion/models/user_models.dart';

class FirebaseUserAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  FirebaseUserAPI();

  //get with the user info
  Future<DocumentSnapshot> getuserInfo(String id) async {
    return db.collection("users").doc(id).get();
  }

  //get friend request with the user id
  Stream<QuerySnapshot> getAllFriendRequest(List? friendsRequest) {
    Stream<QuerySnapshot> fRequest =
        db.collection("users").where('id', whereIn: friendsRequest).snapshots();

    return fRequest;
  }

  //get sent friend request with the user id
  Stream<QuerySnapshot> getSentFriendRequest(List? sentFriendRequest) {
    Stream<QuerySnapshot> allUsers = db
        .collection("users")
        .where('id', whereIn: sentFriendRequest)
        .snapshots();
    return allUsers;
  }

  //get friends  with the user id
  Stream<QuerySnapshot> getFriends(List friends) {
    // print(" friend list :${friends}");
    Stream<QuerySnapshot> friendList =
        db.collection("users").where('id', whereIn: friends).snapshots();
    return friendList;
  }

  //get all the user in the database except gfor the user and users who interact with the user
  Stream<QuerySnapshot> getAllUsers(List friends, List sentFriendRequest,
      List sendFriendRequest, String? user) {
    List nonFriends = [
      ...friends,
      ...sentFriendRequest,
      user,
      ...sendFriendRequest
    ];

    nonFriends.remove("0");
    nonFriends.remove("0");
    nonFriends.remove("0");

    Stream<QuerySnapshot> allUsers =
        db.collection("users").where('id', whereNotIn: nonFriends).snapshots();
    return allUsers;
  }

  void updateUserCollection(String? id, updates) async {
    await db.collection("users").doc(id).update(updates);
  }

  Future<UserModel> getOtherUser(
    String? id,
  ) async {
    DocumentSnapshot uModel = await getuserInfo(id!);
    UserModel userModel =
        UserModel.fromJson(uModel.data() as Map<String, dynamic>);
    return userModel;
  }

  Future<String> addSentFriendRequest(
      String? userId, String? id, List updatedList) async {
    try {
      //adding sent FR in the user
      updateUserCollection(userId, {'sentFriendRequest': updatedList});

      UserModel userModel = await getOtherUser(id);
      userModel.receivedFriendRequest?.add(userId);

      //adding the user id to the othre user
      updateUserCollection(
          id, {'receivedFriendRequest': userModel.receivedFriendRequest});

      return "Successfully add Sent a request!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<String> cancelSentFriendRequest(
      String? userId, String? id, List updatedList) async {
    try {
      //removed sent FR in the user
      await db
          .collection("users")
          .doc(userId)
          .update({'sentFriendRequest': updatedList});

      DocumentSnapshot uModel = await getuserInfo(id!);
      UserModel userModel =
          UserModel.fromJson(uModel.data() as Map<String, dynamic>);

      userModel.receivedFriendRequest?.remove(userId);

      //removing the send FR from the othser uesr
      await db
          .collection("users")
          .doc(id)
          .update({'receivedFriendRequest': userModel.receivedFriendRequest});

      return "Successfully cancel a Sent request!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<String> acceptFriendRequest(String? userId, String? id,
      List updatedFriendRequestList, List updatedFriendList) async {
    print("to Accepting: ${id}");
    try {
      //adding the user to the friends list
      await db.collection("users").doc(userId).update({
        'receivedFriendRequest': updatedFriendRequestList,
        'friends': updatedFriendList
      });

      DocumentSnapshot uModel = await getuserInfo(id!);
      UserModel userModel =
          UserModel.fromJson(uModel.data() as Map<String, dynamic>);

      // for the other user
      userModel.friends?.add(userId);
      userModel.receivedFriendRequest?.remove(userId);

      await db.collection("users").doc(id).update({
        'friends': userModel.friends,
        'sentFriendRequest': userModel.receivedFriendRequest
      });

      return "Successfully Sent a request!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<String> cancelFriendRequest(
      String? userId, String? id, List updatedFriendRequestList) async {
    print("to canceling friend request: ${id}");
    try {
      //removing the FR from the user
      await db.collection("users").doc(userId).update({
        'receivedFriendRequest': updatedFriendRequestList,
      });

      DocumentSnapshot uModel = await getuserInfo(id!);
      UserModel userModel =
          UserModel.fromJson(uModel.data() as Map<String, dynamic>);

      userModel.sentFriendRequest?.remove(userId);

      //removing th sent FR from the other user
      await db
          .collection("users")
          .doc(id)
          .update({'sentFriendRequest': userModel.receivedFriendRequest});

      return "Successfully cancel a friend request!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Future<String> unfriend(
      String? userId, String? id, List updatedFriendList) async {
    print("Unfriending: ${id}");
    try {
      //removing the friends list in the user id
      await db.collection("users").doc(userId).update({
        'friends': updatedFriendList,
      });

      DocumentSnapshot uModel = await getuserInfo(id!);
      UserModel userModel =
          UserModel.fromJson(uModel.data() as Map<String, dynamic>);

      userModel.friends?.remove(userId);

      //removing the friends list in the other user
      await db.collection("users").doc(id).update({
        'friends': userModel.friends,
      });

      return "Successfully Unfriended!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }
}
