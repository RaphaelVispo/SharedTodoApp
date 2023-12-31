/*
  Author: Raphael S. Vispo
  Section: D3L
  Date created: 18/ 11 /2022 
  Exercise number: 7
  Program Description:Todo app with the user authentication 
  and test cases
*/

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:location/location.dart';
import 'package:week7_networking_discussion/api/firebase_auth_api.dart';
import 'package:provider/provider.dart';
import 'package:week7_networking_discussion/providers/user_providers.dart';

class AuthProvider with ChangeNotifier {
  late FirebaseAuthAPI authService;
  User? userObj; //user from auth

  AuthProvider() {
    authService = FirebaseAuthAPI();
    authService.getUser().listen((User? newUser) {
      userObj = newUser;
      print('AuthProvider - FirebaseAuth - onAuthStateChanged - ${newUser?.uid}');

      notifyListeners();
    }, onError: (e) {
      // provide a more useful error
      print('AuthProvider - FirebaseAuth - onAuthStateChanged - $e');
    });
  
  }

  User? get user => userObj;

  bool get isAuthenticated {
    return user != null;
  }

  Future<String> signIn(String email, String password) {
    return authService.signIn(email, password);
  }

  void signOut() {
    authService.signOut();
  }

  Future<String> signUp(String email, String password, String firstName, String lastName,
      DateTime birthdayDate, LocationData location, String bio) async{
    return authService.signUp(
        email, password, firstName, lastName, birthdayDate, location, bio);
  }
}
