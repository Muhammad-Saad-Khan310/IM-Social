import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:im_social/screen/postScreen.dart';

import '../widget/addPost/addPost.dart';
import '../widget/post/post.dart';

class UserPostScreen extends StatefulWidget {
  static const routeName = "user_post";
  const UserPostScreen({super.key});

  @override
  State<UserPostScreen> createState() => _UserPostScreenState();
}

class _UserPostScreenState extends State<UserPostScreen> {
  var userId;

  @override
  void initState() {
    userId = FirebaseAuth.instance.currentUser!.uid.toString();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Your Posts",
        ),
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          DropdownButton(
              icon: const Icon(Icons.more_vert),
              items: [
                DropdownMenuItem(
                  child: Container(
                    child: Row(
                      children: [
                        const Icon(Icons.exit_to_app),
                        const SizedBox(
                          width: 8,
                        ),
                        const Text("Logout")
                      ],
                    ),
                  ),
                  value: 'logout',
                )
              ],
              onChanged: (itemIdentifier) {
                if (itemIdentifier == 'logout') {
                  FirebaseAuth.instance.signOut();
                }
              })
        ],
      ),
      bottomNavigationBar: Container(
        height: 50,
        color: Colors.indigo,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(PostScreen.routeName);
            },
            icon: const Icon(
              Icons.home,
            ),
          ),
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AddPost.routeName);
              },
              icon: const Icon(Icons.add)),
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.person,
                color: Colors.white,
              ))
        ]),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('allPosts').snapshots(),
          builder: (context, postSnapshot) {
            if (postSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            var lst = [];
            final postDoc = postSnapshot.data!.docs;
            for (var element in postDoc) {
              if (element['userId'] == userId) {
                final existingIndex = postDoc
                    .indexWhere((element) => element['userId'] == userId);
                // final element = postDoc[existingIndex];

                // postDoc.removeAt(existingIndex);
                lst.add(element);
                // postDoc.remove(element);

              }
            }

            return SizedBox(
              height: height,
              child: lst.isEmpty
                  ? const Center(
                      child: Text("No Post found"),
                    )
                  : ListView.builder(
                      itemCount: lst.length,
                      itemBuilder: (ctx, i) {
                        return PostWidget(
                          postId: lst[i].id,
                          userImage: lst[i]['userimage'],
                          userName: lst[i]['username'],
                          postImage: lst[i]['imageurl'],
                          postText: lst[i]['postText'],
                          isUserPost: true,
                          postLikes: lst[i]["totalLikes"].toString(),
                          userId: userId,
                        );
                      }),
            );
          }),
    );
  }
}
