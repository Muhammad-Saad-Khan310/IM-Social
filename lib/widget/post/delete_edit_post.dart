import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:im_social/widget/addPost/addPost.dart';

List<String> _items = ["Delete"];
var selectedValue = "Delete";

Widget DeleteEditPost(
    String postId, BuildContext ctx, String postText, String imageUrl) {
  return DropdownButton<String>(
    onChanged: (String? newValue) async {
      // setState(() {
      // selectedValue = newValue!;

      if (newValue == 'Delete') {
        await FirebaseFirestore.instance
            .collection('allPosts')
            .doc(postId)
            .delete()
            .then((value) {
          final snackBar = SnackBar(
            content: Text("Your post deleted successfully"),
            // backgroundColor: Theme.of(context).errorColor,
          );
          ScaffoldMessenger.of(ctx).showSnackBar(snackBar);
        });

        // print(postId);
      }

      // });
    },
    value: selectedValue,
    items: _items.map<DropdownMenuItem<String>>(
      (String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      },
    ).toList(),
  );
}
