import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:im_social/widget/post/imageview.dart';
import './delete_edit_post.dart';

class PostWidget extends StatefulWidget {
  final String userName;
  final String userImage;
  final String postImage;
  final String postText;
  final bool isUserPost;
  final String postId;
  final String postLikes;
  final String userId;
  // const PostWidget({super.key});
  PostWidget(
      {required this.userImage,
      required this.userName,
      required this.postImage,
      required this.postText,
      required this.isUserPost,
      required this.postId,
      required this.postLikes,
      required this.userId});

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  var isLiked = false;
  void _postLiked() {
    var Likes = int.parse(widget.postLikes);

    FirebaseFirestore.instance
        .collection("userLikePost")
        .doc(widget.userId)
        .collection(widget.postId)
        .add({"isliked": isLiked, "timeStamp": Timestamp.now()});

    // .update({widget.postId: true});
    // .set({widget.postId: true})
    if (isLiked) {
      Likes = Likes + 1;
    } else {
      Likes = Likes - 1;
    }

    FirebaseFirestore.instance
        .collection("allPosts")
        .doc(widget.postId)
        .update({"totalLikes": Likes});
    // .set({"totalLikes": Likes + 1});
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20, left: 15, right: 15),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(widget.userImage),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.userName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const Text(
                            "10 min ago",
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      )
                    ],
                  ),
                  // IconButton(
                  // onPressed: () {

                  widget.isUserPost
                      ? DeleteEditPost(widget.postId, context, widget.postText,
                          widget.postImage)
                      : Container()
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Align(alignment: Alignment.topLeft, child: Text(widget.postText)),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.of(context)
                .pushNamed(ImageView.routename, arguments: widget.postImage);
          },
          child: Image(
            image: NetworkImage(widget.postImage),
            fit: BoxFit.cover,
            width: width,
            height: height * 0.35,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        // Padding(
        //   padding: const EdgeInsets.only(left: 60),
        //   child: Align(alignment: Alignment.centerLeft, child: Text("100")),
        // ),
        // Divider(),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('userLikePost')
                    .doc(widget.userId)
                    .collection(widget.postId)
                    .orderBy('timeStamp')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final chatDoc = snapshot.data!.docs;
                  if (chatDoc.isNotEmpty) {
                    isLiked = chatDoc.last["isliked"];
                    // [0]["isliked"];
                  }

                  return Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            setState(() {
                              isLiked = !isLiked;
                            });
                            _postLiked();
                          },
                          icon: isLiked
                              ? const Icon(
                                  Icons.thumb_up_alt_outlined,
                                  color: Colors.blue,
                                )
                              : const Icon(Icons.thumb_up_alt_outlined)),
                      Text(widget.postLikes)
                    ],
                  );
                }),
            const Icon(Icons.insert_comment_outlined)
          ],
        ),
        // const Divider(
        //   color: Colors.black,
        // )
        // Container(
        //   decoration: BoxDecoration(
        //       border: Border(bottom: BorderSide(color: Colors.black))),
        // )
      ],
    );
  }
}
