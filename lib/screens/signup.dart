import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:week7_networking_discussion/providers/auth_provider.dart';

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

    final email = TextFormField(
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
        if (!value.contains('@')) {
          return 'Email is invalid, must contain @';
        }
        if (!value.contains('.')) {
          return 'Email is invalid, must contain .';
        }

        return null;
      },


    );

    final password = TextFormField(
      controller: passwordController,
      obscureText: true,
      decoration: const InputDecoration(
        hintText: 'Password',
      ),

      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        if (value.length <= 6) {
          return 'The length should be more than 6';
        }
        return null;
      },
      onChanged: (value) {
        _formKey.currentState!.validate();
      },

    );

    final SignupButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: () {
          //call the auth provider here
          if (_formKey.currentState!.validate()){
            context
                .read<AuthProvider>()
                .signUp(emailController.text, passwordController.text);
            Navigator.pop(context);
          }

        },
        child: const Text('Sign up', style: TextStyle(color: Colors.white)),
      ),
    );

    final backButton = Padding(
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
