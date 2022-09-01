import 'dart:io';

import "package:flutter/material.dart";
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:im_social/widget/Auth/signup.dart';

import 'package:firebase_auth/firebase_auth.dart';

class SignupScreen extends StatefulWidget {
  static const routeName = "signup";
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // This will give us instance of firebase auth object
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  void _submitAuthForm(
    String email,
    String password,
    String username,
    BuildContext ctx,
    File userImage,
  ) async {
    UserCredential result;
    try {
      setState(() {
        _isLoading = true;
      });
      result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final ref = FirebaseStorage.instance
          .ref()
          .child('user_image')
          .child(result.user!.uid);
      await ref.putFile(userImage);
      final url = await ref.getDownloadURL();

      FirebaseFirestore.instance.collection('user').doc(result.user!.uid).set({
        'username': username,
        'email': email,
        'imageUrl': url,
      });
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
      body: Signup(_submitAuthForm, _isLoading),
    );
  }
}
