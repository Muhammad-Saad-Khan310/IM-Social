import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:im_social/screen/userPostScreen.dart';
import 'package:im_social/widget/addPost/addPost.dart';
import 'package:im_social/widget/post/post.dart';

class PostScreen extends StatefulWidget {
  static const routeName = "post_screen";
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  var userId;

  @override
  void initState() {
    userId = FirebaseAuth.instance.currentUser!.uid.toString();
    print(userId);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      bottomNavigationBar: Container(
        height: 50,
        color: Colors.indigo,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          const Icon(
            Icons.home,
            color: Colors.white,
          ),
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AddPost.routeName);
              },
              icon: const Icon(Icons.add)),
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(UserPostScreen.routeName);
              },
              icon: const Icon(Icons.person)),
        ]),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("All Posts"),
        // backgroundColor: Colors.white,
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('allPosts')
              .orderBy('createdAt')
              .snapshots(),
          builder: (context, postSnapshot) {
            if (postSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final postDoc = postSnapshot.data!.docs;

            return SizedBox(
              height: height,
              child: ListView.builder(
                  itemCount: postDoc.length,
                  itemBuilder: (ctx, i) {
                    return
                        //  PostWidget(userImage: "s", userName: "userName", postImage: "postImage", postText: "postText");
                        PostWidget(
                      postId: postDoc[i].id,
                      userImage: postDoc[i]['userimage'],
                      userName: postDoc[i]['username'],
                      postImage: postDoc[i]['imageurl'],
                      postText: postDoc[i]['postText'],
                      isUserPost: false,
                      postLikes: postDoc[i]["totalLikes"].toString(),
                      userId: userId,
                    );
                  }),
            );
          }),
    );
  }
}
