import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:week7_networking_discussion/main.dart' as app;
import 'package:flutter/material.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('end-to-end test', () {
    testWidgets('Test Signup button', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      final screenDisplay = find.text('Login');
      final userNameField = find.byKey(const Key("emailField"));
      final passwordField = find.byKey(const Key("pwField"));
      final loginButton = find.byKey(const Key("loginButton"));
      final signUpButton = find.byKey(const Key("signUpButton"));

// Use the `findsOneWidget` matcher provided by flutter_test to
// verify that the Text widgets and Button widgets appear exactly once in the widget tree.
      expect(screenDisplay, findsOneWidget);
      expect(userNameField, findsOneWidget);
      expect(passwordField, findsOneWidget);
      expect(loginButton, findsOneWidget);
      expect(signUpButton, findsOneWidget);

      await tester.tap(signUpButton);
      await tester.pumpAndSettle();

      final signupDisplay = find.text("Sign Up");
      expect(signupDisplay, findsOneWidget);
    });
  });
}

