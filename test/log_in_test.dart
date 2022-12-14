import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:week7_networking_discussion/screens/login.dart';
import 'package:week7_networking_discussion/screens/signup.dart';
import 'package:week7_networking_discussion/providers/auth_provider.dart';
import 'package:provider/provider.dart';

void main() {
  // Define a test
  group("Log in widget: ", (() {


    testWidgets("All valid inputs", ((tester) async {
      await tester.pumpWidget(MultiProvider(
              providers: [
                ChangeNotifierProvider(create: ((context) => AuthProvider())),
              ],
              child: MaterialApp(home: LoginPage()),

      ));

      final userNameField = find.byKey(const Key("emailField"));
      final passwordField = find.byKey(const Key("pwField"));

    
      await tester.enterText(userNameField, "user@gmail.com");
      await tester.enterText(passwordField, "1111111!Aa");

      final loginButton = find.byKey(const Key("loginButton"));
      final emailErrorFinder = find.text('Invalid Email');
      final passwordErrorFinder = find.text('The length should be more than 7');

      await tester.tap(loginButton);
      await tester.pump(const Duration(milliseconds: 1000));
      expect(emailErrorFinder, findsNothing);
      expect(passwordErrorFinder, findsNothing);

      
    }));

    testWidgets("Checker if the the widget exists", ((tester) async {
      await tester.pumpWidget(MultiProvider(
              providers: [
                ChangeNotifierProvider(create: ((context) => AuthProvider())),
              ],
              child: MaterialApp(home: LoginPage()),

      ));

      final loginButton = find.byKey(const Key("loginButton"));
      final userNameField = find.byKey(const Key("emailField"));
      final passwordField = find.byKey(const Key("pwField"));

      await tester.tap(loginButton);

      await tester.pump(const Duration(milliseconds: 100));
      expect(userNameField, findsWidgets);
      expect(passwordField, findsWidgets);
    }));

    
    testWidgets("Error when input is null", ((tester) async {
      await tester.pumpWidget(MaterialApp(home: LoginPage()));

      final loginButton = find.byKey(const Key("loginButton"));
      final textErrorFinder = find.text('Please enter some text');


      await tester.tap(loginButton);

      await tester.pump(const Duration(milliseconds: 100));
      expect(textErrorFinder, findsWidgets);
    }));

    testWidgets("Error when input is invalid email and password",
        ((tester) async {
            await tester.pumpWidget(MultiProvider(
              providers: [
                ChangeNotifierProvider(create: ((context) => AuthProvider())),
              ],
              child: MaterialApp(home: LoginPage()),

      ));

      final userNameField = find.byKey(const Key("emailField"));
      final passwordField = find.byKey(const Key("pwField"));
      await tester.enterText(userNameField, "rap");
      await tester.enterText(passwordField, "not");


      final login = find.byKey(const Key("loginButton"));
      final emailErrorFinder = find.text('Invalid Email');
      final passwordErrorFinder = find.text('The length should be more than 7');
      
      await tester.tap(login);

      await tester.pump(const Duration(milliseconds: 100));
      
      expect(emailErrorFinder, findsOneWidget);
      expect(passwordErrorFinder, findsOneWidget);

    }));
  }));
}
