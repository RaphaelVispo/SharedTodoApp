/*
  Author: Raphael S. Vispo
  Section: D3L
  Date created: 18/ 11 /2022 
  Exercise number: 7
  Program Description:Todo app with the user authentication 
  and test cases
*/

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week7_networking_discussion/providers/auth_provider.dart';
import 'package:week7_networking_discussion/screens/signup.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    final _formKey = GlobalKey<FormState>();

    final email = TextFormField(
      key: const Key('emailField'),
      controller: emailController,
      decoration: const InputDecoration(
        hintText: "Email",
      ),
      onChanged: (value) {
        _formKey.currentState!.validate();
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value)){
          return 'Invalid Email';
        }
        return null;
      },
    );

    final password = TextFormField(
      key: const Key('pwField'),
      controller: passwordController,
      obscureText: true,
      decoration: const InputDecoration(
        hintText: 'Password',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        if (value.length < 8) {
          return 'The length should be more than 7';
        }
        return null;
      },
      onChanged: (value) {
        _formKey.currentState!.validate();
      },
    );

        Future<void> _showMyDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Incorrect Password'),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text('Wrong Password'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    final loginButton = Padding(
      key: const Key('loginButton'),
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () async{
          if (_formKey.currentState!.validate()){
          String  message = await context
            .read<AuthProvider>()
            .signIn(emailController.text, passwordController.text);

          print(message);
          if (message=='wrong-password'){
            _showMyDialog();
          }

          }
        },
        child: const Text('Log In', style: TextStyle(color: Colors.white)),
      ),
    );



    final signUpButton = Padding(
      
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        key: const Key('signUpButton'),
        onPressed: () async {

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const SignupPage(),
            ),
          );
        },
        child: const Text('Sign Up', style: TextStyle(color: Colors.white)),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.only(left: 40.0, right: 40.0),
          children: <Widget>[
            const Text(
              "Login",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25),
            ), Form(
              key: _formKey,
              child: Column(children: [
              email,
              password,
              loginButton,
              signUpButton,
            ],))

          ],
        ),
      ),
    );
  }
}
