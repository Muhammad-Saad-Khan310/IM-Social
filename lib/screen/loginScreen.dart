import "package:flutter/material.dart";
import 'package:im_social/widget/Auth/login.dart';

import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = "login";
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // This will give us instance of firebase auth object
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  void _submitAuthForm(
    String email,
    String password,
    BuildContext ctx,
  ) async {
    UserCredential result;
    try {
      setState(() {
        _isLoading = true;
      });
      result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      // setState(() {
      //   _isLoading = false;
      // });
    } catch (err) {
      setState(() {
        _isLoading = false;
      });
      var message = err.toString().split(']');

      final snackBar = SnackBar(
        content: Text(message[1]),
        // backgroundColor: Theme.of(context).errorColor,
      );
      ScaffoldMessenger.of(ctx).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Login(_submitAuthForm, _isLoading),
    );
  }
}
