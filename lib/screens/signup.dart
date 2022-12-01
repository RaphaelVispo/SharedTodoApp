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
import 'package:date_field/date_field.dart';
import 'package:location/location.dart';
import 'package:week7_networking_discussion/providers/user_providers.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController firstNameController = TextEditingController();
    TextEditingController lastNameController = TextEditingController();
    DateTime? birthdayDate;
    Location userLocation = new Location();

    final birthday = DateTimeFormField(
      decoration: const InputDecoration(
        hintStyle: TextStyle(color: Colors.black45),
        errorStyle: TextStyle(color: Colors.redAccent),
        border: OutlineInputBorder(),
        suffixIcon: Icon(Icons.event_note),
      ),
      mode: DateTimeFieldPickerMode.date,
      autovalidateMode: AutovalidateMode.always,
      validator: (e) => (e?.day ?? 0) == 1 ? 'Please not the first day' : null,
      onDateSelected: (DateTime value) {
        print(value);
        birthdayDate = value;
      },
    );

    final email = TextFormField(
      key: const Key("emailkeysignup"),
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
        if (!RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(value)) {
          return 'Invalid Email';
        }

        return null;
      },
    );

    final password = TextFormField(
      key: const Key("passwordkeysignup"),
      controller: passwordController,
      obscureText: true,
      decoration: const InputDecoration(
        hintText: 'Password',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        if (value.length <= 8) {
          return 'The length should be more than 8';
        }
        return null;
      },
      onChanged: (value) {
        _formKey.currentState!.validate();
      },
    );

    final firstName = TextFormField(
      key: const Key("firstnamekeysignup"),
      controller: firstNameController,
      decoration: const InputDecoration(
        hintText: 'First Name',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }

        return null;
      },
      onChanged: (value) {
        _formKey.currentState!.validate();
      },
    );

    final lastName = TextFormField(
      key: const Key("lastnamekeysignup"),
      controller: lastNameController,
      decoration: const InputDecoration(
        hintText: 'Last Name',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }

        return null;
      },
      onChanged: (value) {
        _formKey.currentState!.validate();
      },
    );

    final SignupButton = Padding(
      key: const Key("signupbuttonnamekeysignup"),
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        key: const Key("signup"),
        onPressed: () async {
          //call the auth provider here
          if (_formKey.currentState!.validate()) {
            LocationData location = await userLocation.getLocation();
            context.read<AuthProvider>().signUp(
                emailController.text,
                passwordController.text,
                firstNameController.text,
                lastNameController.text,
                birthdayDate!,
                location);
            //context.read<UserProvider>();
            Navigator.pop(context);
          }
        },
        child: const Text('Sign up', style: TextStyle(color: Colors.white)),
      ),
    );

    final backButton = Padding(
      key: const Key("backbuttonnamekeysignup"),
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () async {
          Navigator.pop(context);
        },
        child: const Text('Back', style: TextStyle(color: Colors.white)),
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
              "Sign Up",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25),
            ),
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    email,
                    password,
                    firstName,
                    lastName,
                    birthday,
                    SignupButton,
                    backButton
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
