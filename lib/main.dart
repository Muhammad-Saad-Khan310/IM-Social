import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:im_social/screen/homeScreen.dart';
import 'package:im_social/screen/loginScreen.dart';
import 'package:im_social/screen/postScreen.dart';
import 'package:im_social/screen/signupScreen.dart';
import 'package:im_social/screen/userPostScreen.dart';
import 'package:im_social/widget/Auth/login.dart';
import 'package:im_social/widget/Auth/signup.dart';
import 'package:im_social/screen/addPost.dart';
import 'package:im_social/widget/post/imageview.dart';
import 'package:im_social/widget/post/post.dart';

// void main() {
//   runApp(const MyApp());
// }

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'IM Social',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, userSnapshot) {
          if (userSnapshot.hasData) {
            return const PostScreen();
          } else {
            print("I m not executing why");
            return LoginScreen();
          }
          // LoginScreen();
        },
      ),
      routes: {
        AddPostScreen.routeName: (context) => const AddPostScreen(),
        PostScreen.routeName: (context) => const PostScreen(),
        UserPostScreen.routeName: (context) => const UserPostScreen(),
        LoginScreen.routeName: (context) => LoginScreen(),
        SignupScreen.routeName: (context) => SignupScreen(),
        ImageView.routename: (context) => ImageView(),
      },
    );
  }
}
