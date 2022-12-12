/*
  Author: Raphael S. Vispo
  Section: D3L
  Date created: 18/ 11 /2022 
  Exercise number: 7
  Program Description:Todo app with the user authentication 
  and test cases
*/


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

class FirebaseNotificationAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  //final db = FakeFirebaseFirestore();


  Future<String> addNotification(Map<String, dynamic> notifications) async {
    try {
      final docRef = await db.collection("notifications").add(notifications);
      await db.collection("notifications").doc(docRef.id).update({'id': docRef.id});

      return "Successfully added notifications!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Stream<QuerySnapshot> getAllNotification() {
    return db.collection("notifications").snapshots();
  }


  Future<String> editNotification(Map<String, dynamic> notif) async {
    try {
      await db.collection("notifications").doc(notif["id"]).update(notif);

      return "Successfully edit todo!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }


}
