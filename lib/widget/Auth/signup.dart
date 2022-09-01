import 'dart:io';

import 'package:flutter/material.dart';
import 'package:im_social/screen/loginScreen.dart';
import 'package:image_picker/image_picker.dart';

class Signup extends StatefulWidget {
  Signup(this.submitfn, this.isLoading);

  final void Function(
    String email,
    String password,
    String name,
    BuildContext ctx,
    File image,
  ) submitfn;
  final bool isLoading;

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();

  var email = "";
  var username = "";
  var password = "";
  File? _pickedImage;

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    if (_pickedImage == null) {
      const snackBar = SnackBar(
        content: Text("Please, select an image"),
        // backgroundColor: Theme.of(context).errorColor,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    widget.submitfn(
      email.trim(),
      password.trim(),
      username,
      context,
      _pickedImage!,
    );
  }

  void _pickImage() async {
    final image = await ImagePicker().pickImage(
        source: ImageSource.gallery, imageQuality: 50, maxWidth: 150);
    setState(() {
      _pickedImage = File(image!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.only(left: 15, right: 15, top: 120),
        child: Column(
          children: [
            const Text(
              "SignUp",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(
              height: 30,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage:
                        _pickedImage != null ? FileImage(_pickedImage!) : null,
                    // backgroundColor: _pickedImage  Colors.indigo,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // IconButton(on , Icons.image),

                      const Icon(Icons.image),

                      TextButton(
                          onPressed: () {
                            _pickImage();
                          },
                          child: Text("Add image"))
                    ],
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: "Email",
                      icon: Icon(Icons.email),
                    ),
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please Enter Email";
                      }
                    },
                    onSaved: (value) {
                      email = value!;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: "User Name",
                      icon: Icon(Icons.person),
                    ),
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please Enter Name";
                      }
                    },
                    onSaved: (value) {
                      username = value!;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: "Password",
                      icon: Icon(Icons.lock),
                    ),
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please Enter Password";
                      }
                    },
                    onSaved: (newValue) {
                      password = newValue!;
                    },
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(LoginScreen.routeName);
                      },
                      child: const Text("Already account?"),
                    ),
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  if (widget.isLoading) const CircularProgressIndicator(),
                  if (!widget.isLoading)
                    ElevatedButton(
                        onPressed: () {
                          _submit();
                        },
                        child: const Text("Signup"))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
