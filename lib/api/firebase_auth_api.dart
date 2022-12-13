/*
  Author: Raphael S. Vispo
  Section: D3L
  Date created: 18/ 11 /2022 
  Exercise number: 7
  Program Description:Todo app with the user authentication 
  and test cases
*/

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:location/location.dart';

class FirebaseAuthAPI {
  static final FirebaseAuth auth = FirebaseAuth.instance;

  static final FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuthAPI();

  // final db = FakeFirebaseFirestore();

  // final auth = MockFirebaseAuth(
  //     mockUser: MockUser(
  //   isAnonymous: false,
  //   uid: '38nlhqZo2VUCuveb8hiwSWKi4K92',
  //   email: 'user@gmail.com',
  //   displayName: 'User User',
  // ));

  Stream<User?> getUser() {
    return auth.authStateChanges();
  }

  Future<String> signIn(String email, String password) async {
    UserCredential credential;
    String comment = "";
    try {
      final credential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      comment = "userAuthenticated";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        //possible to return something more useful
        //than just print an error message to improve UI/UX
        print('No user found for that email.');
        comment = e.code;
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        comment = e.code;
      }
    }
    return comment;
  }

  void signUp(String email, String password, String firstName, String lastName,
      DateTime birthdayDate, LocationData location, String bio) async {
    UserCredential credential;
    try {
      credential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user != null) {
        saveUserToFirestore(credential.user?.uid, email, firstName, lastName,
            birthdayDate, location, bio);
      }

      print('The uiid = ${credential.user?.uid}');
    } on FirebaseAuthException catch (e) {
      //possible to return something more useful
      //than just print an error message to improve UI/UX
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  void signOut() async {
    auth.signOut();
  }

  //for adding extra more info aside from the auth
  void saveUserToFirestore(
      String? uid,
      String email,
      String firstName,
      String lastName,
      DateTime birthdayDate,
      LocationData location,
      String bio) async {
    try {
      await db.collection("users").doc(uid).set({
        "id": uid,
        "email": email,
        "firstName": firstName,
        "lastName": lastName,
        "birthday": birthdayDate,
        "location": {
          "longitude": location.longitude,
          "latitude": location.latitude
        },
        "receivedFriendRequest": ["0"],
        "sentFriendRequest": ["0"],
        "friends": ["0"],
        "todo": ["0"],
        "sharedTodo": ["0"],
        "bio": bio,
      });
    } on FirebaseException catch (e) {
      print(e.message);
    }
  }
}
