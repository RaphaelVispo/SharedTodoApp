import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:week7_networking_discussion/screens/signup.dart';
import 'package:week7_networking_discussion/providers/auth_provider.dart';
import 'package:provider/provider.dart';

void main() {
  // Define a test
  group("Sign up widget: ", (() {
    testWidgets('Sign up Widgets if Existed', (tester) async {
      // Create the widget by telling the tester to build it along with the provider the widget requires

      await tester.pumpWidget(MaterialApp(home: SignupPage()));
      //find the widgets by the text or by their keys
      final screenDisplay = find.text('Sign Up');
      final userNameField = find.byKey(const Key("emailkeysignup"));
      final passwordField = find.byKey(const Key("passwordkeysignup"));
      final firstNameField = find.byKey(const Key("firstnamekeysignup"));
      final lastwordField = find.byKey(const Key("lastnamekeysignup"));
      final signUpButton = find.byKey(const Key("signupbuttonnamekeysignup"));
      final backButton = find.byKey(const Key("backbuttonnamekeysignup"));

      // Use the `findsOneWidget` matcher provided by flutter_test to
      // verify that the Text widgets and Button widgets appear exactly once in the widget tree.
      expect(screenDisplay, findsOneWidget);
      expect(userNameField, findsOneWidget);
      expect(passwordField, findsOneWidget);
      expect(firstNameField, findsOneWidget);
      expect(lastwordField, findsOneWidget);

      expect(signUpButton, findsOneWidget);
      expect(backButton, findsOneWidget);
    });

    testWidgets("All valid inputs", ((tester) async {
      await tester.pumpWidget(MultiProvider(
              providers: [
                ChangeNotifierProvider(create: ((context) => AuthProvider())),
              ],
              child: MaterialApp(home: SignupPage()),

      ));

      final userNameField = find.byKey(const Key("emailkeysignup"));
      final passwordField = find.byKey(const Key("passwordkeysignup"));
      final firstNameField = find.byKey(const Key("firstnamekeysignup"));
      final lastwordField = find.byKey(const Key("lastnamekeysignup"));

      await tester.enterText(userNameField, "rap@gmail.com");
      await tester.enterText(passwordField, "1234567");
      await tester.enterText(firstNameField, "Raphael");
      await tester.enterText(lastwordField, "Vispo");

      final signUpButton = find.byKey(const Key("signup"));
      final emailErrorFinder = find.text('Invalid Email');
      final passwordErrorFinder = find.text('The length should be more than 8');
      final nullError = find.text('Please enter some text');

      await tester.tap(signUpButton);

      await tester.pump(const Duration(milliseconds: 500));
      expect(emailErrorFinder, findsNothing);
      expect(passwordErrorFinder, findsNothing);
      expect(nullError, findsNothing);

      // expect(find.text('Todo'), findsOneWidget);
    }));
    testWidgets("Error when input is null", ((tester) async {
      await tester.pumpWidget(MaterialApp(home: SignupPage()));

      final signUpButton = find.byKey(const Key("signup"));
      final emailErrorFinder = find.text('Please enter some text');

      await tester.tap(signUpButton);

      await tester.pump(const Duration(milliseconds: 100));
      expect(emailErrorFinder, findsWidgets);
    }));

    testWidgets("Error when input is invalid email and password",
        ((tester) async {
      await tester.pumpWidget(MaterialApp(home: SignupPage()));

      final userNameField = find.byKey(const Key("emailkeysignup"));
      final passwordField = find.byKey(const Key("passwordkeysignup"));
      final firstNameField = find.byKey(const Key("firstnamekeysignup"));
      final lastwordField = find.byKey(const Key("lastnamekeysignup"));

      await tester.enterText(userNameField, "rap");
      await tester.enterText(passwordField, "not");
      await tester.enterText(firstNameField, "Raphael");
      await tester.enterText(lastwordField, "Vispo");

      final signUpButton = find.byKey(const Key("signup"));
      final emailErrorFinder = find.text('Invalid Email');
      final passwordErrorFinder = find.text('The length should be more than 8');

      await tester.tap(signUpButton);

      await tester.pump(const Duration(milliseconds: 100));
      expect(emailErrorFinder, findsOneWidget);
      expect(passwordErrorFinder, findsOneWidget);
    }));
  }));
}
