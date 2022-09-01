import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddPost extends StatefulWidget {
  static const routeName = "/add-post";
  final String userId;
  final bool isLoading;
  final void Function(
    String username,
    String userimage,
    String postText,
    String userId,
    File postImage,
  ) postfn;

  const AddPost(
    this.postfn,
    this.userId,
    this.isLoading,
  );

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var postText = "";
  bool isEmptyPost = true;
  File? _pickedImage;

  void _pickImage() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      _pickedImage = File(image!.path);
    });
  }

  void _submit(String name, String userimageUrl, String id) {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();

    if (_pickedImage == null && postText == "") {
      print("please add data");
      return;
    }

    widget.postfn(
      name,
      userimageUrl,
      postText,
      id,
      _pickedImage!,
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('user')
            .doc(widget.userId)
            .get(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return SingleChildScrollView(
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 0, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: Icon(Icons.arrow_back)),
                        const Text("Create Post"),
                        widget.isLoading
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : ElevatedButton(
                                onPressed:
                                    // isEmptyPost
                                    //     ? null
                                    //     :
                                    () {
                                  if (postText == "") {
                                    setState(() {
                                      isEmptyPost = true;
                                    });
                                  }
                                  // if (postText.isEmpty) {
                                  _submit(
                                      snapshot.data!['username'],
                                      snapshot.data!['imageUrl'],
                                      widget.userId);
                                  // }
                                  // print("post data is not empty");
                                },
                                child: const Text("POST"))
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20, left: 15, right: 15),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundImage:
                                  NetworkImage(snapshot.data!['imageUrl']),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              snapshot.data!['username'],
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Form(
                          key: _formKey,
                          child: TextFormField(
                            // controller: _controller,

                            decoration: InputDecoration(
                                hintText: "What's on your mind",
                                border: InputBorder.none),
                            maxLines: 3,
                            onSaved: ((value) {
                              postText = value!;
                              // setState(() {
                              //   postText = value;
                              // });
                            }),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                  ),

                  _pickedImage != null
                      ? GestureDetector(
                          onTap: () {
                            _pickImage();
                          },
                          child: Container(
                            width: double.infinity,
                            height: 300,
                            child: Image(
                              image: FileImage(_pickedImage!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : TextButton(
                          onPressed: () {
                            _pickImage();
                          },
                          child: const Text(
                            "Tap here to select an image",
                            style: TextStyle(color: Colors.grey),
                          ))

                  // Image(
                  //   image: NetworkImage(
                  //       "https://thumbs.dreamstime.com/b/scenic-view-moraine-lake-mountain-range-sunset-landscape-canadian-rocky-mountains-49666349.jpg"),
                  //   fit: BoxFit.cover,
                  //   width: width,
                  //   height: height * 0.25,
                  // ),
                ],
              ),
            ),
          );
        });
  }
}
