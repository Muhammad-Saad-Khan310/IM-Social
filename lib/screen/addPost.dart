import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:im_social/screen/postScreen.dart';
import 'package:im_social/widget/addPost/addPost.dart';

class AddPostScreen extends StatefulWidget {
  static const routeName = "/add-post";
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  var userId;
  var _isLoading = false;

  @override
  void initState() {
    userId = FirebaseAuth.instance.currentUser!.uid.toString();
    // TODO: implement initState
    super.initState();
  }

  void _submitPost(String username, String userimage, String postText,
      String userId, File postImage) async {
    try {
      setState(() {
        _isLoading = true;
      });

      final ref = FirebaseStorage.instance
          .ref()
          .child('post_image')
          .child(DateTime.now().toString());
      await ref.putFile(postImage);
      final url = await ref.getDownloadURL();

      await FirebaseFirestore.instance.collection('allPosts').add({
        'userId': userId,
        'username': username,
        'userimage': userimage,
        'imageurl': url,
        'postText': postText,
        'createdAt': Timestamp.now(),
        'totalLikes': 0
      }).then((value) {
        Navigator.of(context).pushNamed(PostScreen.routeName);
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(child: AddPost(_submitPost, userId, _isLoading)),
    );
  }
}
